load("lib/bank.star", "flank", "on_lattice", "slope_sheet")
load("lib/materials.star", "BALLAST_UV_SCALE", "ballast", "earth")
load(
    "embankment.requirements.star",
    "BANK_LENGTH",
    "BED_HEIGHT",
    "BED_LENGTH",
    "BED_SINK_MAX",
    "BED_SINK_MIN",
    "BED_WIDTH",
    "CREST_HEIGHT",
    "CREST_WIDTH",
    "METER_GAUGE",
    "STONE_SINK_MAX",
    "STONE_SIZE_MAX",
    "STONE_SIZE_MIN",
    "TOE_Z",
)

GRID_STEP = 0.25
FLANK_EMBED = 0.05
RELIEF = struct(amplitude = 0.10, frequency = 0.6, octaves = 3, shoulder = 0.11)
STONE_SINK = 0.02
STONE_SEGMENTS = 6

crest_half = CREST_WIDTH / 2
bed_bottom = CREST_HEIGHT - (BED_SINK_MIN + BED_SINK_MAX) / 2
bed_top = bed_bottom + BED_HEIGHT

# Bank
crest = mo.transform(
    mo.box(id = "crest_box", size = [BANK_LENGTH, CREST_HEIGHT, CREST_WIDTH]),
    id = "crest_place",
    translate = [0.0, CREST_HEIGHT / 2, 0.0],
)
crest = mo.tag(crest, id = "crest_top", name = "top", select = {"normal_y": {"gt": 0.9}})
crest = mo.unwrap(crest, id = "crest_uv", uv_scale = 0.5)
crest = earth("crest_mat", crest)

flanks = {}
stone_targets = {}
for name, side, seed in [["flank_front", 1, 21], ["flank_back", -1, 22]]:
    relief = struct(amplitude = RELIEF.amplitude, frequency = RELIEF.frequency, octaves = RELIEF.octaves, shoulder = RELIEF.shoulder, seed = seed)
    solid = flank(name, side, BANK_LENGTH, crest_half, CREST_HEIGHT, TOE_Z, FLANK_EMBED, GRID_STEP, relief)
    flanks[name] = earth(name + "_mat", solid)
    stone_targets[name] = slope_sheet(
        name + "_stone_bed",
        side,
        on_lattice(crest_half + 0.8, GRID_STEP),
        on_lattice(TOE_Z - 0.8, GRID_STEP),
        on_lattice(BANK_LENGTH / 2 - 0.6, GRID_STEP),
        GRID_STEP,
        crest_half,
        CREST_HEIGHT,
        TOE_Z,
        relief,
    )

# Ballast bed, cast into the crest
bed = mo.transform(
    mo.box(id = "bed_box", size = [BED_LENGTH, BED_HEIGHT, BED_WIDTH]),
    id = "bed_place",
    translate = [0.0, bed_bottom + BED_HEIGHT / 2, 0.0],
)
bed = mo.unwrap(bed, id = "bed_uv", uv_scale = BALLAST_UV_SCALE)
bed = ballast("bed_mat", bed)
bed_surface = mo.transform(mo.grid(id = "bed_top_grid", size = [BED_LENGTH, BED_WIDTH]), id = "bed_top", translate = [0.0, bed_top, 0.0])

# Loose ballast: a faceted, flattened stone whose largest plan width
# (corner to corner) is STONE_SIZE_MAX at full scale; the smallest
# jitter keeps its narrowest plan width (flat to flat) 10% above
# STONE_SIZE_MIN, the margin a stone tilted on a flank loses in its
# bounds. Lifted so it sinks STONE_SINK at full scale.
stone_r = STONE_SIZE_MAX / 2
stone_flatten = 0.7
flat_to_flat = 2 * stone_r * math.cos(math.pi / STONE_SEGMENTS)
stone = mo.sphere(id = "stone_sphere", radius = stone_r, segments = STONE_SEGMENTS, rings = 4)
stone = mo.transform(stone, id = "stone_flatten", scale = [1.0, stone_flatten, 1.0])
stone = mo.smooth_normals(stone, id = "stone_facets", angle_max_deg = 20.0)
stone = mo.unwrap(stone, id = "stone_uv", uv_scale = BALLAST_UV_SCALE)
stone = mo.transform(stone, id = "stone_lift", translate = [0.0, stone_flatten * stone_r - STONE_SINK, 0.0])
stone = ballast("stone_mat", stone)
jitter = [1.1 * STONE_SIZE_MIN / flat_to_flat, 1.0]

bed_stones = mo.scatter(
    target = bed_surface, prototype = stone, id = "bed_stones", count = 400, seed = 101,
    align_normal = True, rand_yaw = True, scale_jitter = jitter,
)
flank_stones = {}
for name, seed in [["flank_front", 102], ["flank_back", 103]]:
    flank_stones[name] = mo.scatter(
        target = stone_targets[name], prototype = stone, id = name + "_stones", count = 90, seed = seed,
        align_normal = True, rand_yaw = True, scale_jitter = jitter,
    )

# Track: transforms stay authored, since no op places a referenced kit.
rails = mo.asset_ref(project = "track", output = "rails", id = "track_rails", overrides = {"gauge": METER_GAUGE})
sleepers = mo.asset_ref(project = "track", output = "sleepers", id = "track_sleepers", overrides = {"gauge": METER_GAUGE})
rails = mo.transform(rails, id = "rails_on_bed", translate = [0.0, bed_top, 0.0])
sleepers = mo.transform(sleepers, id = "sleepers_on_bed", translate = [0.0, bed_top, 0.0])

mo.output("crest", crest)
mo.output("flank_front", flanks["flank_front"])
mo.output("flank_back", flanks["flank_back"])
mo.output("ballast_bed", bed)
mo.output("bed_stones", bed_stones)
mo.output("flank_front_stones", flank_stones["flank_front"])
mo.output("flank_back_stones", flank_stones["flank_back"])
mo.output("rails", rails)
mo.output("sleepers", sleepers)

# Substitutes for "sinks no more than STONE_SINK_MAX into it": on the
# flat bed top each stone's depth is its own min_y; on a relief surface
# no per-copy measure exists, so the pair's embed depth (mean thickness
# over the union of stones) carries the bound.
mo.assert_extent(id = "bed_stones_sink", outputs = ["bed_stones"], measure = "min_y", every = True, min = bed_top - STONE_SINK_MAX)
mo.assert_embedded(id = "bed_stones_bedded", outputs = ["bed_stones", "ballast_bed"], min = 0, max = STONE_SINK_MAX)
for name in ["flank_front", "flank_back"]:
    mo.assert_embedded(id = name + "_stones_bedded", outputs = [name + "_stones", name], min = 0, max = STONE_SINK_MAX)
    mo.assert_extent(id = name + "_below_crest_top", outputs = [name], measure = "max_y", max = CREST_HEIGHT)
