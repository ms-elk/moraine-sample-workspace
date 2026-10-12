# station - journal
Platform with a canopy, lamps, and the running line in front: consumes `lamp_post` and `track`; the canopy bay is `subassets/canopy_bay.star`.

## Entries
### layout
- The canopy's z position was the agent's to choose: the lamps (4.00 tall from 0.05 below the platform's top) rise above the roof's underside (3.00 above it) at z = -1.5, so the roof must stand forward of them. `CANOPY_Z` 0.30 puts the roof's back edge 0.05 clear of the lamps' shafts and its front edge at the platform's face, and the front columns 0.01 off the safety band; both margins are agent asserts.
- `LINE_Z` 3.60 gives the near rail head 0.81 from the platform's face against the required 0.75.
- `LAMP_FIXED_HEIGHT` 0.82 restates lamp_post's base, collar, glass and cap to turn the 4.00 height into its `shaft_length` knob; `lamp_height` catches a change upstream.
- `STEP_THICKNESS` 0.10 was the agent's: a full-rise (0.200) step would put the bottom step on the slab with no room for a stringer under it, so the steps are thinner than the rise, leaving open risers and a 0.10 stringer column under step 0.
- "One under each end of the steps" is read as flush with each end (`stringer_back_under_step_end`, `stringer_front_under_step_end`), which gives each step a 0.28 × 0.10 = 0.028 seat on each stringer against the required 0.025.
- `SLEEPER_SEAT_AREA` restates the track's sleeper footprint, and `COLUMN_SEAT_AREA` 0.02 sits just under the 16-segment column's foot (0.0248).
### construction
- One `cast_iron` identity serves the canopy columns (station `lib/materials.star`) and the referenced lamp posts: same name and factors, so the budget of 8 holds exactly.
- The roofs butt end to end; each seam is a `mated` pair on the sub-asset's `end_neg_x` / `end_pos_x` tags.
