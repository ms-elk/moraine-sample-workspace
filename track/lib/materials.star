def rail_steel(id, mesh):
    return mo.material(mesh, id = id, name = "rail_steel", base_color = [0.55, 0.55, 0.57], metallic = 1.0, roughness = 0.40)

def sleeper_timber(id, mesh):
    grain = mo.noise_texture(id = id + "/grain", seed = 7, size = 512, scale = 24, octaves = 5, gain = 0.6, mode = "ridged")
    grain = mo.ramp(
        grain,
        id = id + "/grain_color",
        stops = [0.0, 0.45, 0.75, 1.0],
        values = [[1.0, 1.0, 1.0], [0.8, 0.8, 0.8], [0.5, 0.5, 0.5], [0.22, 0.22, 0.22]],
    )
    return mo.material(
        mesh,
        base_color_texture = grain,
        id = id,
        name = "sleeper_timber",
        base_color = [0.16, 0.10, 0.06],
        metallic = 0.0,
        roughness = 0.90,
    )
