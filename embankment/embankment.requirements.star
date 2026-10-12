BANK_LENGTH = 24.0
CREST_WIDTH = 4.40
CREST_HEIGHT = 1.20
TOE_Z = 6.0
BED_LENGTH = 23.96
BED_HEIGHT = 0.35
BED_WIDTH = 3.60
BED_SINK_MIN = 0.10
BED_SINK_MAX = 0.30
STONE_SIZE_MIN = 0.05
STONE_SIZE_MAX = 0.12
STONE_SINK_MAX = 0.03
BED_STONES_MIN = 300
FLANK_STONES_MIN = 60
STANDARD_GAUGE = 1.435
SLEEPER_SEAT_AREA = 0.25 * 2.60

# Bank
mo.assert_extent(id = "crest_length", outputs = ["crest"], measure = "size_x", value = BANK_LENGTH)
mo.assert_extent(id = "crest_width", outputs = ["crest"], measure = "size_z", value = CREST_WIDTH)
mo.assert_extent(id = "crest_top_height", faces = ["crest", "top"], measure = "max_y", value = CREST_HEIGHT)
mo.assert_extent(id = "crest_top_flat", faces = ["crest", "top"], measure = "size_y", value = 0.0)
mo.assert_extent(id = "crest_on_ground", outputs = ["crest"], measure = "min_y", value = 0.0)
mo.assert_extent(id = "crest_centered_x", outputs = ["crest"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "crest_centered_z", outputs = ["crest"], measure = "center_z", value = 0.0)
for flank, toe_measure, toe in [["flank_front", "max_z", TOE_Z], ["flank_back", "min_z", -TOE_Z]]:
    mo.assert_extent(id = flank + "_length", outputs = [flank], measure = "size_x", value = BANK_LENGTH)
    mo.assert_extent(id = flank + "_centered_x", outputs = [flank], measure = "center_x", value = 0.0)
    mo.assert_extent(id = flank + "_toe", outputs = [flank], measure = toe_measure, value = toe)
    mo.assert_extent(id = flank + "_on_ground", outputs = [flank], measure = "min_y", value = 0.0)
    mo.assert_embedded(id = flank + "_embeds_crest", outputs = ["crest", flank])

# Ballast bed, cast into the crest
mo.assert_extent(id = "bed_length", outputs = ["ballast_bed"], measure = "size_x", value = BED_LENGTH)
mo.assert_extent(id = "bed_height", outputs = ["ballast_bed"], measure = "size_y", value = BED_HEIGHT)
mo.assert_extent(id = "bed_width", outputs = ["ballast_bed"], measure = "size_z", value = BED_WIDTH)
mo.assert_extent(id = "bed_centered_x", outputs = ["ballast_bed"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "bed_centered_z", outputs = ["ballast_bed"], measure = "center_z", value = 0.0)
mo.assert_extent(
    id = "bed_cast_depth",
    outputs = ["ballast_bed"],
    measure = "min_y",
    min = CREST_HEIGHT - BED_SINK_MAX,
    max = CREST_HEIGHT - BED_SINK_MIN,
)
mo.assert_embedded(id = "bed_cast_into_crest", outputs = ["crest", "ballast_bed"])
mo.assert_contact(id = "bed_on_crest", outputs = ["crest", "ballast_bed"])

# Loose ballast
for stones, surface, least in [
    ["bed_stones", "ballast_bed", BED_STONES_MIN],
    ["flank_front_stones", "flank_front", FLANK_STONES_MIN],
    ["flank_back_stones", "flank_back", FLANK_STONES_MIN],
]:
    mo.assert_count(id = stones + "_count", outputs = [stones], min = least)
    mo.assert_contact(id = stones + "_touch", outputs = [stones, surface], every = [stones])
    mo.assert_extent(id = stones + "_size_x", outputs = [stones], measure = "size_x", every = True, min = STONE_SIZE_MIN, max = STONE_SIZE_MAX)
    mo.assert_extent(id = stones + "_size_z", outputs = [stones], measure = "size_z", every = True, min = STONE_SIZE_MIN, max = STONE_SIZE_MAX)
    mo.assert_embedded(id = stones + "_overlap_freely", outputs = [stones], self = True)
mo.assert_embedded(id = "bed_stones_in_sleepers", outputs = ["bed_stones", "sleepers"], min = 0)

# Track at standard gauge, centered on the bed, every sleeper on the bed's top
mo.assert_extent(id = "track_centered_x", outputs = ["sleepers"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "track_centered_z", outputs = ["sleepers"], measure = "center_z", value = 0.0)
mo.assert_extent(id = "rails_centered_x", outputs = ["rails"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "rails_centered_z", outputs = ["rails"], measure = "center_z", value = 0.0)
mo.assert_contact(id = "sleepers_on_bed", outputs = ["sleepers", "ballast_bed"], every = ["sleepers"], min_area = SLEEPER_SEAT_AREA)

mo.budget(materials = 4)
