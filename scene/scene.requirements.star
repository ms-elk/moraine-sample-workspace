EMBANKMENT_CLEARANCE = 0.50
GROUND_Y = 0.0
# Restate the platform's back face (station: PLATFORM_FRONT_Z - PLATFORM_WIDTH)
# and the crest's length (embankment: BANK_LENGTH).
PLATFORM_BACK_Z = -2.0
CREST_LENGTH = 24.0

mo.group("embankment", [
    "embankment_crest",
    "embankment_flank_front",
    "embankment_flank_back",
    "embankment_ballast_bed",
    "embankment_bed_stones",
    "embankment_flank_front_stones",
    "embankment_flank_back_stones",
    "embankment_rails",
    "embankment_sleepers",
])

# Embankment behind the platform, moved along Z only, on the ground
mo.assert_extent(id = "embankment_behind_platform", outputs = ["embankment"], measure = "max_z", max = PLATFORM_BACK_Z)
mo.assert_extent(id = "crest_centered_x", outputs = ["embankment_crest"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "crest_along_x", outputs = ["embankment_crest"], measure = "size_x", value = CREST_LENGTH)
for part in ["crest", "flank_front", "flank_back"]:
    mo.assert_extent(id = part + "_on_ground", outputs = ["embankment_" + part], measure = "min_y", value = GROUND_Y)
mo.assert_clearance(id = "embankment_clear_of_slab", outputs = ["embankment", "slab"], min = EMBANKMENT_CLEARANCE)

mo.budget(materials = 10)
