load("lib/materials.star", "platform_concrete", "platform_edge", "tarmac")
load(
    "station.requirements.star",
    "BAND_THICKNESS",
    "BAND_WIDTH",
    "BAY_WIDTH",
    "CANOPY_HALF_SPAN",
    "END_BAY_WIDTH",
    "LAMP_CAST",
    "LAMP_HEIGHT",
    "LAMP_INSET",
    "LAMP_X",
    "LANTERN_GLOW",
    "PANEL_LENGTH",
    "PLATFORM_CENTER_Z",
    "PLATFORM_END_X",
    "PLATFORM_FRONT_Z",
    "PLATFORM_HEIGHT",
    "PLATFORM_LENGTH",
    "PLATFORM_TOP",
    "PLATFORM_WIDTH",
    "SLAB_DEPTH",
    "SLAB_LENGTH",
    "SLAB_THICKNESS",
    "SLAB_TOP",
    "STAIR_STEPS",
    "STANDARD_BAYS",
    "STANDARD_GAUGE",
    "STEP_GOING",
    "STEP_RISE",
    "STEP_WIDTH",
    "STRINGER_WIDTH",
)

CANOPY = "subassets/canopy_bay.star"
LINE_Z = 3.6
CANOPY_Z = 0.3
# lamp_post's base, collar, glass and cap: its overall height is the
# shaft_length knob plus these.
LAMP_FIXED_HEIGHT = 0.82
# lamp_post's default `glass_emissive`, the warm white the night glass scales.
LANTERN_WARM_WHITE = [1.0, 0.86, 0.66]
STEP_THICKNESS = 0.10

# Ground slab and platform
slab = mo.transform(
    mo.box(id = "slab_box", size = [SLAB_LENGTH, SLAB_THICKNESS, SLAB_DEPTH]),
    id = "slab_place",
    translate = [0.0, SLAB_THICKNESS / 2, 0.0],
)
slab = mo.tag(slab, id = "slab_top", name = "top", select = {"normal_y": {"gt": 0.9}})
slab = tarmac("slab_mat", slab)

platform = mo.box(id = "platform_box", size = [PLATFORM_LENGTH, PLATFORM_HEIGHT, PLATFORM_WIDTH])
platform = mo.tag(platform, id = "platform_top", name = "top", select = {"normal_y": {"gt": 0.9}})
platform = mo.tag(platform, id = "platform_end_pos_x", name = "end_pos_x", select = {"normal_x": {"gt": 0.9}})
platform = mo.unwrap(platform, id = "platform_uv", uv_scale = 1.0)
platform = platform_concrete("platform_mat", platform)
platform = mo.place(
    base = slab,
    part = platform,
    id = "platform",
    anchor = "top",
    mode = "on_top",
    offset = [0.0, 0.0, PLATFORM_FRONT_Z - PLATFORM_WIDTH / 2],
)

band = mo.box(id = "band_box", size = [PLATFORM_LENGTH, BAND_THICKNESS, BAND_WIDTH])
band = platform_edge("band_mat", band)
band = mo.place(
    base = platform,
    part = band,
    id = "safety_band",
    anchor = "top",
    mode = "on_top",
    offset = [0.0, 0.0, PLATFORM_FRONT_Z - BAND_WIDTH / 2],
)

# Stair at the platform's +X end: each stringer is a sawtooth whose
# column k carries step k (0 at the bottom). Each cutter clears
# everything above one seat and out past the foot, so the cuts nest
# and no cut face lands on an earlier one.
flight = STAIR_STEPS * STEP_GOING
stringer_height = STAIR_STEPS * STEP_RISE - STEP_THICKNESS
stringer = mo.transform(
    mo.box(id = "stringer_box", size = [flight, stringer_height, STRINGER_WIDTH]),
    id = "stringer_local",
    translate = [flight / 2, stringer_height / 2, 0.0],
)
for k in range(STAIR_STEPS - 1):
    seat = (k + 1) * STEP_RISE - STEP_THICKNESS
    start = (STAIR_STEPS - 1 - k) * STEP_GOING
    cutter = mo.transform(
        mo.box(id = "stringer_cutter_box_%d" % k, size = [flight - start + 0.1, stringer_height - seat + 0.1, STRINGER_WIDTH + 0.2]),
        id = "stringer_cutter_%d" % k,
        translate = [(start + flight + 0.1) / 2, (seat + stringer_height + 0.1) / 2, 0.0],
    )
    stringer = mo.boolean(stringer, cutter, id = "stringer_cut_%d" % k, mode = "difference")
stringer = mo.tag(stringer, id = "stringer_first_seat", name = "first_seat", select = {"normal_y": {"gt": 0.9}, "center_y": {"lt": STEP_RISE}})
stringer = mo.unwrap(stringer, id = "stringer_uv", uv_scale = 1.0)
stringer = platform_concrete("stringer_mat", stringer)
stringer = mo.place(
    base = slab,
    part = stringer,
    id = "stringer_place",
    anchor = "top",
    mode = "on_top",
    offset = [PLATFORM_END_X + flight / 2, 0.0, PLATFORM_CENTER_Z - (STEP_WIDTH - STRINGER_WIDTH) / 2],
)
# One prototype for both stringers, as two outputs so that each one's
# bearing under every step is judged on its own.
stringer_back = mo.array(stringer, id = "stair_stringer_back", count = 1)
stringer_front = mo.transform(stringer_back, id = "stair_stringer_front", translate = [0.0, 0.0, STEP_WIDTH - STRINGER_WIDTH])

