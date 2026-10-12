load("lib/materials.star", "cast_iron", "lamp_glass")
load(
    "lamp_post.requirements.star",
    "BASE_DIAMETER",
    "BASE_HEIGHT",
    "CAP_SIZE",
    "CAP_THICKNESS",
    "COLLAR_DIAMETER",
    "COLLAR_HEIGHT",
    "GLASS_DEPTH",
    "GLASS_HEIGHT",
    "GLASS_WIDTH",
    "OVERALL_HEIGHT",
    "OVERALL_HEIGHT_MAX",
    "OVERALL_HEIGHT_MIN",
    "SHAFT_DIAMETER",
)

SHAFT_TOP_DIAMETER = 0.09
SEGMENTS = 32

FIXED_HEIGHT = BASE_HEIGHT + COLLAR_HEIGHT + GLASS_HEIGHT + CAP_THICKNESS

def to_cm(x):
    return math.floor(x * 100 + 0.5) / 100

shaft_length = mo.param(
    "shaft_length",
    to_cm(OVERALL_HEIGHT - FIXED_HEIGHT),
    min = to_cm(OVERALL_HEIGHT_MIN - FIXED_HEIGHT),
    max = to_cm(OVERALL_HEIGHT_MAX - FIXED_HEIGHT),
    step = 0.01,
    label = "Shaft length",
)
glass_emissive = mo.param(
    "glass_emissive",
    [1.0, 0.86, 0.66],
    min = 0.0,
    max = 100.0,
    step = 0.01,
    label = "Glass glow",
)

base_r = BASE_DIAMETER / 2
shaft_r = SHAFT_DIAMETER / 2
shaft_top_r = SHAFT_TOP_DIAMETER / 2
collar_r = COLLAR_DIAMETER / 2
shaft_top_y = BASE_HEIGHT + shaft_length
collar_top_y = shaft_top_y + COLLAR_HEIGHT

column = mo.revolve(
    id = "column",
    segments = SEGMENTS,
    profile = [
        [base_r, 0.0],
        [base_r, 0.05],
        [0.165, 0.065],
        [0.15, 0.075],
        [0.14, 0.10],
        [0.12, 0.13],
        [0.10, 0.17],
        [0.085, 0.22],
        [0.075, 0.28],
        [0.08, 0.31],
        [0.08, 0.33],
        [shaft_r, BASE_HEIGHT],
        [shaft_top_r, shaft_top_y],
        [collar_r, shaft_top_y],
        [collar_r, collar_top_y],
    ],
)
column = mo.tag(
    column,
    id = "column_collar_top",
    name = "collar_top",
    select = {"normal_y": {"gt": 0.9}, "center_y": {"gt": shaft_top_y}},
)

glass = mo.box(id = "glass_box", size = [GLASS_WIDTH, GLASS_HEIGHT, GLASS_DEPTH])
glass = mo.tag(glass, id = "glass_bottom", name = "glass_bottom", select = {"normal_y": {"lt": -0.9}})
glass = mo.tag(glass, id = "glass_top", name = "glass_top", select = {"normal_y": {"gt": 0.9}})
glass = mo.place(base = column, part = glass, id = "glass_seat", anchor = "collar_top", mode = "on_top")

cap = mo.box(id = "cap_box", size = [CAP_SIZE, CAP_THICKNESS, CAP_SIZE])
cap = mo.place(base = glass, part = cap, id = "cap_seat", anchor = "glass_top", mode = "on_top")

post = mo.boolean(column, cap, id = "post_union", mode = "union")
post = mo.smooth_normals(post, id = "post_smooth")
post = mo.tag(post, id = "post_underside", name = "underside", select = {"normal_y": {"lt": -0.9}, "center_y": {"lt": BASE_HEIGHT / 2}})
post = mo.tag(post, id = "post_base", name = "base", select = {"center_y": {"lt": BASE_HEIGHT}})
post = mo.tag(
    post,
    id = "post_shaft",
    name = "shaft",
    select = {"normal_y": {"gt": -0.5, "lt": 0.5}, "center_y": {"gt": BASE_HEIGHT, "lt": shaft_top_y}},
)
post = mo.tag(
    post,
    id = "post_collar",
    name = "collar",
    select = {"center_y": {"ge": shaft_top_y - 0.001, "le": collar_top_y + 0.001}},
)
post = mo.tag(
    post,
    id = "post_collar_top",
    name = "collar_top",
    select = {"normal_y": {"gt": 0.9}, "center_y": {"ge": collar_top_y - 0.001, "le": collar_top_y + 0.001}},
)
post = mo.tag(post, id = "post_cap", name = "cap", select = {"center_y": {"gt": collar_top_y + 0.01}})
post = mo.tag(
    post,
    id = "post_cap_underside",
    name = "cap_underside",
    select = {"normal_y": {"lt": -0.9}, "center_y": {"gt": collar_top_y + 0.01}},
)
post = cast_iron("post_mat", post)

lantern = lamp_glass("lantern_mat", glass, glass_emissive)

mo.output("post", post)
mo.output("lantern", lantern)
