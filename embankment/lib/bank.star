def on_lattice(v, step):
    """The half-step lattice point at or below `v`: sheet edges sit at
    odd multiples of step / 2, so no vertex lands on a whole-meter trim
    plane, and every sheet built on it shares vertices with the others."""
    return (math.floor(v / step) + 0.5) * step

def slope_sheet(id, side, z_near, z_far, x_half, step, crest_half, crest_height, toe, relief):
    """A grid on the flank's slope plane, displaced by the relief field.

    The field depends on world position and seed only, so two sheets
    whose edges come from `on_lattice` carry the identical surface.

    The plane passes `relief.shoulder` above the crest's edge, more
    than the relief's reach, so the flank trimmed at the crest's height
    covers the crest's side wherever the relief dips.
    """
    run = toe - crest_half
    rise = crest_height + relief.shoulder
    tilt = math.atan2(rise, run)
    z_mid = (z_near + z_far) / 2
    sheet = mo.grid(
        id = id + "/grid",
        size = [2 * x_half, (z_far - z_near) / math.cos(tilt)],
        segments = [int(2 * x_half / step + 0.5), int((z_far - z_near) / step + 0.5)],
    )
    sheet = mo.transform(
        sheet,
        id = id + "/slope",
        rotate_deg = [side * math.degrees(tilt), 0.0, 0.0],
        translate = [0.0, rise * (toe - z_mid) / run, side * z_mid],
    )
    return mo.noise_displace(
        sheet,
        id = id,
        amplitude = relief.amplitude,
        frequency = relief.frequency,
        octaves = relief.octaves,
        seed = relief.seed,
    )

def flank(id, side, length, crest_half, crest_height, toe, embed, step, relief):
    sheet = slope_sheet(
        id + "/surface",
        side,
        on_lattice(crest_half - embed - 0.2, step),
        on_lattice(toe + 0.4, step),
        on_lattice(length / 2 + 0.1, step),
        step,
        crest_half,
        crest_height,
        toe,
        relief,
    )
    slab = mo.extrude(sheet, id = id + "/slab", distance = crest_height + 0.4, direction = [0.0, -1.0, 0.0])
    width = toe - crest_half + embed
    trim = mo.transform(
        mo.box(id = id + "/trim_box", size = [length, crest_height, width], segments = [24, 2, 4]),
        id = id + "/trim",
        translate = [0.0, crest_height / 2, side * (toe - width / 2)],
    )
    solid = mo.boolean(slab, trim, id = id + "/solid", mode = "intersection")
    solid = mo.smooth_normals(solid, id = id + "/smooth", angle_max_deg = 40.0)
    return mo.unwrap(solid, id = id, uv_scale = 0.5)
