RAIL_LENGTH = 12.00
RAIL_HEIGHT = 0.172
HEAD_WIDTH = 0.070
HEAD_HEIGHT = 0.040
WEB_WIDTH = 0.016
FOOT_WIDTH = 0.150
FOOT_HEIGHT = 0.012
GAUGE = 1.435
GAUGE_MIN = 1.000
GAUGE_MAX = 1.676
RAILS_MAX_WIDTH = 2.00
SLEEPER_COUNT = 20
SLEEPER_LENGTH = 2.60
SLEEPER_HEIGHT = 0.16
SLEEPER_WIDTH = 0.25
SLEEPER_PITCH = 0.600
FIRST_SLEEPER_OFFSET = 0.300

# Rails
mo.assert_count(id = "rail_count", outputs = ["rails"], value = 2)
mo.assert_extent(id = "rail_length", outputs = ["rails"], measure = "size_x", value = RAIL_LENGTH)
mo.assert_extent(id = "rails_centered_x", outputs = ["rails"], measure = "center_x", value = 0.0)
mo.assert_extent(id = "rails_centered_z", outputs = ["rails"], measure = "center_z", value = 0.0)
mo.assert_extent(id = "rail_height", outputs = ["rails"], measure = "size_y", every = True, value = RAIL_HEIGHT)
mo.assert_extent(id = "running_surface_flat", faces = ["rails", "running_surface"], measure = "size_y", every = True, value = 0.0)
mo.assert_extent(id = "running_surface_width", faces = ["rails", "running_surface"], measure = "size_z", every = True, value = HEAD_WIDTH)
mo.assert_extent(id = "head_width", faces = ["rails", "head"], measure = "size_z", every = True, value = HEAD_WIDTH)
mo.assert_extent(id = "head_height", faces = ["rails", "head"], measure = "size_y", every = True, value = HEAD_HEIGHT)
mo.assert_extent(id = "web_width", faces = ["rails", "web"], measure = "size_z", every = True, value = WEB_WIDTH)
mo.assert_extent(id = "foot_width", faces = ["rails", "foot"], measure = "size_z", every = True, value = FOOT_WIDTH)
mo.assert_extent(id = "foot_height", faces = ["rails", "foot"], measure = "size_y", every = True, value = FOOT_HEIGHT)
mo.assert_extent(id = "rails_width", outputs = ["rails"], measure = "size_z", max = RAILS_MAX_WIDTH)

# Sleepers
mo.assert_count(id = "sleeper_count", outputs = ["sleepers"], value = SLEEPER_COUNT)
mo.assert_extent(id = "sleeper_length", outputs = ["sleepers"], measure = "size_z", every = True, value = SLEEPER_LENGTH)
mo.assert_extent(id = "sleeper_height", outputs = ["sleepers"], measure = "size_y", every = True, value = SLEEPER_HEIGHT)
mo.assert_extent(id = "sleeper_width", outputs = ["sleepers"], measure = "size_x", every = True, value = SLEEPER_WIDTH)
mo.assert_extent(id = "sleepers_on_ground", outputs = ["sleepers"], measure = "min_y", every = True, value = 0.0)
mo.assert_extent(id = "sleepers_centered_z", outputs = ["sleepers"], measure = "center_z", value = 0.0)
mo.assert_extent(
    id = "first_sleeper",
    outputs = ["sleepers"],
    measure = "min_x",
    value = -RAIL_LENGTH / 2 + FIRST_SLEEPER_OFFSET - SLEEPER_WIDTH / 2,
)
mo.assert_extent(
    id = "last_sleeper",
    outputs = ["sleepers"],
    measure = "max_x",
    value = -RAIL_LENGTH / 2 + FIRST_SLEEPER_OFFSET + (SLEEPER_COUNT - 1) * SLEEPER_PITCH + SLEEPER_WIDTH / 2,
)
mo.assert_clearance(id = "sleeper_spacing", outputs = ["sleepers"], self = True, min = SLEEPER_PITCH - SLEEPER_WIDTH)

# The rails rest on the sleepers; every sleeper touches a rail
mo.assert_contact(
    id = "rails_on_sleepers",
    outputs = ["rails", "sleepers"],
    every = ["rails", "sleepers"],
    min_area = FOOT_WIDTH * SLEEPER_WIDTH,
)

mo.budget(materials = 2)
