load("lib/materials.star", "canopy_roof", "cast_iron")
load(
    "subassets/canopy_bay.requirements.star",
    "BAY_WIDTH",
    "BAY_WIDTH_MAX",
    "BAY_WIDTH_MIN",
    "COLUMN_DIAMETER",
    "COLUMN_Z",
    "ROOF_DEPTH",
    "ROOF_THICKNESS",
    "ROOF_UNDERSIDE",
)

bay_width = mo.param("bay_width", BAY_WIDTH, min = BAY_WIDTH_MIN, max = BAY_WIDTH_MAX, step = 0.1, label = "Bay width")

column = mo.cylinder(id = "column_cylinder", radius = COLUMN_DIAMETER / 2, height = ROOF_UNDERSIDE, segments = 16)
column = mo.transform(column, id = "column_back", translate = [0.0, ROOF_UNDERSIDE / 2, -COLUMN_Z])
column = mo.tag(column, id = "column_top", name = "top", select = {"normal_y": {"gt": 0.9}})
column = mo.tag(column, id = "column_foot", name = "foot", select = {"normal_y": {"lt": -0.9}})
column = cast_iron("column_mat", column)
columns = mo.array(column, id = "columns", count = 2, step_translate = [0.0, 0.0, 2 * COLUMN_Z])

roof = mo.box(id = "roof_box", size = [bay_width, ROOF_THICKNESS, ROOF_DEPTH])
roof = mo.tag(roof, id = "roof_end_neg_x", name = "end_neg_x", select = {"normal_x": {"lt": -0.9}})
roof = mo.tag(roof, id = "roof_end_pos_x", name = "end_pos_x", select = {"normal_x": {"gt": 0.9}})
roof = mo.tag(roof, id = "roof_underside", name = "underside", select = {"normal_y": {"lt": -0.9}})
roof = canopy_roof("roof_mat", roof)
roof = mo.place(
    base = columns,
    part = roof,
    id = "roof",
    anchor = "top",
    instance = 0,
    mode = "on_top",
    offset = [0.0, 0.0, COLUMN_Z],
)

mo.output("roof", roof)
mo.output("columns", columns)
