def tarmac(id, mesh):
    return mo.material(mesh, id = id, name = "tarmac", base_color = [0.12, 0.12, 0.13], metallic = 0.0, roughness = 0.95)

def platform_concrete(id, mesh):
    grit = mo.noise_texture(id = id + "/grit", seed = 41, size = 256, scale = 16, octaves = 5)
    grit = mo.colorize(grit, id = id + "/grit_color", color_low = [0.8, 0.8, 0.8], color_high = [1.0, 1.0, 1.0])
    return mo.material(
        mesh,
        base_color_texture = grit,
        id = id,
        name = "platform_concrete",
        base_color = [0.62, 0.60, 0.56],
        metallic = 0.0,
        roughness = 0.85,
    )

def platform_edge(id, mesh):
    return mo.material(mesh, id = id, name = "platform_edge", base_color = [0.85, 0.75, 0.15], metallic = 0.0, roughness = 0.70)

def canopy_roof(id, mesh):
    return mo.material(mesh, id = id, name = "canopy_roof", base_color = [0.20, 0.20, 0.22], metallic = 0.0, roughness = 0.60)

def cast_iron(id, mesh):
    return mo.material(mesh, id = id, name = "cast_iron", base_color = [0.06, 0.09, 0.07], metallic = 0.0, roughness = 0.55)