step = mo.box(id = "step_box", size = [STEP_GOING, STEP_THICKNESS, STEP_WIDTH])
step = mo.tag(step, id = "step_tread", name = "tread", select = {"normal_y": {"gt": 0.9}})
step = mo.tag(step, id = "step_back", name = "back", select = {"normal_x": {"lt": -0.9}})
step = mo.unwrap(step, id = "step_uv", uv_scale = 1.0)
step = platform_concrete("step_mat", step)
step = mo.place(
    base = stringer,
    part = step,
    id = "step_place",
    anchor = "first_seat",
    mode = "on_top",
    offset = [0.0, 0.0, (STEP_WIDTH - STRINGER_WIDTH) / 2],
)
steps = mo.array(step, id = "stair_steps", count = STAIR_STEPS, step_translate = [-STEP_GOING, STEP_RISE, 0.0])

# Line: two track panels, end to end. Transforms stay authored, since
# no op places a referenced kit.
line = {}
for part in ["rails", "sleepers"]:
    panel = mo.asset_ref(project = "track", output = part, id = "track_" + part, overrides = {"gauge": STANDARD_GAUGE})
    panel = mo.transform(panel, id = "line_first_" + part, translate = [-PANEL_LENGTH / 2, SLAB_TOP, LINE_Z])
    line[part] = mo.array(panel, id = "line_" + part, count = 2, step_translate = [PANEL_LENGTH, 0.0, 0.0])

# Canopy: standard bays in the middle, a narrower bay at each end.
canopy = {}
for part in ["roofs", "columns"]:
    output = part[:-1] if part == "roofs" else part
    bay = mo.asset_ref(CANOPY, output, id = "bay_" + part, overrides = {"bay_width": BAY_WIDTH})
    bay = mo.transform(bay, id = "bay_first_" + part, translate = [-(STANDARD_BAYS - 1) * BAY_WIDTH / 2, PLATFORM_TOP, CANOPY_Z])
    canopy[part] = mo.array(bay, id = "canopy_" + part, count = STANDARD_BAYS, step_translate = [BAY_WIDTH, 0.0, 0.0])
    end_x = CANOPY_HALF_SPAN - END_BAY_WIDTH / 2
    end_bay = mo.asset_ref(CANOPY, output, id = "end_bay_" + part, overrides = {"bay_width": END_BAY_WIDTH})
    end_bay = mo.transform(end_bay, id = "end_bay_first_" + part, translate = [-end_x, PLATFORM_TOP, CANOPY_Z])
    canopy["end_" + part] = mo.array(end_bay, id = "canopy_end_" + part, count = 2, step_translate = [2 * end_x, 0.0, 0.0])

# Lamps, their bases cast into the platform: a pair beyond each end of
# the canopy
lamps = {}
for part in ["post", "lantern"]:
    lamp = mo.asset_ref(
        project = "lamp_post",
        output = part,
        id = "lamp_" + part,
        overrides = {
            "shaft_length": LAMP_HEIGHT - LAMP_FIXED_HEIGHT,
            "glass_emissive": [c * LANTERN_GLOW for c in LANTERN_WARM_WHITE],
        },
        material_rename = {"lamp_glass": "lamp_glass_night"} if part == "lantern" else {},
    )
    lamp = mo.transform(
        lamp,
        id = "lamp_first_" + part,
        translate = [LAMP_X[0], PLATFORM_TOP - LAMP_CAST, PLATFORM_FRONT_Z - PLATFORM_WIDTH + LAMP_INSET],
    )
    pair = mo.array(lamp, id = "lamp_" + part + "_pair", count = 2, step_translate = [LAMP_X[1] - LAMP_X[0], 0.0, 0.0])
    lamps[part] = mo.array(pair, id = "lamp_" + part + "s", count = 2, step_translate = [LAMP_X[2] - LAMP_X[0], 0.0, 0.0])

mo.output("slab", slab)
mo.output("platform", platform)
mo.output("safety_band", band)
mo.output("stair_steps", steps)
mo.output("stair_stringer_back", stringer_back)
mo.output("stair_stringer_front", stringer_front)
mo.output("line_rails", line["rails"])
mo.output("line_sleepers", line["sleepers"])
mo.output("canopy_roofs", canopy["roofs"])
mo.output("canopy_columns", canopy["columns"])
mo.output("canopy_end_roofs", canopy["end_roofs"])
mo.output("canopy_end_columns", canopy["end_columns"])
mo.output("lamp_posts", lamps["post"])
mo.output("lamp_lanterns", lamps["lantern"])

# The referenced kits' own joints, re-declared where they now stand.
mo.assert_contact(id = "rails_on_sleepers", outputs = ["line_rails", "line_sleepers"], every = ["line_rails", "line_sleepers"])
mo.assert_contact(id = "lanterns_on_posts", outputs = ["lamp_lanterns", "lamp_posts"], every = ["lamp_lanterns", "lamp_posts"])
mo.assert_contact(id = "roofs_on_columns", outputs = ["all_roofs", "all_columns"], every = ["all_roofs", "all_columns"])

# The canopy's front columns stay off the band (CANOPY_Z).
mo.group("lamps", ["lamp_posts", "lamp_lanterns"])
mo.assert_clearance(id = "roofs_clear_lamps", outputs = ["all_roofs", "lamps"], min = 0.02)
mo.assert_clearance(id = "columns_clear_band", outputs = ["all_columns", "safety_band"], min = 0.005)
