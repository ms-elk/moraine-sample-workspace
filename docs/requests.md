# The requests, round by round

This document records the requests the human sent to the agent at each round. You don't need to start with requests this detailed. You can describe what you want in plain language and refine the requirements with your agent. The requests here were deliberately detailed to make the constraints explicit for this demonstration.

They were drafted in advance with the agent used to develop Moraine, in a separate session outside this workspace. The human decided each requirement. The agent sessions that built the assets received the finished requests, not the drafting conversation; they also used Moraine's shipped documentation and the standing workspace rules in [`AGENTS.md`](../AGENTS.md).

The requests appear in commit order. When the agent asked a question, the human's answer follows the request. Each linked commit shows the resulting changes, while the project's `journal.md` records the agent's reasoning. `AGENTS.md` is maintained at the human's direction: when its rules changed, the human instructed the agent to edit it.

## [`a64d7b3`](https://github.com/ms-elk/moraine-sample-workspace/commit/a64d7b3) — Lamp post

> Project `lamp_post`: a cast-iron platform lamp post. Two root outputs,
> `post` (everything in `cast_iron`) and `lantern` (the glass, in
> `lamp_glass`). The post stands on the ground: heights are measured from
> the base's underside, diameters are outer, and the parts are centered
> on the post's axis.
>
> - Base: a turned base 0.36 in diameter at its underside, 0.35 tall,
>   narrowing to the shaft; its underside is flat and tagged, so a
>   consumer can rest it on, or cast it into, a floor.
> - Shaft: 0.12 in diameter where it leaves the base; a taper to 0.09 at
>   the top is your call.
> - Lantern: a glass box 0.30 wide, 0.36 tall, 0.30 deep, seated on a
>   collar 0.16 in diameter and 0.06 tall at the shaft top, under a cap
>   0.40 square and 0.05 thick; the collar and the cap are part of
>   `post`.
> - Overall height, underside to cap top: 4.50 by default. A declared
>   knob sets the shaft length so that the overall height ranges from
>   about 3.5 to 6.0.
> - The lantern rests on the collar and the cap rests on the lantern;
>   nothing passes through the glass.
> - Budget: 2 material identities at most in the export.
>
> Export when green. When you consider it done, tell me and stop.

## [`3bfadb0`](https://github.com/ms-elk/moraine-sample-workspace/commit/3bfadb0) — Track panel

> Project `track`: a straight track panel, the repeat unit of a line.
> Two root outputs, `rails` (in `rail_steel`) and `sleepers` (in
> `sleeper_timber`). The panel runs along X, centered on the origin in X
> and Z, and rests on the ground: the sleepers' undersides are at y = 0.
>
> - Rails: two rails, 12.00 long along X. Each rail is 0.172 tall: a
>   head 0.070 wide and 0.040 tall with a single flat top face (the
>   running surface), a web 0.016 wide, a foot 0.150 wide and 0.012
>   tall, head and foot centered on the web; building the section from
>   boxes is fine. The gauge, the gap between the inner faces of the two
>   heads, is 1.435 by default and is a declared knob over 1.000 to
>   1.676 (meter gauge to broad gauge); the standard, meter and broad
>   values must all validate.
> - Sleepers: 20 timber sleepers, each 2.60 along Z, 0.16 tall, 0.25
>   along X, instanced at a 0.600 pitch along X, the first centered
>   0.300 from the panel's −X end; every sleeper rests on the ground.
> - The rails rest on the sleepers: every sleeper touches a rail. The
>   rails' overall width across Z stays within 2.00 at every gauge in
>   the range, so each foot keeps 0.30 in from the sleeper ends.
> - Budget: 2 material identities at most in the export.
>
> Export when green. When you consider it done, tell me and stop.

## [`7b5c10c`](https://github.com/ms-elk/moraine-sample-workspace/commit/7b5c10c) — Sleeper grain, from a pin

The human pinned a sleeper in the viewer and sent:

> This one (pinned): the grain reads as flat stripes. Make it read as
> weathered timber: finer grain along the length, more contrast, keep the
> AGENTS.md factors. Re-verify and re-export, then tell me what changed
> and stop.

## [`eb36a66`](https://github.com/ms-elk/moraine-sample-workspace/commit/eb36a66) — Embankment

