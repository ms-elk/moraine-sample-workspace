def cast_iron(id, mesh):
    return mo.material(mesh, id = id, name = "cast_iron", base_color = [0.06, 0.09, 0.07], metallic = 0.0, roughness = 0.55)

def lamp_glass(id, mesh):
    return mo.material(mesh, id = id, name = "lamp_glass", base_color = [1.00, 0.85, 0.60], metallic = 0.0, roughness = 0.10, emissive = [1.0, 0.86, 0.66])
