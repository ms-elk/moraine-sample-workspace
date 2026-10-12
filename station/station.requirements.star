SLAB_LENGTH = 40.0
SLAB_THICKNESS = 0.10
SLAB_DEPTH = 20.0
PLATFORM_LENGTH = 24.0
PLATFORM_WIDTH = 4.0
PLATFORM_HEIGHT = 1.00
PLATFORM_FRONT_Z = 2.0
BAND_WIDTH = 0.40
BAND_THICKNESS = 0.02
STANDARD_GAUGE = 1.435
PANEL_LENGTH = 12.0
RAIL_HEAD_CLEARANCE = 0.75
BAY_WIDTH = 3.5
STANDARD_BAYS = 4
END_BAY_WIDTH = 1.0
CANOPY_HALF_SPAN = 8.0
ROOF_UNDERSIDE = 3.00
LAMP_HEIGHT = 4.00
LAMP_X = [-11.0, -9.0, 9.0, 11.0]
LAMP_INSET = 0.50
LAMP_CAST = 0.05
SLEEPER_SEAT_AREA = 0.25 * 2.60
COLUMN_SEAT_AREA = 0.02

SLAB_TOP = SLAB_THICKNESS
PLATFORM_TOP = SLAB_TOP + PLATFORM_HEIGHT

mo.group("all_roofs", ["canopy_roofs", "canopy_end_roofs"])
mo.group("all_columns", ["canopy_columns", "canopy_end_columns"])

