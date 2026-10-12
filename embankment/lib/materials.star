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

def ballast(id, mesh):
    return mo.material(mesh, id = id, name = "ballast", base_color = [0.38, 0.40, 0.45], metallic = 0.0, roughness = 0.95)
