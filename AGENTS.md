# AGENTS.md - workspace rules

Human-owned rules for this Moraine workspace. `moraine init` creates
this file once and never touches it again; it is yours to rewrite,
reorganize, or translate.

The shipped authoring guide lives at `.moraine/guide.md` (maintained
by the tool, synced to the installed Moraine version). If your agent
harness has not already loaded it, read it before authoring - its
instructions apply as if written here.

Precedence: rules in this file override the guide where they
conflict. Journals (`journal.md` in each project, optionally at the
workspace root) bias proposals; they never override either file.

## Workspace rules

This workspace is a small railway station kit for real-time use.
Every request I make in a session is a requirement unless it says
"about" or "your call".

- Nothing floats: every part rests on another part or on the ground,
  declared as a contact.
- Material identities. A name below is one material, the same in
  every project (linear RGB base color, metallic, roughness); do not
  invent a second name for the same look. In each project, define a
  material once, in one place, and give every part its material from
  there; no part restates the numbers.
  - `cast_iron`        (0.06, 0.09, 0.07)  metallic 0.0  roughness 0.55  (painted dark green)
  - `lamp_glass`       (1.00, 0.85, 0.60)  metallic 0.0  roughness 0.10  emissive warm white; alpha your call
  - `rail_steel`       (0.55, 0.55, 0.57)  metallic 1.0  roughness 0.40
  - `sleeper_timber`   (0.16, 0.10, 0.06)  metallic 0.0  roughness 0.90  with a noise-type texture
  - `ballast`          (0.38, 0.40, 0.45)  metallic 0.0  roughness 0.95
  - `platform_concrete`(0.62, 0.60, 0.56)  metallic 0.0  roughness 0.85  with a noise-type texture
  - `platform_edge`    (0.85, 0.75, 0.15)  metallic 0.0  roughness 0.70  (safety yellow)
  - `canopy_roof`      (0.45, 0.16, 0.10)  metallic 0.0  roughness 0.60  (oxide red)
  - `earth`            (0.30, 0.26, 0.18)  metallic 0.0  roughness 1.00  with a noise-type texture
  - `tarmac`           (0.12, 0.12, 0.13)  metallic 0.0  roughness 0.95
- Declare a knob only where a request names one.
- Do not commit or push on your own. After I accept a round I tell
  you to commit and give you the message; push only when I say so.