# Ground slab
mo.assert_extent(id = "slab_length", outputs = ["slab"], measure = "size_x", value = SLAB_LENGTH)
mo.assert_extent(id = "slab_thickness", outputs = ["slab"], measure = "size_y", value = SLAB_THICKNESS)
mo.assert_extent(id = "slab_depth", outputs = ["slab"], measure = "size_z", value = SLAB_DEPTH)
mo.assert_extent(id = "slab_on_ground", outputs = ["slab"], measure = "min_y", value = 0.0)
mo.assert_extent(id = "slab_centered_x", outputs = ["slab"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "slab_centered_z", outputs = ["slab"], measure = "center_z", value = 0.0)

# Platform and safety band
mo.assert_extent(id = "platform_length", outputs = ["platform"], measure = "size_x", value = PLATFORM_LENGTH)
mo.assert_extent(id = "platform_width", outputs = ["platform"], measure = "size_z", value = PLATFORM_WIDTH)
mo.assert_extent(id = "platform_top", outputs = ["platform"], measure = "max_y", value = PLATFORM_TOP)
mo.assert_extent(id = "platform_front", outputs = ["platform"], measure = "max_z", value = PLATFORM_FRONT_Z)
mo.assert_extent(id = "platform_centered_x", outputs = ["platform"], measure = "center_x", value = 0.0)
mo.assert_contact(id = "platform_on_slab", outputs = ["platform", "slab"], min_area = PLATFORM_LENGTH * PLATFORM_WIDTH)
mo.assert_extent(id = "band_length", outputs = ["safety_band"], measure = "size_x", value = PLATFORM_LENGTH)
mo.assert_extent(id = "band_centered_x", outputs = ["safety_band"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "band_width", outputs = ["safety_band"], measure = "size_z", value = BAND_WIDTH)
mo.assert_extent(id = "band_thickness", outputs = ["safety_band"], measure = "size_y", value = BAND_THICKNESS)
mo.assert_extent(id = "band_flush_front", outputs = ["safety_band"], measure = "max_z", value = PLATFORM_FRONT_Z)
mo.assert_extent(id = "band_on_top", outputs = ["safety_band"], measure = "min_y", value = PLATFORM_TOP)
mo.assert_contact(id = "band_on_platform", outputs = ["safety_band", "platform"], min_area = PLATFORM_LENGTH * BAND_WIDTH)

# Line: two panels end to end, centered on x = 0, in front of the platform
mo.assert_count(id = "line_rail_count", outputs = ["line_rails"], value = 4)
mo.assert_count(id = "line_sleeper_count", outputs = ["line_sleepers"], value = 40)
mo.assert_extent(id = "line_length", outputs = ["line_rails"], measure = "size_x", value = 2 * PANEL_LENGTH)
mo.assert_extent(id = "line_centered_x", outputs = ["line_rails"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "line_sleepers_centered_x", outputs = ["line_sleepers"], measure = "center_x", value = 0.0)
mo.assert_contact(id = "sleepers_on_slab", outputs = ["line_sleepers", "slab"], every = ["line_sleepers"], min_area = SLEEPER_SEAT_AREA)
mo.assert_extent(
    id = "rail_head_clearance",
    faces = ["line_rails", "head"],
    measure = "min_z",
    every = True,
    min = PLATFORM_FRONT_Z + RAIL_HEAD_CLEARANCE,
)

# Canopy: three standard bays and an end bay at each end, butted
mo.assert_count(id = "standard_bay_count", outputs = ["canopy_roofs"], value = STANDARD_BAYS)
mo.assert_count(id = "end_bay_count", outputs = ["canopy_end_roofs"], value = 2)
mo.assert_extent(id = "standard_bay_width", outputs = ["canopy_roofs"], measure = "size_x", every = True, value = BAY_WIDTH)
mo.assert_extent(id = "end_bay_width", outputs = ["canopy_end_roofs"], measure = "size_x", every = True, value = END_BAY_WIDTH)
mo.assert_extent(id = "canopy_start", outputs = ["all_roofs"], measure = "min_x", value = -CANOPY_HALF_SPAN)
mo.assert_extent(id = "canopy_end", outputs = ["all_roofs"], measure = "max_x", value = CANOPY_HALF_SPAN)
mo.assert_extent(id = "canopy_underside", outputs = ["all_roofs"], measure = "min_y", value = PLATFORM_TOP + ROOF_UNDERSIDE)
mo.assert_mated(id = "seam_west", faces = [["canopy_end_roofs", "end_pos_x", 0], ["canopy_roofs", "end_neg_x", 0]])
for i in range(STANDARD_BAYS - 1):
    mo.assert_mated(id = "seam_%d" % (i + 1), faces = [["canopy_roofs", "end_pos_x", i], ["canopy_roofs", "end_neg_x", i + 1]])
mo.assert_mated(id = "seam_east", faces = [["canopy_roofs", "end_pos_x", STANDARD_BAYS - 1], ["canopy_end_roofs", "end_neg_x", 1]])
mo.assert_contact(id = "columns_on_platform", outputs = ["all_columns", "platform"], every = ["all_columns"], min_area = COLUMN_SEAT_AREA)

# Lamps, cast into the platform
mo.assert_count(id = "lamp_count", outputs = ["lamp_posts"], value = len(LAMP_X))
for i in range(len(LAMP_X)):
    mo.assert_extent(id = "lamp_%d_x" % i, faces = ["lamp_posts", "underside", i], measure = "center_x", value = LAMP_X[i])
mo.assert_extent(
    id = "lamps_inset",
    faces = ["lamp_posts", "underside"],
    measure = "center_z",
    every = True,
    value = PLATFORM_FRONT_Z - PLATFORM_WIDTH + LAMP_INSET,
)
mo.assert_extent(id = "lamp_height", outputs = ["lamp_posts"], measure = "size_y", every = True, value = LAMP_HEIGHT)
mo.assert_extent(id = "lamp_cast_depth", faces = ["lamp_posts", "underside"], measure = "max_y", every = True, value = PLATFORM_TOP - LAMP_CAST)
mo.assert_embedded(id = "lamps_cast_into_platform", outputs = ["platform", "lamp_posts"])

mo.budget(materials = 8)

# Stair at the platform's +X end
STAIR_STEPS = 5
STEP_WIDTH = 2.00
STEP_RISE = 0.200
STEP_GOING = 0.280
STRINGER_WIDTH = 0.10
STEP_SEAT_AREA = 0.025

PLATFORM_END_X = PLATFORM_LENGTH / 2
PLATFORM_CENTER_Z = PLATFORM_FRONT_Z - PLATFORM_WIDTH / 2

mo.group("stair_stringers", ["stair_stringer_back", "stair_stringer_front"])

mo.assert_count(id = "stair_step_count", outputs = ["stair_steps"], value = STAIR_STEPS)
mo.assert_extent(id = "stair_step_width", outputs = ["stair_steps"], measure = "size_z", every = True, value = STEP_WIDTH)
mo.assert_extent(id = "stair_centered_z", outputs = ["stair_steps"], measure = "center_z", value = PLATFORM_CENTER_Z)
for i in range(STAIR_STEPS):
    mo.assert_extent(id = "step_%d_rise" % i, faces = ["stair_steps", "tread", i], measure = "max_y", value = SLAB_TOP + (i + 1) * STEP_RISE)
    mo.assert_extent(
        id = "step_%d_going" % i,
        faces = ["stair_steps", "back", i],
        measure = "min_x",
        value = PLATFORM_END_X + (STAIR_STEPS - 1 - i) * STEP_GOING,
    )
mo.assert_extent(id = "top_tread_flush", faces = ["stair_steps", "tread", STAIR_STEPS - 1], measure = "max_y", value = PLATFORM_TOP)
mo.assert_mated(
    id = "top_step_on_platform_end",
    faces = [["platform", "end_pos_x"], ["stair_steps", "back", STAIR_STEPS - 1]],
    mode = "contained",
)

mo.assert_extent(id = "stringer_width", outputs = ["stair_stringers"], measure = "size_z", every = True, value = STRINGER_WIDTH)
mo.assert_extent(id = "stringer_back_under_step_end", outputs = ["stair_stringer_back"], measure = "min_z", value = PLATFORM_CENTER_Z - STEP_WIDTH / 2)
mo.assert_extent(id = "stringer_front_under_step_end", outputs = ["stair_stringer_front"], measure = "max_z", value = PLATFORM_CENTER_Z + STEP_WIDTH / 2)
mo.assert_contact(
    id = "stringers_on_slab",
    outputs = ["stair_stringers", "slab"],
    every = ["stair_stringers"],
    min_area = STAIR_STEPS * STEP_GOING * STRINGER_WIDTH,
)
for side in ["back", "front"]:
    mo.assert_contact(
        id = "steps_seated_on_stringer_" + side,
        outputs = ["stair_steps", "stair_stringer_" + side],
        every = ["stair_steps", "stair_stringer_" + side],
        min_area = STEP_SEAT_AREA,
    )

# Lanterns clear of the canopy roof
mo.assert_clearance(id = "lanterns_clear_roofs", outputs = ["lamp_lanterns", "all_roofs"], min = 0.50)