> Project `embankment`: a short stretch of line on an earth embankment,
> with ballast. It consumes the `track` project; do not copy its recipe.
> The bank runs along X, centered on the origin in X and Z, and rests on
> the ground: its underside is at y = 0.
>
> - Bank: an earth bank 24.0 long (X) in `earth`. Its crest is flat, 4.40
>   wide (Z), its top face 1.20 above the ground; each flank slopes from
>   the crest's edge down to the ground at z = ±6.0, with relief of about
>   0.10 on its surface. The bank is closed solids; the crest and the
>   flanks may be separate outputs, and where they meet, embed rather
>   than butt.
> - Ballast bed: a 23.96 × 0.35 × 3.60 (X × Y × Z) bed in `ballast`,
>   centered on the crest in X and Z, so it ends 0.02 inside each end of
>   the bank and no two end faces share a plane. It is cast into the
>   crest: its underside between 0.10 and 0.30 below the crest's top
>   face, declared as an embed.
> - Loose ballast: from one stone prototype 0.05 to 0.12 across, fixed
>   seed, random yaw: at least 300 stones scattered on the bed's top,
>   and at least 60 on each flank. Every stone touches the surface it
>   was scattered on and sinks no more than 0.03 into it; elsewhere the
>   stones may touch or overlap freely: one another, the crest's edge,
>   the sleepers they bed.
> - Track: one `track` panel, referenced from the `track` project, at
>   meter gauge (1.000), centered on the bed in X and Z, every sleeper
>   resting on the bed's top.
> - Budget: 4 material identities at most in the export.
>
> Export when green. When you consider it done, tell me and stop.

## [`2422408`](https://github.com/ms-elk/moraine-sample-workspace/commit/2422408) — Ballast bed, from a pin

The human pinned the ballast bed in the viewer and sent:

> This one (pinned): the ballast bed reads as a smooth light slab, not as
> crushed stone, at any distance I would look from. Make it read as
> ballast, about a few meters away. The identity stays `ballast` with its
> stated factors, one identity for the bed and the stones. A texture is
> fine if that is what it takes; amend the `ballast` row in AGENTS.md to
> allow it. Re-verify and re-export, then tell me what changed and stop.

## [`9e406d3`](https://github.com/ms-elk/moraine-sample-workspace/commit/9e406d3) — Station

> Project `station`: a platform with a canopy, lamps, and the running
> line in front of it. It consumes the `lamp_post` and `track` projects;
> the canopy bay is a sub-asset of this project. The asset front faces
> +Z: the line lies on the platform's +Z side, running along X.
>
> - Ground: a 40.0 (X) × 20.0 (Z) slab 0.10 thick in `tarmac`, resting
>   on the ground (its underside at y = 0), centered on the origin in X
>   and Z. Its top face is the floor: everything else stands on it.
> - Platform: 24.0 long (X), 4.0 wide (Z), its top face 1.00 above the
>   slab's top, in `platform_concrete`, centered on x = 0, its +Z face at
>   z = +2.0. A safety band in `platform_edge`, 0.40 wide and 0.02 thick,
>   runs the full length on top of the platform, its +Z edge flush with
>   the platform's +Z face.
> - Line: two `track` panels at standard gauge, end to end, together
>   centered on x = 0, in front of the platform, sleepers resting on the
>   slab's top; the near rail head keeps at least 0.75 clearance from
>   the platform's +Z face.
> - Canopy: a sub-asset `canopy_bay`: a flat roof 0.10 thick in
>   `canopy_roof`, 3.40 deep (Z), its underside 3.00 above the platform's
>   top, carried by two columns 0.18 in diameter in `cast_iron` on the
>   bay's centerline (x = 0) at z = ±1.20, standing on the platform; the
>   roof is centered on the columns in X and Z. The bay's width along X
>   is a declared knob over 1.0 to 4.0, default 4.0. The canopy is three
>   standard bays at the default width and one 2.0 bay at each end, all
>   from the one sub-asset, centered on x = 0: the roofs together span
>   16.0 along X, from x = −8.0 to +8.0, with no gap between neighbors.
>   Every column stands on the platform.
> - Lamps: four posts from `lamp_post`, overall height 4.00, at x = −9.0,
>   −3.0, +3.0 and +9.0, 0.50 in from the platform's −Z edge; each base
>   is cast into the platform so that its underside is 0.05 below the
>   platform's top (an embed).
> - Budget: 8 material identities at most in the export.
>
> Export when green. When you consider it done, tell me and stop.

