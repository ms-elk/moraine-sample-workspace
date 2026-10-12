load("lib/materials.star", "rail_steel", "sleeper_timber")
load(
    "track.requirements.star",
    "FIRST_SLEEPER_OFFSET",
    "FOOT_HEIGHT",
    "FOOT_WIDTH",
    "GAUGE",
    "GAUGE_MAX",
    "GAUGE_MIN",
    "HEAD_HEIGHT",
    "HEAD_WIDTH",
    "RAIL_HEIGHT",
    "RAIL_LENGTH",
    "SLEEPER_COUNT",
    "SLEEPER_HEIGHT",
    "SLEEPER_LENGTH",
    "SLEEPER_PITCH",
    "SLEEPER_WIDTH",
    "WEB_WIDTH",
)

EMBED = 0.002
GRAIN_STRETCH = 20.0

gauge = mo.param("gauge", GAUGE, min = GAUGE_MIN, max = GAUGE_MAX, step = 0.001, label = "Gauge")

first_sleeper_x = -RAIL_LENGTH / 2 + FIRST_SLEEPER_OFFSET

# Sleepers: grain runs along the length, so the box is unwrapped at a
# fraction of its length and stretched back.
sleeper = mo.box(id = "sleeper_box", size = [SLEEPER_WIDTH, SLEEPER_HEIGHT, SLEEPER_LENGTH / GRAIN_STRETCH])
sleeper = mo.unwrap(sleeper, id = "sleeper_uv", uv_scale = 4.0)
sleeper = mo.transform(sleeper, id = "sleeper_stretch", scale = [1.0, 1.0, GRAIN_STRETCH])
sleeper = sleeper_timber("sleeper_mat", sleeper)
sleeper = mo.transform(sleeper, id = "sleeper_first", translate = [first_sleeper_x, SLEEPER_HEIGHT / 2, 0.0])
sleeper = mo.tag(sleeper, id = "sleeper_top", name = "top", select = {"normal_y": {"gt": 0.9}})
sleepers = mo.array(sleeper, id = "sleepers", count = SLEEPER_COUNT, step_translate = [SLEEPER_PITCH, 0.0, 0.0])

# Rail section from three boxes, foot underside at y = 0; the web
# embeds into head and foot so the union has no coplanar contact.
head_bottom = RAIL_HEIGHT - HEAD_HEIGHT
foot = mo.transform(
    mo.box(id = "foot_box", size = [RAIL_LENGTH, FOOT_HEIGHT, FOOT_WIDTH]),
    id = "foot",
    translate = [0.0, FOOT_HEIGHT / 2, 0.0],
)
web = mo.transform(
    mo.box(id = "web_box", size = [RAIL_LENGTH, head_bottom - FOOT_HEIGHT + 2 * EMBED, WEB_WIDTH]),
    id = "web",
    translate = [0.0, (FOOT_HEIGHT + head_bottom) / 2, 0.0],
)
head = mo.transform(
    mo.box(id = "head_box", size = [RAIL_LENGTH, HEAD_HEIGHT, HEAD_WIDTH]),
    id = "head",
    translate = [0.0, RAIL_HEIGHT - HEAD_HEIGHT / 2, 0.0],
)
rail = mo.boolean(foot, web, head, id = "rail_section", mode = "union")

not_end = {"gt": -0.5, "lt": 0.5}
rail = mo.tag(rail, id = "rail_running_surface", name = "running_surface", select = {"normal_y": {"gt": 0.9}, "center_y": {"gt": FOOT_HEIGHT + 0.001}})
rail = mo.tag(rail, id = "rail_head", name = "head", select = {"normal_x": not_end, "center_y": {"ge": head_bottom - 0.001}})
rail = mo.tag(rail, id = "rail_head_pos_z", name = "head_pos_z", select = {"normal_z": {"gt": 0.9}, "center_y": {"ge": head_bottom - 0.001}})
rail = mo.tag(rail, id = "rail_head_neg_z", name = "head_neg_z", select = {"normal_z": {"lt": -0.9}, "center_y": {"ge": head_bottom - 0.001}})
rail = mo.tag(
    rail,
    id = "rail_web",
    name = "web",
    select = {
        "normal_x": not_end,
        "center_y": {"gt": FOOT_HEIGHT + 0.001, "lt": head_bottom - 0.001},
        "center_z": {"gt": -WEB_WIDTH / 2 - 0.001, "lt": WEB_WIDTH / 2 + 0.001},
    },
)
rail = mo.tag(rail, id = "rail_foot", name = "foot", select = {"normal_x": not_end, "center_y": {"le": FOOT_HEIGHT + 0.001}})
rail = rail_steel("rail_mat", rail)

rail_z = gauge / 2 + HEAD_WIDTH / 2
rail = mo.place(
    base = sleepers,
    part = rail,
    id = "rail_seat",
    anchor = "top",
    instance = 0,
    mode = "on_top",
    offset = [-first_sleeper_x, 0.0, -rail_z],
)
rails = mo.array(rail, id = "rails", count = 2, step_translate = [0.0, 0.0, 2 * rail_z])

mo.output("rails", rails)
mo.output("sleepers", sleepers)

# Substitutes for the gauge and for "head and foot centered on the web":
# both are positions that follow the knob, which a requirements threshold
# cannot compute, so they are checked here per rail.
for i in range(2):
    z = (2 * i - 1) * rail_z
    for part in ["head", "web", "foot"]:
        mo.assert_extent(id = "rail_%d_%s_on_axis" % (i, part), faces = ["rails", part, i], measure = "center_z", value = z)
mo.assert_extent(id = "gauge_left_inner_face", faces = ["rails", "head_pos_z", 0], measure = "max_z", value = -gauge / 2)
mo.assert_extent(id = "gauge_right_inner_face", faces = ["rails", "head_neg_z", 1], measure = "min_z", value = gauge / 2)
