# track - journal
Straight track panel, the repeat unit of a line: `rails` (rail_steel) and `sleepers` (sleeper_timber).

## Entries
### requirements
- Substitution for the gauge and for "head and foot centered on the web": each rail's position is ±(gauge/2 + head width/2), which a requirements threshold cannot compute from `mo.param_value`, so agent-owned extents in `track.star` check each rail copy (inner head face at ±gauge/2; head, web and foot centers on the rail's axis).
- `rails_on_sleepers` takes `min_area` = one full foot seat (0.15 × 0.25): "rests on" read as seated for every rail, and every sleeper carrying at least one seated foot is stronger than the human's "touches a rail".
### construction
- Rails stay instanced (one section, `array` of 2 across Z); per-rail checks address copies by index.
- `sleeper_timber`'s noise texture sits in the base_color slot (ridged noise, seed 7, scale 24, gain 0.6, ramped to a 1.0..0.22 multiplier with the creases darkest, grain stretched 20× along the sleeper): AGENTS.md names the factors but not the slot or map, and the texture is part of the identity, so another project shipping `sleeper_timber` needs the same map to be the same material. Promotion candidate.
- Rails carry no UVs (untextured); `uv_present` is the gltf profile's advisory warning.
### rejected
- First grain (fbm, scale 8, colorized 0.7..1.0, stretch 10×): the human read it as flat stripes and asked for weathered timber, a finer grain along the length and more contrast.
