def rail_steel(id, mesh):
    return mo.material(mesh, id = id, name = "rail_steel", base_color = [0.55, 0.55, 0.57], metallic = 1.0, roughness = 0.40)

def sleeper_timber(id, mesh):
    grain = mo.noise_texture(id = id + "/grain", seed = 7, size = 256, scale = 8, octaves = 5)
    grain = mo.colorize(grain, id = id + "/grain_color", color_low = [0.7, 0.7, 0.7], color_high = [1.0, 1.0, 1.0])
    return mo.material(
        mesh,
        base_color_texture = grain,
        id = id,
        name = "sleeper_timber",
        base_color = [0.16, 0.10, 0.06],
        metallic = 0.0,
        roughness = 0.90,
    )
