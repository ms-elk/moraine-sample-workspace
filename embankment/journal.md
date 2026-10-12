# embankment - journal
A stretch of line on an earth bank: crest and two flanks (earth), ballast bed and loose stones (ballast), one `track` panel at meter gauge.

## Entries
### requirements
- Substitution for "sinks no more than 0.03 into it": on the flat bed top each stone's sink is its own `min_y` (`bed_stones_sink`, per copy); on the relief flanks no per-copy measure exists, so `embedded` max 0.03 on the stones-flank pair (mean thickness over the union of stones) carries the bound. All three scatters share one prototype, and the union depth reads alike on the bed and the flanks.
- The bed's underside sits at the middle of the human's 0.10..0.30 band, computed from the requirements constants.
- `SLEEPER_SEAT_AREA` is the track's sleeper footprint (0.25 × 2.60) restated as a number: a change to the track's sleeper size breaks `sleepers_on_bed` until it follows.
### construction
- The flank's slope plane passes 0.11 above the crest's edge (just over the relief amplitude) and meets the ground at z = ±6.0; the flank is trimmed at the crest's height, so the bank reads flat a little past the crest's edge before it slopes.
- Stones share the `ballast` identity with the bed (the budget of 4 holds earth, ballast, rail_steel, sleeper_timber); on the bed they read only through their facets.
### rejected
- A slope plane through the crest's edge exposed the crest box's vertical side wherever the relief dipped below the crest: a dark step line along both shoulders in the shots.
