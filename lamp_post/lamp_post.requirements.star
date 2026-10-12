BASE_DIAMETER = 0.36
BASE_HEIGHT = 0.35
SHAFT_DIAMETER = 0.12
GLASS_WIDTH = 0.30
GLASS_HEIGHT = 0.36
GLASS_DEPTH = 0.30
COLLAR_DIAMETER = 0.16
COLLAR_HEIGHT = 0.06
CAP_SIZE = 0.40
CAP_THICKNESS = 0.05
OVERALL_HEIGHT = 4.50
OVERALL_HEIGHT_MIN = 3.5
OVERALL_HEIGHT_MAX = 6.0
SEAT_AREA_MIN = 0.1

# Base
mo.assert_extent(id = "underside_on_ground", faces = ["post", "underside"], measure = "max_y", value = 0.0)
mo.assert_extent(id = "underside_flat", faces = ["post", "underside"], measure = "size_y", value = 0.0)
mo.assert_extent(id = "base_diameter_x", faces = ["post", "underside"], measure = "size_x", value = BASE_DIAMETER)
mo.assert_extent(id = "base_diameter_z", faces = ["post", "underside"], measure = "size_z", value = BASE_DIAMETER)
mo.assert_extent(id = "base_height", faces = ["post", "base"], measure = "max_y", value = BASE_HEIGHT)

# Shaft
mo.assert_extent(id = "shaft_diameter", faces = ["post", "shaft"], measure = "size_x", value = SHAFT_DIAMETER)
mo.assert_extent(id = "shaft_starts_at_base", faces = ["post", "shaft"], measure = "min_y", value = BASE_HEIGHT)
mo.assert_extent(id = "shaft_length", faces = ["post", "shaft"], measure = "size_y", value = mo.param_value("shaft_length"))

# Collar
mo.assert_extent(id = "collar_diameter", faces = ["post", "collar"], measure = "size_x", value = COLLAR_DIAMETER)
mo.assert_extent(id = "collar_height", faces = ["post", "collar"], measure = "size_y", value = COLLAR_HEIGHT)

# Lantern
mo.assert_extent(id = "glass_width", outputs = ["lantern"], measure = "size_x", value = GLASS_WIDTH)
mo.assert_extent(id = "glass_height", outputs = ["lantern"], measure = "size_y", value = GLASS_HEIGHT)
mo.assert_extent(id = "glass_depth", outputs = ["lantern"], measure = "size_z", value = GLASS_DEPTH)

# Cap
mo.assert_extent(id = "cap_width", faces = ["post", "cap"], measure = "size_x", value = CAP_SIZE)
mo.assert_extent(id = "cap_depth", faces = ["post", "cap"], measure = "size_z", value = CAP_SIZE)
mo.assert_extent(id = "cap_thickness", faces = ["post", "cap"], measure = "size_y", value = CAP_THICKNESS)

# Overall height over the knob's range
mo.assert_extent(id = "overall_height", outputs = ["post"], measure = "max_y", min = OVERALL_HEIGHT_MIN, max = OVERALL_HEIGHT_MAX)

# Centered on the post's axis
mo.assert_extent(id = "post_centered_x", outputs = ["post"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "post_centered_z", outputs = ["post"], measure = "center_z", value = 0.0)
mo.assert_extent(id = "cap_centered_x", faces = ["post", "cap"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "cap_centered_z", faces = ["post", "cap"], measure = "center_z", value = 0.0)
mo.assert_extent(id = "lantern_centered_x", outputs = ["lantern"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "lantern_centered_z", outputs = ["lantern"], measure = "center_z", value = 0.0)

# The lantern rests on the collar, the cap rests on the lantern
mo.assert_contact(id = "lantern_seated", outputs = ["post", "lantern"], min_area = SEAT_AREA_MIN)
mo.assert_mated(id = "lantern_on_collar", faces = [["lantern", "glass_bottom"], ["post", "collar_top"]])
mo.assert_mated(id = "cap_on_lantern", faces = [["post", "cap_underside"], ["lantern", "glass_top"]])

mo.budget(materials = 2)
