# lamp_post - journal
Cast-iron platform lamp post: `post` (cast_iron) and `lantern` (lamp_glass).

## Entries
### dimensions
- The knob `shaft_length` is the shaft alone (base top to collar underside); overall = shaft + 0.82 of fixed parts. Default and range derive from `OVERALL_HEIGHT` and the "about 3.5 to 6.0" band, snapped to cm (2.68..5.18).
- Substitution for "overall height 4.50 by default": no assert can pin a default without rejecting the knob's other values, so `shaft_length` (shaft `size_y` = `mo.param_value`) plus the fixed-part extents carry it, and `overall_height` checks the 3.5..6.0 band.
- Shaft taper to 0.09 at the top was the agent's call (offered as optional), taken.
- `SEAT_AREA_MIN` 0.1: the glass top under the cap shares 0.09, the collar top under the glass about 0.02; 0.1 fails if either seat is lost.
### construction
- Base, shaft and collar are one `revolve` profile; the cap is a separate body unioned into `post`, seated by `place` on `glass_top`. Post tags are re-applied after the union.
- `lamp_glass` is opaque (alpha 1): the lantern holds no lamp body, so a transparent box would read empty.
- `glass_emissive` defaults to the emissive `lamp_glass` already had, so the knob left lamp_post's GLB byte-identical. Its range 0..100 was the agent's, set to admit station's strength 100; the knob passes through `lamp_glass` in `lib/`, so the viewer shows it as a staged field, not a live slider.
- [moraine 0.2.1] The viewer saturates the glass to flat white from strength about 10: shots at 10 and 100 are identical, so pixels check the range only up to there. The GLB carries the strength in `KHR_materials_emissive_strength` with the color unchanged; the engine decides how it renders.
- No UVs on either output: both materials are untextured, `uv_present` is the gltf profile's advisory warning.
