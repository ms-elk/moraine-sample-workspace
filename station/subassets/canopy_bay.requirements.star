ROOF_THICKNESS = 0.10
ROOF_DEPTH = 3.40
ROOF_UNDERSIDE = 3.00
COLUMN_DIAMETER = 0.18
COLUMN_Z = 1.20
BAY_WIDTH = 4.0
BAY_WIDTH_MIN = 1.0
BAY_WIDTH_MAX = 4.0

# Roof
mo.assert_extent(id = "roof_thickness", outputs = ["roof"], measure = "size_y", value = ROOF_THICKNESS)
mo.assert_extent(id = "roof_depth", outputs = ["roof"], measure = "size_z", value = ROOF_DEPTH)
mo.assert_extent(id = "roof_width", outputs = ["roof"], measure = "size_x", value = mo.param_value("bay_width"))
mo.assert_extent(id = "roof_underside", outputs = ["roof"], measure = "min_y", value = ROOF_UNDERSIDE)
mo.assert_extent(id = "roof_centered_x", outputs = ["roof"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "roof_centered_z", outputs = ["roof"], measure = "center_z", value = 0.0)

# Columns, on the bay's centerline at z = +-COLUMN_Z, standing at the platform's top (y = 0)
mo.assert_count(id = "column_count", outputs = ["columns"], value = 2)
mo.assert_extent(id = "column_diameter_x", outputs = ["columns"], measure = "size_x", every = True, value = COLUMN_DIAMETER)
mo.assert_extent(id = "column_diameter_z", outputs = ["columns"], measure = "size_z", every = True, value = COLUMN_DIAMETER)
mo.assert_extent(id = "columns_on_centerline", outputs = ["columns"], measure = "center_x", every = True, value = 0.0)
mo.assert_extent(id = "column_back", outputs = ["columns"], measure = "min_z", value = -COLUMN_Z - COLUMN_DIAMETER / 2)
mo.assert_extent(id = "column_front", outputs = ["columns"], measure = "max_z", value = COLUMN_Z + COLUMN_DIAMETER / 2)
mo.assert_extent(id = "columns_stand", outputs = ["columns"], measure = "min_y", every = True, value = 0.0)

# The roof is carried by both columns
mo.assert_contact(id = "roof_on_columns", outputs = ["roof", "columns"], every = ["columns"], min_area = 0.02)
