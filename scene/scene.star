STATION_OUTPUTS = [
    "slab",
    "platform",
    "safety_band",
    "stair_steps",
    "stair_stringer_back",
    "stair_stringer_front",
    "line_rails",
    "line_sleepers",
    "canopy_roofs",
    "canopy_columns",
    "canopy_end_roofs",
    "canopy_end_columns",
    "lamp_posts",
    "lamp_lanterns",
]
EMBANKMENT_OUTPUTS = [
    "crest",
    "flank_front",
    "flank_back",
    "ballast_bed",
    "bed_stones",
    "flank_front_stones",
    "flank_back_stones",
    "rails",
    "sleepers",
]
EMBANKMENT_Z = -17.0

# Transforms stay authored, since no op places a referenced kit.
for output in STATION_OUTPUTS:
    mo.output(output, mo.asset_ref(project = "station", output = output, id = "station_" + output))

for output in EMBANKMENT_OUTPUTS:
    part = mo.asset_ref(project = "embankment", output = output, id = "embankment_" + output)
    part = mo.transform(part, id = "embankment_" + output + "_place", translate = [0.0, 0.0, EMBANKMENT_Z])
    mo.output("embankment_" + output, part)