After building the station, the agent asked whether to keep its chosen canopy position: forward of the lamps at z = +0.30, with clearance margins checked by the agent. The human replied:

> Your call.

## [`0495634`](https://github.com/ms-elk/moraine-sample-workspace/commit/0495634) — Stair

In a new agent session started in `station/`, the human pinned the platform in the viewer and sent:

> A stair at the +X end of this platform (I pinned the platform). Five
> steps, each 2.00 wide (Z), rise 0.200, going 0.280, in
> `platform_concrete`, as copies of one step, climbing from the slab's
> top to the platform's top, the top step's tread flush with it; the
> stair centered on the platform in Z; the top step's back face mated to
> the platform's +X end face. Two stringers in `platform_concrete` carry
> the steps, one under each end of the steps (Z), each 0.10 wide: the
> stringers rest on the slab, and every step is seated on both
> stringers, sharing at least 0.025 m² of face with each. Leave the
> joint declared. Everything else unchanged. When you consider it done,
> tell me what you changed and stop.

## [`e8f567a`](https://github.com/ms-elk/moraine-sample-workspace/commit/e8f567a) — Three changes and a new requirement

The previous agent session was resumed.

> Thanks. Three changes, then re-verify everything and re-export:
>
> 1. The canopy roof color becomes dark gray (0.20, 0.20, 0.22), same
>    metallic and roughness; the identity keeps its name. Update the
>    `canopy_roof` row in AGENTS.md to match.
> 2. The canopy has four standard bays instead of three, with a 1.0 bay
>    at each end, still spanning the same 16.0 from the one sub-asset.
> 3. The embankment line goes to standard gauge (1.435).
>
> New requirement of mine: every lantern keeps at least 0.50 clearance
> from the canopy roof.
>
> Every earlier requirement still applies. Projects these changes do
> not touch must re-export byte-identical. When you consider it done,
> tell me what you changed (which files, roughly how many lines) and
> what you re-ran, then stop.

Before building, the agent clarified two points. With four standard bays and a 1.0 m bay at each end spanning 16.0 m, each standard bay must be 3.5 m wide. The human confirmed:

> Yes, 3.5.

The new lantern-to-roof clearance requirement would also fail: the two lamps under the roof's back edge would have only 0.44 m, below the required 0.50 m. Since the roof's depth and height and the lamps' positions were all the human's numbers, the agent asked which to revise. The human replied:

> Keep four posts. Move the two under the roof out to x = ±11.0; keep the
> embed and the 0.50 from the edge. Update my lamp position requirements
> accordingly.

## [`2b24421`](https://github.com/ms-elk/moraine-sample-workspace/commit/2b24421) — Scene

A new agent session started at the workspace root.

> Project `scene`: the station with a second line on an embankment
> behind it. Compose by placement only, consuming the `station` and
> `embankment` projects unchanged: the station as it is, at its own
> position; the embankment behind the platform (on the −Z side), moved
> along Z only, so its crest still runs along X, centered on x = 0; it
> rests on the ground (y = 0, the plane the station's slab rests on, not
> the slab's top), and its nearest point keeps at least 0.50 clearance
> from the slab. Nothing else is added. Budget: 10 material identities
> at most in the export. Export when green. When you consider it done,
> tell me and stop.

## [`1fb82ae`](https://github.com/ms-elk/moraine-sample-workspace/commit/1fb82ae) — The lantern's glow

The previous agent session was resumed.

> Round across two projects. In `lamp_post`, declare a knob on the
> lantern's emissive color so a consumer can set how strongly the glass
> glows; the default stays as it is, so lamp_post's own export stays
> byte-identical. In `station`, override it to strength 100 (the same
> warm white, 100 times brighter) and give that use its own material
> identity, `lamp_glass_night`; add its row to AGENTS.md. `scene`
> follows through its references. Tell me what changed and stop.

## [`0697db3`](https://github.com/ms-elk/moraine-sample-workspace/commit/0697db3) — A value accepted in the viewer

Before sending this request, the human adjusted the `lamp_post` height in the viewer and pressed **Accept**. The accepted value was saved to `lamp_post/params.json`.

> The lamp post ships on its own as well as inside the station, and its
> default (4.50 overall) reads short for a standalone post. I opened
> `lamp_post` in the viewer, set its height knob to a taller post, and
> accepted it. Re-verify the workspace and re-export whatever that
> changes. Tell me the accepted value as the tool reports it, which
> exports changed, and which stayed byte-identical. Then stop.
