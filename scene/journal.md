# scene - journal
The station with the embankment's line behind it, composed by placement only: every output is a `station` or `embankment` root output, referenced unchanged.

## Entries
### layout
- `EMBANKMENT_Z` -17.0 was the agent's: the front toe (local z = +6.0) lands at z = -11.0, 1.00 behind the slab's back edge against the required 0.50.
- "The station as it is, at its own position" holds by construction (its outputs are referenced with no transform); no scene assert restates the station's position.
- Substitutions: "behind the platform" is `embankment_behind_platform` (embankment `max_z` <= -2.0, the platform's back face restated as a number); "its crest still runs along X" is `crest_along_x` (crest `size_x` = 24.0, the embankment's `BANK_LENGTH` restated). Either goes stale if its source project changes that dimension.
### construction
- Embankment outputs carry an `embankment_` prefix in the scene, so its `rails` / `sleepers` read apart from the station's `line_rails` / `line_sleepers` in the engine hierarchy.
- The 10 identities are the station's 8 plus `earth` and `ballast`; `rail_steel` and `sleeper_timber` arrive from both projects through `track` at one gauge override, so they stay one identity each.
