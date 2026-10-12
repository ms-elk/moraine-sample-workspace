def earth(id, mesh):
    soil = mo.noise_texture(id = id + "/soil", seed = 11, size = 256, scale = 6, octaves = 5)
    soil = mo.colorize(soil, id = id + "/soil_color", color_low = [0.7, 0.7, 0.7], color_high = [1.0, 1.0, 1.0])
    return mo.material(
        mesh,
        base_color_texture = soil,
        id = id,
        name = "earth",
        base_color = [0.30, 0.26, 0.18],
        metallic = 0.0,
        roughness = 1.00,
    )

BALLAST_UV_SCALE = 0.5

def ballast(id, mesh):
    stones = mo.noise_texture(id = id + "/stones", seed = 31, size = 512, scale = 32, octaves = 3, mode = "billow")
    shade = mo.ramp(
        stones,
        id = id + "/stones_color",
        stops = [0.0, 0.35, 0.6, 1.0],
        values = [[0.3, 0.3, 0.3], [0.55, 0.55, 0.55], [0.85, 0.85, 0.85], [1.0, 1.0, 1.0]],
    )
    relief = mo.normal_map(stones, id = id + "/stones_relief", strength = 0.03)
    return mo.material(
        mesh,
        base_color_texture = shade,
        normal_texture = relief,
        id = id,
        name = "ballast",
        base_color = [0.38, 0.40, 0.45],
        metallic = 0.0,
        roughness = 0.95,
    )
