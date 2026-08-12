---
name: electronics-kicad-python-scripting
description: 'Author KiCad .kicad_pcb layout programmatically with the bundled pcbnew Python module: board outline, mounting holes, footprint placement, headless DRC, headless ratsnest fly-line renderer, placement-optimization strategy, action plugins, kikit panelization, kiutils for offline file editing. USE FOR: pcbnew Python, scripted PCB layout, kicad-cli pcb, kiutils, kikit, automate KiCad, programmatic PCB, place footprints from code, draw Edge.Cuts from code, headless DRC, headless ratsnest, fly-line renderer, MST per net, placement strategy, where to put a flyback diode, in-line resistor placement, optimize placement before routing, tracks cannot cross, pin swap to avoid crossing, ratsnest crossing detector, ratsnest lies, ratsnest is not routability, read live tracks before arguing routing, dog-leg above pad row, dog-leg under connector body, empty F.Cu band between pad row and connector edge, board.Tracks for inspection, dump tracks by net, when user contradicts routing analysis, sync SKiDL to hand-routed board, source-of-truth alignment after hand-edit, 2-layer hobby board routing, when to add a via, symmetric connector pin assignment, swap pins instead of routing around, stale track after net swap, pad net changed but track did not, pin swap leaves dangling tracks, pad track on different nets, rip stale tracks after netlist apply, generic stale-track sweeper, _rip_changed_net_tracks, re-route after pin swap, one-shot route fixup, SwigPyObject is not iterable, board.Tracks SWIG iterator goes stale after Remove, pad coordinates not stable across builds, read pad XY at runtime, THT through-hole pads cross-under on B.Cu without a via, free layer change inside THT pad, validate-then-mutate routing helper discipline, Python action plugin, where is pcbnew on Windows, KiCad bundled python, FromMM/ToMM, FootprintLoad, .kicad_sch s-expression, hand-authoring schematic, sexpdata, component values not visible in 3D render, value field on F.Fab vs F.Silkscreen, silkscreen labels for screw terminals, label every component, move value to silkscreen, fp.Value().SetLayer, silkscreen clearance warning, value text overlaps connector polygon, resize silkscreen value, reposition value outside footprint bbox, kicad-cli pcb drc --severity-all, missing 3D model in render, footprint STEP not installed, KICAD10_3DMODEL_DIR vs KIPRJMOD, generate parametric STEP with build123d, project-local 3D models, retarget footprint model, fp.Models() pop_back push_back, FP_3DMODEL, trace hidden under connector body, 3D render hides copper, 2D copper view, F.Cu plot, never re-route from 3D alone, body shadow illusion, dog-leg under plastic, kicad-cli pcb export svg F.Cu.'
---

# KiCad Python Scripting — `pcbnew`, `kiutils`, `kikit`

> **Prerequisite:** Load `electronics-kicad-general` first. This skill
> assumes the project layout (`<project>/python/`, `${KIPRJMOD}` paths),
> file conventions (`.kicad_pro`, `.kicad_sch`, `.kicad_pcb`), and the
> six-phase workflow described there.

## Purpose

Get as much KiCad PCB authoring as possible into re-runnable Python
scripts so re-fab iterations take seconds, not GUI minutes. Covers:

- The **`pcbnew`** Python module (official, ships with KiCad — board /
  PCB authoring)
- The **`kiutils`** pure-Python library (community — read/write both
  `.kicad_sch` and `.kicad_pcb` without KiCad installed)
- **`kikit`** (community — high-level panelization, V-cuts, mouse bites,
  fab presets)
- **`kicad-cli`** for headless ERC/DRC and export (covered in detail by
  `electronics-kicad-pcb-fab-gerber`; this skill references it for the
  CI loop)
- Where these live on Windows, how to invoke them, and the pitfalls
  that bite first-time scripters

**Out of scope** (covered by sibling skills):

- Project file layout, design phases, ERC/DRC concepts →
  `electronics-kicad-general`
- Sourcing symbols/footprints/3D models → `electronics-kicad-symbols-footprints`
- Generating the fab package (Gerber/drill/BOM/STEP/render) →
  `electronics-kicad-pcb-fab-gerber`

---

## 1. The Big Caveat: Schematic vs PCB

**There is no official Python binding for the `.kicad_sch` schematic
file.** Only `.kicad_pcb` has `pcbnew`.

Practical consequence: scripting the **PCB** is well-supported and
robust. Scripting the **schematic** is doable (parse the s-expression
with `kiutils` or `sexpdata`) but brittle — UUIDs, library references,
field positions, and KiCad version-format drift all conspire against
you.

**Recommended workflow:**

| Task | Tool | Why |
|------|------|-----|
| Schematic capture | eeschema (GUI) | Better ergonomics; ~15 min one-time for a small board |
| PCB outline + mounting holes | `pcbnew` Python | Idempotent; safe to rerun |
| Component placement | `pcbnew` Python | Re-runnable; easy to nudge positions |
| Routing | pcbnew (GUI) or `kikit` | Manual is faster than scripted for small boards |
| ERC + DRC | `kicad-cli` | Headless; CI-friendly |
| Gerber + drill + BOM + STEP | `kicad-cli` | Headless; CI-friendly |
| Schematic post-edits (rename refs, bulk field updates) | `kiutils` | Pure-Python, no KiCad needed |

Don't try to hand-author `.kicad_sch` from scratch. The next sections
focus on `.kicad_pcb` scripting, which is the actually-pleasant part.

---

## 2. Where the `pcbnew` Python Module Lives

`pcbnew` is bundled with KiCad. It is **not** on PyPI. `pip install
pcbnew` will install a totally unrelated package (or fail). Do not do
this.

### Windows

```text
C:\Program Files\KiCad\10.0\bin\python.exe        ← KiCad 10.x bundled python
C:\Program Files\KiCad\10.0\lib\python3\dist-packages\pcbnew.py
C:\Program Files\KiCad\10.0\bin\_pcbnew.pyd       ← native C++ binding

C:\Program Files\KiCad\10.0\bin\python.exe        ← KiCad 10.x bundled python
C:\Program Files\KiCad\9.0\bin\python.exe         ← KiCad 9.x bundled python (legacy)
C:\Program Files\KiCad\9.0\lib\python3\dist-packages\pcbnew.py
```

Run a script with the bundled Python:

```pwsh
& 'C:\Program Files\KiCad\10.0\bin\python.exe' python\01_board_outline_and_holes.py
```

The `& '...path...'` PowerShell syntax is mandatory when the path has
spaces.

### macOS

```text
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/lib/python<3.X>/site-packages/pcbnew.py
```

### Linux

```text
/usr/lib/python3/dist-packages/pcbnew.py     # typically packaged
/usr/bin/python3                              # system python; finds pcbnew
```

On Linux the system python typically finds `pcbnew` because the
distribution package installs it into the system site-packages.

### Why you can't `pip install pcbnew`

`pcbnew` is a SWIG-wrapped C++ binding against the live KiCad shared
libraries. It can only be loaded by a Python whose ABI matches the one
KiCad was compiled against, with the matching KiCad shared libs on the
load path. The bundled `python.exe` has all of that wired up; your venv
or system Python does not.

### Verify it works

```pwsh
& 'C:\Program Files\KiCad\10.0\bin\python.exe' -c "import pcbnew; print(pcbnew.GetBuildVersion())"
# → 10.0.3-...
```

---

## 3. Loading and Saving a Board

```python
import pcbnew

board = pcbnew.LoadBoard("controller.kicad_pcb")
# ... mutate ...
pcbnew.SaveBoard("controller.kicad_pcb", board)
```

`LoadBoard()` accepts an absolute or relative path. Relative paths
resolve from the **current working directory**, not the script's
location — always normalise:

```python
import os
HERE = os.path.dirname(os.path.abspath(__file__))
BOARD = os.path.normpath(os.path.join(HERE, "..", "controller.kicad_pcb"))
board = pcbnew.LoadBoard(BOARD)
```

`SaveBoard()` overwrites in place. There is no built-in backup — `git`
is your backup.

### Internal units: nanometres

`pcbnew` stores all coordinates as **integer nanometres**. Always
convert at the boundary:

```python
pcbnew.FromMM(5.08)   # → 5_080_000 (int)
pcbnew.ToMM(5_080_000) # → 5.08 (float)
```

Common bug: passing mm-as-float directly to a function that expects
nanometres-as-int. The result is a coordinate near 0 → component lands
in the corner. Always wrap in `pcbnew.FromMM()`.

For 2D points use `pcbnew.VECTOR2I(x_nm, y_nm)`:

```python
pos = pcbnew.VECTOR2I(pcbnew.FromMM(42.5), pcbnew.FromMM(27.55))
footprint.SetPosition(pos)
```

---

## 4. Drawing the Board Outline (Edge.Cuts)

A board outline is a closed loop of graphic segments on the `Edge.Cuts`
layer. The fab cuts the PCB along whatever you draw there.

```python
def draw_rectangle_outline(board, w_mm, h_mm, line_width_mm=0.05):
    edge_layer = board.GetLayerID("Edge.Cuts")
    corners = [(0, 0), (w_mm, 0), (w_mm, h_mm), (0, h_mm)]
    for i in range(4):
        x0, y0 = corners[i]
        x1, y1 = corners[(i + 1) % 4]
        seg = pcbnew.PCB_SHAPE(board)
        seg.SetShape(pcbnew.SHAPE_T_SEGMENT)
        seg.SetStart(pcbnew.VECTOR2I(pcbnew.FromMM(x0), pcbnew.FromMM(y0)))
        seg.SetEnd(pcbnew.VECTOR2I(pcbnew.FromMM(x1), pcbnew.FromMM(y1)))
        seg.SetLayer(edge_layer)
        seg.SetWidth(pcbnew.FromMM(line_width_mm))
        board.Add(seg)
```

### Idempotency: clear before drawing

Re-running the script otherwise stacks duplicate edges on top of each
other (KiCad doesn't deduplicate). Always clear first:

```python
def clear_existing_edge_cuts(board):
    edge_layer = board.GetLayerID("Edge.Cuts")
    # Snapshot the list — Remove() invalidates the iterator
    for drawing in list(board.GetDrawings()):
        if drawing.GetLayer() == edge_layer:
            board.Remove(drawing)
```

### Other shapes

| Shape | API |
|-------|-----|
| Line / segment | `SHAPE_T_SEGMENT` with `SetStart` / `SetEnd` |
| Arc | `SHAPE_T_ARC` with `SetStart` / `SetEnd` / `SetCenter` |
| Circle | `SHAPE_T_CIRCLE` with `SetStart` (center) / `SetEnd` (point on radius) |
| Rectangle | `SHAPE_T_RECT` with `SetStart` / `SetEnd` (opposite corners) |
| Polygon | `SHAPE_T_POLY` with `SetPolyShape(SHAPE_POLY_SET)` |

Rounded corners on the outline = four `SHAPE_T_SEGMENT` lines + four
`SHAPE_T_ARC` arcs. Many fabs prefer round corners (less stress
concentration); some hobby builds skip them to match a host enclosure
exactly (this project does, per
`decisions/0001-board-outline-and-holes.md`).

---

## 5. Placing Mounting Holes and Footprints

Footprints are loaded from a `.pretty` library folder on disk. KiCad's
official library ships with `MountingHole.pretty`, `Resistor_THT.pretty`,
`Connector_PinHeader_2.54mm.pretty`, etc.

### Locating the official footprint library

```python
import os

def find_official_footprint_root():
    for env in ("KICAD10_FOOTPRINT_DIR", "KICAD9_FOOTPRINT_DIR",
                "KICAD8_FOOTPRINT_DIR", "KICAD_FOOTPRINT_DIR"):
        path = os.environ.get(env)
        if path and os.path.isdir(path):
            return path
    for major in ("10.0", "9.0", "8.0"):
        guess = f"C:/Program Files/KiCad/{major}/share/kicad/footprints"
        if os.path.isdir(guess):
            return guess
    raise RuntimeError("KiCad footprint library not found")
```

KiCad sets `KICAD<N>_FOOTPRINT_DIR` in its own shell environment, so the
env var is the right first check.

### Loading a footprint

```python
fp_lib_root = find_official_footprint_root()
lib_path = os.path.join(fp_lib_root, "MountingHole.pretty")

fp = pcbnew.FootprintLoad(lib_path, "MountingHole_2.2mm_M2")
fp.SetReference("H1")
fp.SetValue("MountingHole_2.2mm_M2")
fp.SetPosition(pcbnew.VECTOR2I(pcbnew.FromMM(3.0), pcbnew.FromMM(6.0)))
board.Add(fp)
```

### Idempotency: update-or-insert by reference

```python
def find_by_ref(board, ref):
    for fp in board.GetFootprints():
        if fp.GetReference() == ref:
            return fp
    return None

existing = find_by_ref(board, "H1")
if existing:
    existing.SetPosition(pcbnew.VECTOR2I(pcbnew.FromMM(3.0), pcbnew.FromMM(6.0)))
else:
    fp = pcbnew.FootprintLoad(lib_path, "MountingHole_2.2mm_M2")
    fp.SetReference("H1")
    fp.SetPosition(...)
    board.Add(fp)
```

### Moving and rotating placed footprints

After `Update PCB from Schematic` pulls the netlist into pcbnew, every
footprint is on the board. Move them by reference:

```python
by_ref = {fp.GetReference(): fp for fp in board.GetFootprints()}

by_ref["R1"].SetPosition(pcbnew.VECTOR2I(pcbnew.FromMM(50.5), pcbnew.FromMM(15.55)))
by_ref["R1"].SetOrientationDegrees(90.0)  # +90° = CW from default (see rotation table below)
```

`SetOrientationDegrees()` is the preferred API. The lower-level
`SetOrientation(EDA_ANGLE)` exists but takes tenths of a degree as an
int — easy to get wrong.

#### Rotation convention — KiCad pcbnew is CW-positive

KiCad pcbnew rotations are **clockwise-positive** when viewed from
above (top side of board) with +X right, +Y up. This is the OPPOSITE
of the mathematical convention. The most reliable way to predict pin
locations is to start from the footprint's native (rotation=0) pad
coordinates and apply this table for orthogonal rotations:

| rot   | (x, y) becomes | a "wire-entry on +Y face" footprint exits |
|------:|----------------|-------------------------------------------|
|  0°   | ( x,  y)       | UP    (+Y)  — toward top edge of board    |
|  90°  | ( y, -x)       | RIGHT (+X)  — toward right edge           |
| 180°  | (-x, -y)       | DOWN  (-Y)  — toward bottom edge          |
| 270°  | (-y,  x)       | LEFT  (-X)  — toward left edge            |

Gotcha that *will* bite you: terminal-block footprints like Phoenix
MKDS have an asymmetric body (e.g. native bbox X=[-2.66, +7.74],
Y=[-5.32, +4.72]). After a 90° rotation that's not just a swap —
pin 2 ends up *below* pin 1 in PCB Y, not above. Always compute the
rotated pin and body-extent positions explicitly when checking
clearance to mounting holes; don't eyeball it.

```python
import math

def rotate_cw(x_mm: float, y_mm: float, deg: float) -> tuple[float, float]:
    """Apply KiCad's CW-positive rotation to a native (x, y) offset."""
    rad = math.radians(-deg)  # negate: KiCad CW = math CCW negative
    c, s = math.cos(rad), math.sin(rad)
    return (x_mm * c - y_mm * s, x_mm * s + y_mm * c)

# E.g. MKDS pin 2 native at (+5.08, 0). With center (78, 17, rot=90°):
# rotated offset = (0, -5.08), absolute pin pos = (78+0, 17-5.08) = (78, 11.92)
```

### Flipping to the back

```python
by_ref["U1"].Flip(by_ref["U1"].GetPosition(), False)
# arg2: whether to mirror text — False keeps reference designators readable
```

---

## 6. Iterating, Inspecting, Reporting

Standard collections:

```python
for fp in board.GetFootprints():           # all footprints
    ref = fp.GetReference()
    val = fp.GetValue()
    pos = fp.GetPosition()
    x_mm = pcbnew.ToMM(pos.x)
    y_mm = pcbnew.ToMM(pos.y)
    rot = fp.GetOrientationDegrees()
    print(f"{ref:>4}  {val:<24}  ({x_mm:6.2f}, {y_mm:6.2f}) mm  rot={rot:+6.1f}°")

for track in board.GetTracks():            # all tracks + vias
    if isinstance(track, pcbnew.PCB_VIA):
        ...

for zone in board.Zones():                 # all copper zones
    ...

for drawing in board.GetDrawings():        # graphic shapes (Edge.Cuts, silk, etc.)
    ...

for net in board.GetNetsByName().values(): # all nets
    ...
```

Bounding box of the board outline:

```python
bb = board.GetBoardEdgesBoundingBox()
w_mm = pcbnew.ToMM(bb.GetWidth())
h_mm = pcbnew.ToMM(bb.GetHeight())
```

### Pad and drill inventory

When verifying that hand-solder pads are big enough, that NPTH mounting
holes have the right diameter, or that two pads are *actually* the same
size after a footprint edit, a 30-line dumper is faster than clicking
through the PCB editor's properties dialog one footprint at a time.

`_inspect_holes.py` — throwaway, idempotent, run from KiCad's bundled
python (because it imports `pcbnew`):

```python
"""Dump every pad's drill + pad diameter from a .kicad_pcb."""
import pcbnew

b = pcbnew.LoadBoard("controller.kicad_pcb")
type_map  = {0: "PTH", 1: "SMD", 2: "NPTH", 3: "CONN"}
shape_map = {0: "circle", 1: "rect", 2: "oval", 3: "trap",
             4: "rrect",  5: "chamf", 6: "custom"}

print(f"{'Ref':<6} {'Pad':<4} {'Type':<6} {'Drill (mm)':<14} "
      f"{'Pad size (mm)':<16} {'Shape':<8} Net")
print("-" * 90)

rows = []
for fp in b.Footprints():
    ref = fp.GetReference()
    for p in fp.Pads():
        ptype = type_map.get(p.GetAttribute(), str(p.GetAttribute()))
        drill = p.GetDrillSize()
        dx, dy = pcbnew.ToMM(drill.x), pcbnew.ToMM(drill.y)
        if dx == 0 and dy == 0:
            drill_str = "-"                              # SMD / no drill
        elif abs(dx - dy) < 1e-6:
            drill_str = f"{dx:.2f}"                      # round
        else:
            drill_str = f"{dx:.2f}x{dy:.2f}"             # slot
        sz = p.GetSize()
        size_str = f"{pcbnew.ToMM(sz.x):.2f}x{pcbnew.ToMM(sz.y):.2f}"
        shape = shape_map.get(p.GetShape(), "?")
        rows.append((ref, p.GetNumber(), ptype, drill_str,
                     size_str, shape, p.GetNetname()))

for row in sorted(rows):
    print("{:<6} {:<4} {:<6} {:<14} {:<16} {:<8} {}".format(*row))
```

When to reach for it:

- **Spec confirmation before fab.** Verify every PTH drill is ≥ the
  fab's minimum (0.3 mm on PCBWay/JLCPCB standard tier).
- **Hand-solder sanity.** Confirm hand-solder connector pads grew to
  the intended 2.6 mm / 1.3 mm drill after a footprint swap; a footprint
  library substitution can silently shrink them back.
- **Slot vs round.** Slotted oval pads show as `1.20x2.00` in the drill
  column — fabs charge extra for slots, and you want to know if a slot
  snuck in.
- **NPTH count.** Mounting holes appear as `NPTH ... -` (no net); a
  missing mounting hole jumps out.

Lessons that earned this recipe:

- KiCad's GUI Pad Properties dialog gives you one pad at a time. A
  diff-able text dump catches "all four BAT pads are 1.0 mm drill, but
  J1–J3 ended up at 0.9 mm" in one glance.
- After a SKiDL pin-swap or a footprint substitution, this script is
  the fastest way to prove the pads still match the schematic intent.
- Keep it as a `python/_inspect_*.py` throwaway in the project, not a
  reusable library. Each project's spec is different; the value is in
  the seconds it takes to read+tweak the script.

---

## 6.5. Verify Placement BEFORE Routing — Headless Ratsnest Renderer

**The single highest-leverage placement check is to render the
ratsnest fly-lines headlessly and look at the per-net total length.**
A `kicad-cli pcb render` PNG is gorgeous but hides the topology — you
can't tell from it whether a 3-pad net is wired as a clean column or
zigzags across the whole board. Pcbnew's GUI shows fly-lines, but
opening pcbnew and eyeballing it isn't reviewable, isn't diff-able,
and isn't checkable by an AI assistant operating headlessly.

### Why it matters

A real lesson from this repo: a hobby controller PCB shipped to v1
placement with **NODE_B = 80.5 mm** of fly-line (a flyback diode
placed 56 mm from the solenoid output it was supposed to clamp), and
**NODE_A = 50.6 mm** (current-limiting resistors stacked far from
both their LEDs and their switches). After ratsnest-driven re-placement
(see §6.6 heuristic), the totals dropped to NODE_B = 42.5 mm and
NODE_A = 26.6 mm — **a 48% reduction in total fly-line length, with
zero crossings**, in one iteration. The script paid for itself.

Without the ratsnest renderer, the agent (and the user) would have
spent the entire hand-routing session fighting an unroutable layout.

### Pattern: data extraction + image rendering, two scripts

`pcbnew` lives in KiCad's bundled python. `matplotlib` lives in a
venv. Bridge them with a JSON sidecar:

```text
04_render_ratsnest.py   # KiCad-python: walks footprints/pads,
                        #   computes per-net MST, writes SVG +
                        #   _ratsnest_data.json sidecar
05_render_ratsnest_png.py  # venv-python: reads JSON, renders PNG
                           #   via matplotlib (view_image-friendly)
```

### Algorithm

For each net (skipping GND and unconnected):

1. Collect every pad's (x, y) — `for fp in board.GetFootprints(): for pad in fp.Pads()`.
2. Skip pads where `pad.GetNet().GetNetname()` is `""` or `"GND"`
   (GND uses a copper pour, drawing 5+ fly-lines clutters the diagram).
3. Compute a **minimum spanning tree** over Euclidean distance — Prim's
   in ~15 lines, no scipy dependency.
4. Sum MST edge lengths → that's the net's "fly-line total".

```python
def mst_edges(points):
    """Prim's MST, returns [(i, j), ...] edges."""
    n = len(points)
    if n < 2:
        return []
    in_tree = [False] * n
    in_tree[0] = True
    edges = []
    for _ in range(n - 1):
        best = None
        for i in range(n):
            if not in_tree[i]:
                continue
            for j in range(n):
                if in_tree[j]:
                    continue
                dx = points[i][0] - points[j][0]
                dy = points[i][1] - points[j][1]
                d = (dx * dx + dy * dy) ** 0.5
                if best is None or d < best[0]:
                    best = (d, i, j)
        if best is None:
            break
        _, i, j = best
        in_tree[j] = True
        edges.append((i, j))
    return edges
```

### Terminal output — the actionable signal

Sort worst-first and flag anything over a heuristic threshold:

```text
Fly-line totals (sorted worst-first — investigate the top of the list):
  ⚠ NODE_B            80.5 mm  (4 pads)   ← flyback diode 56mm from load
  ⚠ NODE_A            50.6 mm  (3 pads)
    LED_A_GREEN       22.8 mm  (2 pads)
    V_FUSED           17.4 mm  (2 pads)
    V+                12.0 mm  (2 pads)
    TOTAL            206.1 mm
```

The `⚠` marker for nets >40 mm catches obviously-suboptimal placements
at a glance.

### SVG output (sidecar-free; for browser / VS Code preview)

White background; board outline as a thin rect; footprint bboxes as
light-gray rects with a centered, bold ref-designator label; MST edges
as dashed colored lines (one color per net); pads as filled circles.
Bottom-left legend lists every net's length swatched by color. Pure
stdlib — no SVG library, just f-strings.

### PNG output (matplotlib; for vision-tool inspection)

Required because `view_image` (and many agent vision tools) can't
consume SVG. The KiCad-python script dumps a JSON sidecar that the
venv-python `05_*` script reads and renders with matplotlib. Keep
the SVG generation in `04_*` too — it costs nothing and is browser-
viewable without matplotlib.

### Wire it into your build pipeline

After `02_place_components.py` saves, run `04_render_ratsnest.py`
then `05_render_ratsnest_png.py`. Both should run on every build —
they're idempotent and fast (<1s each).

```pwsh
& $kpy "python\04_render_ratsnest.py"      # writes SVG + JSON
& $vpy "python\05_render_ratsnest_png.py"  # writes PNG
```

Read the per-net table before hand-routing; if any net is over ~30 mm
on a ~90×50 mm board (or anything similarly disproportionate), STOP
and move components instead of routing through the mess.

---

## 6.6. Placement Strategy — Optimize for Ratsnest Length

The ratsnest report tells you **where** the placement is bad. The
following heuristics tell you **how** to fix it.

### The cardinal rule

**Co-locate every pad on the same net.** If a net has 3+ pads spread
across the board, the routing layer is going to look like spaghetti
and the agent (or you) will burn the whole hand-routing session on
acrobatics. Fix it in placement; routing should only choose layer
and corner geometry, not topology.

### Specific heuristics with worked examples

| Rule | Bad placement | Good placement |
|------|---------------|----------------|
| **Flyback diodes go AT the load** — a flyback diode that's 50 mm of trace away from the relay/solenoid it's clamping loses most of its protection (trace inductance + loop area let the spike kick before the diode conducts) | D3 (1N4007) at far-left corner, J3 (solenoid output) at far-right edge: 56 mm of NODE_B trace between them | D3 in the same pocket as J3, cathode pad ~10 mm from J3.1 — NODE_B drops from 80→42 mm in one move |
| **Current-limiting resistors go in-line between their switch and their LED** — a series resistor whose pads are equidistant from both endpoints minimizes both NODE_X (switch→R) and LED_X (R→LED) | R1 below the LED row, switches above the LED row → 30 mm fly-lines on both ends | R1 between J1 (ARM switch) and D1 (LED), vertical column → 11 mm + 2.5 mm fly-lines |
| **Branching nets fan out from one center** — when a net has a switch that branches to two parallel loads, position the switch so the branches go in opposite directions | J1 (ARM switch) → NODE_A → R1 AND J2 (FIRE switch input). If R1 is at the OPPOSITE side of the board from J2, NODE_A zigzags. | Keep J1 and J2 in the same row (mirror each other), put R1 between them and slightly offset toward J1 |
| **Aesthetics ≠ optimization** — perfect mirror symmetry of two parallel branches often LOSES to "each component at its locally-optimal position" | Putting R1 7.5 mm right of D1 just because R2 is 7.5 mm right of D2 | R1 just barely clear of D1's courtyard (~5 mm); R2 with whatever offset clears J2's body extension |

### Workflow

1. Place components for first-pass functionality (signal flow left-to-right or top-to-bottom, mounting holes respected).
2. Run the ratsnest renderer.
3. **Look at the worst net.** Read its pad list (`python\_dump_nets.py`
   or `json.load(open('fab/_ratsnest_data.json'))` and print
   `nets[name]["pads"]`).
4. **Move one pad-set** (one component or one group) such that the MST
   shrinks. Re-run the renderer.
5. **Stop when no net exceeds ~30 mm on a ~90×50 mm board.** The
   threshold scales linearly with board size; the principle is "no
   single net should span more than ~⅓ of the diagonal".
6. After every move, run DRC to catch courtyard collisions you may
   have introduced. The ratsnest is only useful inside the
   "all-courtyards-clear" feasible region.

### Iteration is cheap, opinionated routing is expensive

Each placement iteration takes <1 s of compute (re-place + re-render).
Each hand-routing iteration in pcbnew takes 5–10 minutes. Spend
placement iterations liberally; you'll recoup them many times over
when routing becomes trivial.

---

## 6.7. Respect User Edits — Check the Board Before Re-running Scripts

The headless flow (`SKiDL → netlist → 02_apply_netlist.py → 03_place_components.py`)
is opinionated: every run rewrites footprint positions, rotations, and
net assignments. The moment the user opens pcbnew and drags anything,
**you have two competing sources of truth** — the script's PLACEMENT
dict and the on-board geometry. Blindly re-running the pipeline
silently throws away their work.

### The bug pattern

1. You and the user iterate on circuit topology via scripts. Layout
   PNG looks fine, ship it.
2. User opens pcbnew to hand-route, decides the placement could be
   nicer, drags F1 to a new spot, rotates J1, sets a different drill
   origin and translates everything.
3. User comes back to chat with "small tweak: swap pin assignments on
   BAT".
4. You "helpfully" run `pwsh build_fab.ps1` (which calls
   `03_place_components.py`).
5. Every footprint snaps back to the script's coordinates. The user's
   30 minutes of pcbnew work vanishes. No warning, no diff. They
   notice when they reopen the board.

### The check (do this BEFORE any rebuild touches the .kicad_pcb)

```pwsh
# 1. Show timestamps — is the .kicad_pcb newer than the scripts?
Get-Item controller.kicad_pcb, python/03_place_components.py |
  Select-Object Name, LastWriteTime

# 2. Show what's uncommitted
git status --short
git diff --stat controller.kicad_pcb

# 3. Read the current on-board positions
& 'C:\Program Files\KiCad\10.0\bin\python.exe' -c @"
import pcbnew
b = pcbnew.LoadBoard('controller.kicad_pcb')
for fp in sorted(b.Footprints(), key=lambda f: f.GetReference()):
    print(f'{fp.GetReference():>4}  ({pcbnew.ToMM(fp.GetX()):6.2f}, '
          f'{pcbnew.ToMM(fp.GetY()):6.2f})  rot={fp.GetOrientationDegrees():+6.1f}')
"@

# 4. Check whether any tracks/vias/zones exist (those are pure user work)
(Select-String -Path controller.kicad_pcb `
  -Pattern "^\s*\(segment|^\s*\(via|^\s*\(zone").Count
```

If positions/rotations differ materially from your PLACEMENT dict, or
if any tracks exist, **tell the user what you found and pick the
right tool**:

| Change the user wants | Right tool | Wrong tool |
|-----------------------|-----------|-----------|
| Add/remove a component, change which net connects where | `00_circuit.py` + regen netlist + `02_apply_netlist.py`. **Skip 03.** | Running 03 — moves everything back |
| Swap pin assignments (BAT V+/GND, etc.) | `00_circuit.py` + regen + `02_apply_netlist.py`. **Skip 03.** | Rotating in 03 — disrupts user layout |
| Physically swap two pads' positions (rotate a footprint) | Tiny one-shot script that targets just that footprint by ref | Re-running 03 |
| Wholesale re-layout | Run 03 — but **first** offer to capture user's current positions back into the PLACEMENT dict so this round is the new baseline |

### The build-script flag every project should have

`build_fab.ps1` (or equivalent) needs a `-SkipPlace` switch:

```powershell
param(
    [switch]$SkipSchematic,   # skip 00 + 02 too
    [switch]$SkipPlace        # run 00 + 02 but leave positions alone
)
# ...
if (-not $SkipPlace) {
    & $kpy "python\03_place_components.py"
} else {
    Write-Host "[place] SKIPPED — preserving on-board positions" -ForegroundColor Yellow
}
```

`02_apply_netlist.py` is safe to re-run with user edits in place — it
only reassigns nets to pads; it does NOT touch position, rotation, or
routing. That's the property that makes `-SkipPlace` work cleanly.

### Capturing user positions back into the script (optional follow-up)

When the user signals that their hand-layout IS the new baseline, dump
the current positions into a Python literal they can paste over the
PLACEMENT dict:

```python
import pcbnew
b = pcbnew.LoadBoard('controller.kicad_pcb')
print("PLACEMENT = {")
for fp in sorted(b.Footprints(), key=lambda f: f.GetReference()):
    ref = fp.GetReference()
    if ref.startswith("H"):  # mounting holes — handled by 01
        continue
    x, y = pcbnew.ToMM(fp.GetX()), pcbnew.ToMM(fp.GetY())
    rot = fp.GetOrientationDegrees()
    print(f'    "{ref}": ({x:.2f}, {y:.2f}, {rot:+.1f}),')
print("}")
```

This is the "promote user edits to source of truth" workflow. Don't do
it silently — confirm with the user that they want the script
re-baselined first.

### Lesson summary

- **Headless layout scripts and pcbnew GUI edits don't merge** —
  whichever runs last wins.
- **Always check `git status` and on-board positions before
  re-running** anything that writes to `.kicad_pcb`.
- **Provide a `-SkipPlace` flag** so the user can iterate on netlist
  changes without nuking their hand-placement.
- **`02_apply_netlist.py` is position-safe by design**; rely on that.
- **Promote user layout to PLACEMENT dict only on explicit request.**

---

## 6.8. Board Outline and Mounting Holes Are Layout Too

A subtle variant of §6.7 that costs an hour the first time it bites:
when the user drags their on-board cluster (footprints + Edge.Cuts +
mounting holes) to a new spot on the page, both halves of the board
are now somewhere other than `(0, 0)`. If `-SkipPlace` only gates
`03_place_components.py`, the next build will run
`01_board_outline_and_holes.py`, which silently rewrites Edge.Cuts back
to `(0, 0)..(W, H)` and moves H1–H6 back to script defaults — leaving
the footprint cluster floating 100+ mm away from the board frame.

The fix is two-fold: gate **every** layout-touching stage behind
`-SkipPlace`, and bake an internal safety guard into each stage that
refuses to clobber pre-existing geometry even if the gate is forgotten.

### Three patterns to apply together

**1. `-SkipPlace` gates BOTH 01 and 03 (not just 03)**

```powershell
if (-not $SkipPlace) {
    & $kpy "python\01_board_outline_and_holes.py"
} else {
    Write-Host "[outline] SKIPPED — preserving outline + mounting holes" -ForegroundColor Yellow
}
# ... 02 always runs (position-safe by design) ...
if (-not $SkipPlace) {
    & $kpy "python\03_place_components.py"
} else {
    Write-Host "[place] SKIPPED — preserving on-board positions" -ForegroundColor Yellow
}
```

**2. Default to CENTERED placement on a CAD page (not `(0, 0)`)**

KiCad's default page is A4 landscape 297 × 210 mm with the title block
in the lower right. A board pinned to `(0, 0)` sits in the upper-left
corner overlapping the page border — confusing, ugly, and the first
thing the user will do is drag it to the middle. Just default-center
it:

```python
# At the top of 01_board_outline_and_holes.py
BOARD_W_MM = 88.9
BOARD_H_MM = 52.1

# KiCad A4 landscape page: 297 × 210 mm, center at (148.5, 105)
# Override these constants for B5/A3/custom pages.
ORIGIN_X_MM = 148.5 - BOARD_W_MM / 2.0   # ≈ 104.05
ORIGIN_Y_MM = 105.0 - BOARD_H_MM / 2.0   # ≈  78.95
```

Then thread `ORIGIN_X_MM, ORIGIN_Y_MM` through `place_mounting_hole(...)`
and `draw_rectangle_outline(...)`. First-time users get a sensibly
placed board; later runs can be safely re-run because the script's
intent now matches the user's natural placement.

**3. Position-safety guard inside each layout stage**

The build script's `-SkipPlace` gate is the outer ring. The inner
ring is a check inside each stage that refuses to overwrite
pre-existing geometry. This makes the script idempotent — first run
sets things up, every later run is a no-op until you pass `--force`:

```python
# Inside 01_board_outline_and_holes.py main(), right after LoadBoard
edge_layer = board.GetLayerID(EDGE_CUTS_LAYER)
existing_edges = [d for d in board.GetDrawings() if d.GetLayer() == edge_layer]
existing_holes = {
    fp.GetReference()
    for fp in board.Footprints()
    if fp.GetReference().startswith("H") and fp.GetReference()[1:].isdigit()
}
expected_holes = {ref for _, _, _, _, ref in MOUNTING_HOLES}
force = "--force" in sys.argv

if existing_edges and expected_holes.issubset(existing_holes) and not force:
    print(f"Edge.Cuts has {len(existing_edges)} segment(s) and all "
          f"{len(expected_holes)} mounting holes already exist.")
    print("Leaving the existing layout alone. Pass --force to redraw.")
    return 0
```

The exact same pattern goes into `03_place_components.py` against the
`PLACEMENT` dict:

```python
expected = set(PLACEMENT)
force = "--force" in sys.argv
if expected.issubset(set(by_ref)) and not force:
    print(f"All {len(expected)} placement-managed footprint(s) already exist.")
    print("Leaving their positions alone. Pass --force to re-apply the PLACEMENT dict.")
    return 0
```

### Recovery: one-shot translate-everything helper

When the bug has already bitten and the user's component cluster is
offset from the script's board frame, write a one-shot translator
instead of asking the user to redo their work. Compute the delta from
one anchor (e.g. the first component's recorded position vs. its
current location), then translate all Edge.Cuts segments and all
mounting holes by that delta:

```python
# _restore_board_origin.py — one-shot fix
DX_MM, DY_MM = +116.25, +73.75   # delta to apply
for d in board.GetDrawings():
    if d.GetLayer() == board.GetLayerID("Edge.Cuts"):
        d.Move(pcbnew.VECTOR2I(pcbnew.FromMM(DX_MM), pcbnew.FromMM(DY_MM)))
for fp in board.Footprints():
    ref = fp.GetReference()
    if ref.startswith("H") and ref[1:].isdigit():
        p = fp.GetPosition()
        fp.SetPosition(pcbnew.VECTOR2I(
            p.x + pcbnew.FromMM(DX_MM), p.y + pcbnew.FromMM(DY_MM)))
```

Add a sanity check (e.g. "refuse if H1.x > 50 mm") so a stale copy of
the script can't be re-run later and double-translate.

### Lesson summary

- **`-SkipPlace` must gate every stage that writes layout**, not just
  the obvious `03_place_components.py`. Board outline + mounting
  holes are layout too.
- **Default the board origin to the center of the CAD page**
  (`(148.5, 105)` for A4 landscape), not `(0, 0)`. CAD convention,
  and it matches where users naturally drag the board.
- **Belt + suspenders:** every layout-touching script ALSO checks for
  pre-existing geometry on load and exits early unless `--force`. The
  outer `-SkipPlace` gate handles intent; the inner guard handles
  forgotten flags.
- **When the bug bites, translate — don't rebuild.** A one-shot
  translator preserves user work; a "re-run with --force" loses it.

---

## 6.9. Multi-Angle 3D Renders Catch Mistakes That 2D Hides

`kicad-cli pcb render` is fast, headless, and produces beautiful
photo-real PNGs. Use it on every build. **One angle is not enough**
— each angle reveals a different class of mistake that the others
hide. Three is the sweet spot for AI/human review of a fab candidate.

### The pattern: three render passes per build

```pwsh
# 1. Top-down isometric — overall layout, ref designators, fit
Write-Host "[build] 3D render (top, isometric)..." -ForegroundColor Cyan
& $kcli pcb render `
  --output "$ROOT/$PROJ-3d-top.png" `
  --side top --quality high --rotate "-30,0,45" --background transparent `
  --width 1600 --height 900 `
  $BOARD

# 2. Low isometric — reveals connector wire-entry direction,
#    component lean, mounting hardware collisions
Write-Host "[build] 3D render (low iso — connector wire entry)..." -ForegroundColor Cyan
& $kcli pcb render `
  --output "$ROOT/$PROJ-3d-iso.png" `
  --side top --quality high --rotate "-65,0,30" --background transparent `
  --width 1600 --height 900 `
  $BOARD

# 3. Pure side view — component heights, THT lead length,
#    enclosure clearance, taller-than-expected caps/connectors
Write-Host "[build] 3D render (front side)..." -ForegroundColor Cyan
& $kcli pcb render `
  --output "$ROOT/$PROJ-3d-front.png" `
  --side front --quality high --background transparent `
  --width 1600 --height 600 `
  $BOARD
```

`--side` accepts `top, bottom, left, right, front, back`. `--rotate`
takes XYZ Euler degrees (`-30,0,45` is the classic "isometric from
above"; `-65,0,30` is much closer to table-height for showing
side-mounted connectors).

### What each angle catches

| Angle | Catches |
|-------|---------|
| **`-3d-top.png`** (-30°/45° iso) | Wrong footprint, missing component, ref designator typo, gross silkscreen errors, mounting hole clearance |
| **`-3d-iso.png`** (-65°/30° low iso) | **Connector wire entry on wrong face**, body collisions, component lean, screw heads pointing inward, 3D model misalignment, MKDS/Phoenix wire-side orientation |
| **`-3d-front.png`** (`--side front`) | Component HEIGHT issues, THT lead length collisions, "this electrolytic is taller than my enclosure standoff", connector profile vs. panel cutout |

### The "wire entry on the wrong face" trap

The single most common mistake the iso view catches: horizontal screw
terminals (MKDS, Phoenix, Bourns, Wago) rotated so the wire-entry
holes face the **interior** of the board instead of the **edge**. The
top-down render hides this because all terminal blocks look identical
from above. The low iso shows it instantly — wires would have to make
a U-turn over the body to reach the edge.

If the user reports "the J connectors are the wrong direction", the
fix is a 180° rotation. KiCad rotates around pin 1, which **swings
the body to the opposite side**. To keep the body roughly in place
while flipping the wire entry, you must also translate by
`(pitch * (n_pads - 1), 0)` along the connector's pad axis. See the
`_rotate_connectors.py` / `_complete_rotation.py` pair in the
`rocket-launch-controller` project for the working pattern.

### `--preset` and theming

`--preset follow_pcb_editor` makes the render use whatever appearance
preset you have selected in the GUI (silkscreen color, solder mask
opacity, etc). Default is `follow_plot_settings`. Use `--background
transparent` for compositing into docs; `--background opaque` for
printable artifacts.

### Anti-patterns to avoid

- **Rendering only top-down.** You will ship a board with a connector
  pointing the wrong way.
- **Rendering at low resolution.** `--width 1600` is the minimum that
  reads well in a README; `--width 800` blurs out ref designators
  and pin numbers.
- **Skipping renders on `-SkipPlace` builds.** The whole point of
  iterative netlist edits is to see the visual result. The render
  step is cheap; always run it.

### 6.9.1. …And 2D Copper Renders Catch What 3D Hides

**Symptom.** You're reviewing the 3D iso render and a net looks
unrouted — you can't see a trace anywhere between the pads. You're
about to delete a "broken" track and re-route, or worse, you assume
a phantom unconnected-item bug. Then you check the actual DRC report
and it says **0 unconnected items**. The trace is there; you just
can't see it.

**Root cause.** The 3D render shows physical bodies on top of the
copper. Through-hole connectors (screw terminals, headers, JST,
Molex), TO-220 / TO-247 packages, electrolytic caps, and any
component whose body extends past its pad row will **hide any trace
that runs under it**. The router often deliberately threads dog-legs
under connector plastic because it's the shortest path between two
pads on the same row — exactly the routing you want.

**The May 2026 NODE_A scare** (real worked example).

```text
J1.1 ──────?───── J2.1 ─?─ J2.3 (NODE_A net)
( all three pads at y = 81.75, in a straight line at the bottom row )
```

In the 3D iso render NODE_A *looked* completely unrouted. I almost
deleted the (perfectly fine) tracks and re-routed at y ≈ 72 above
the connector bodies. Then I checked the 2D copper view:

```text
y=79.65  ┌─────────────────────────────┐  (running INSIDE J2's body
         │                             │   footprint, hidden by plastic
J1.1 ────┘                             │   in 3D)
y=81.75              ┌─── J2.1         │
                     │                 │
                     └─ J2.3 ──────────┘
```

The router had dog-legged at y=79.65 — which sits **inside** the J2
connector body bbox (y=75.18 to 88.92). DRC-clean, minimum trace
length, optimal route. Re-routing would have made it **worse**.

**Detection — always look at both views.**

```pwsh
# 3D render — bodies on top, copper hidden where bodies sit
kicad-cli pcb render --rotate -65,0,30 --output iso.png board.kicad_pcb

# 2D copper plot — bodies removed, all traces visible
kicad-cli pcb export svg `
    --layers F.Cu,B.Cu,Edge.Cuts,F.Silkscreen `
    --page-size-mode 2 --exclude-drawing-sheet `
    --output copper.svg board.kicad_pcb
```

If you have it, also generate the layout-map PNG from your
build-pipeline (e.g., `controller-layout-top.png`) — it shows
exact pad/net positions independent of body shadows.

**Decision protocol for routing review.**

1. **Trust DRC first.** If `kicad-cli pcb drc --severity-error` reports
   0 unconnected items, the net IS connected. Believe the report.
2. **Then look at 2D copper.** Find the trace path; verify the
   route is sensible.
3. **Only then check 3D for orientation/clearance.** 3D shows you
   wire-entry direction, component-height collisions, enclosure fit
   — things 2D can't show.
4. **Never re-route based on a 3D view alone.** "I can't see the
   trace" + "DRC is clean" = "the trace is under a body." That's
   not a bug; that's good routing.

**Anti-patterns.**

- **Deleting a track because the 3D render doesn't show it.** Will
  destroy good routing. Use DRC + 2D copper to verify *first*.
- **Re-routing "around" connector bodies for aesthetics.** Adds
  trace length, adds inductance, costs solder mask area. The router
  was right; the 2D view shows why.
- **Using 3D as the primary copper-review tool.** 3D is for
  physical (wire direction, body height, enclosure fit). 2D copper
  is for electrical (trace path, clearance, net continuity).
- **Cropping the 2D plot to just the pad rows.** You'll miss
  dog-legs that loop above/below into nominally-empty space. Plot
  the full board.

**Guardrails.**

- **Build pipeline should generate BOTH renders every build.** Cost
  is a few seconds; benefit is never falling for the body-shadow
  illusion again.
- **When teaching someone to read PCB views**, walk them through a
  case like this. The "ugly" hidden dog-leg is invisible on the
  assembled board because the connector plastic covers it — purely
  a render artifact.

---

## 6.10. Tracks Can't Cross on Hobby Boards — Pin Swaps Are a Routing Tool

A single-layer board has **one** copper layer. A "2-layer" hobby
board (the kind PCBWay/JLCPCB/OSH Park ship as their cheapest
option) has two, but each layer is still planar. **Two tracks on
the same layer cannot cross.** The only ways past another track are:

1. **Route around** — long detour, eats real estate.
2. **Drop to the other layer via a via** — fine on 2-layer boards but
   adds drill cost per via, a small inductance/capacitance bump, and
   visual clutter. Hobby projects with bottom-side silkscreens or
   bottom-side components (LCDs glued on, magnet holders, etc.)
   often have NO usable bottom layer at all.
3. **Swap the pin assignment so the crossing disappears**  ← preferred.

Option 3 is free. Pin assignment is not a property of the schematic —
it's a property of the **footprint** and the netlist. Swapping which
pad gets which net costs nothing electrically (a screw terminal is
symmetric) and can eliminate a crossing entirely.

### Diagnose first: the ratsnest fly-line view shows topology

`kicad-cli pcb render` hides routability. The §6.5 ratsnest renderer
shows it directly — each net is one straight line per
nearest-neighbor pair, no detours. **Fly-lines that visibly cross
will become traces that have to cross.** Run the ratsnest after
every placement / pin-swap and look at the SVG/PNG before opening
pcbnew to route.

### Worked example (rocket-launch-controller, May 2026)

Three connectors along the top edge of the board with the V+ rail
running up the **inner** column (BAT.1 → F1 → J1 → …):

```
Before:                            After:
                                   
F1 (V+ rail) ─┐                    F1 (V+ rail) ─┐
              │                                  │
              ▼                                  ▼
       ┌─────────┐                        ┌─────────┐
       │ J1.1    │ ← V_FUSED              │ J1.1    │ ← NODE_A  ──┐
       │         │                        │         │             │
       │ J1.2    │ ← NODE_A ──┐           │ J1.2    │ ← V_FUSED   │
       └─────────┘            │           └─────────┘             │
                              │                                   │
                              X CROSSES V+ rail ────►             ▼
                              ▼                              ┌──── J2
                            ┌──── J2                         (clean)
```

The fix was three lines in `00_circuit.py`:

```python
# Before
v_fused += J1[1]
J1[2]   += node_a

# After — V_FUSED matches the inner column, NODE_A on the outer pin
# runs straight to J2 with no crossing
v_fused += J1[2]
J1[1]   += node_a
```

…regenerate the netlist, run `02_apply_netlist.py` (position-safe),
patch the one track endpoint that landed on the swapped pad
(§6.7 / §6.8 talk about that pattern), re-render the ratsnest. The
crossing is gone.

### Pattern checklist

When the agent or user sees crossing fly-lines in the ratsnest PNG:

1. **Identify the columns / rails.** Most hobby layouts have a
   power column and a signal column that run in parallel. Each net
   "wants" to be on the pad in its matching column.
2. **Look for symmetric connectors.** Two-pin screw terminals,
   2-pin Molex/JST, headers in general — pin numbering on these is
   a labelling convention, not an electrical constraint. Swap
   freely.
3. **Swap in `00_circuit.py`** (the source of truth), regenerate
   netlist, run `02_apply_netlist.py`. This is the position-safe
   change.
4. **Patch any already-routed tracks** that ended on the old pad
   coordinates — they're now on a different net. The fix is a
   one-shot `SetStart`/`SetEnd` to the new pad's XY.
5. **Re-render the ratsnest** — confirm the crossing is gone before
   continuing to manual routing.

### When you genuinely can't swap

Some components have asymmetric pads where the net assignment is
physical, not labelling:

- **Polarized parts** (diodes, electrolytic caps, LEDs) — A and K
  are not interchangeable.
- **ICs** — pin functions are fixed by the chip.
- **Multi-function connectors** with documented pinouts the user
  expects (USB, headers wired to a known module).
- **Already-purchased wired assemblies** where the wire colors are
  cast in stone.

For those, your remaining options are: rotate the footprint,
relocate the footprint, route around (long), or drop to the other
layer (via). On a 2-layer hobby board, a few short vias for genuine
unavoidable crossings are fine — DRC will check the drill size /
clearance for you.

### Anti-patterns to avoid

- **"Just route around it"** without checking the alternative. A
  20 mm detour where a 4 mm swap would have worked wastes board
  area and creates a long parallel pair that picks up noise.
- **"Just add a via"** as the first instinct. Vias cost money on a
  full panel order and complicate hand-routing. Try the swap first.
- **Swapping in `controller.kicad_pcb` directly** by re-typing the
  net on a pad in pcbnew. That works for the moment but the next
  `02_apply_netlist.py` run will revert it because `00_circuit.py`
  is still the source of truth. Always swap in the SKiDL/netlist
  source.
- **Treating "pin 1" as sacred.** On a screw terminal, pin 1 is just
  the pad nearer one end of the body. Use whichever pin keeps the
  routing clean.

### Lesson summary

- **Tracks on the same layer cannot cross.** Hobby 2-layer boards
  give you a second layer but each via costs drill + clearance area;
  prefer to avoid the crossing entirely.
- **The ratsnest fly-line view is your crossing detector — with a
  caveat.** It shows topology requirements (which pads need to
  connect) but assumes straight pad-to-pad lines. The actual
  routable space can include dog-legs through the empty band above
  or below a connector's pad row — see §6.10.3 before declaring
  any routing impossible.
- **Pin assignment is a routing tool.** On symmetric connectors,
  swapping which pad gets which net is free and often eliminates the
  crossing.
- **Swap at the source.** Edit `00_circuit.py`, regenerate the
  netlist, run `02_apply_netlist.py`. Patch any already-routed track
  endpoints that pointed at the old pad.
- **When the user has hand-routed something, read the live tracks
  first.** Don't argue topology from the ratsnest alone (§6.10.3).

---

## 6.10.1. Stale Tracks After a Pin-Swap — Generic Rip Helper

**Symptom.** Right after `02_apply_netlist.py` runs on a board that
already had some routing done, DRC fires "pad/track on different
nets" or — worse — silently shorts two nets together where a track
crosses a copper region of its new (wrong) net. Sometimes the only
visible sign is a previously-clean net suddenly showing as
"unconnected" in the ratsnest.

**Root cause.** `02_apply_netlist.py` only touches **pads** (it
calls `pad.SetNet(net)` for each pad). It does **not** touch
tracks. So when a pin-swap moves J2.2 from `NODE_B` to `GND`, the
pad correctly flips to `GND` but the existing track on that pad
still stores its old net code (`NODE_B`). The track + pad pair is
now on two different nets — a topological inconsistency.

**Detection.** A pad whose `GetNetname()` ≠ the `GetNetname()` of
any track whose endpoint sits on it (within ~10 µm) is stale-track
evidence. The "endpoint sits on a pad" qualifier matters: if you
only check the track's net against the pad's net you'll falsely
flag free-floating mid-net segments.

**Fix pattern.** A generic, idempotent sweeper. Rip the offending
tracks, don't try to auto-re-route them — routing is the human's
(or another helper's) job:

```python
# _rip_changed_net_tracks.py — keep this generic and project-agnostic.
def main():
    board = pcbnew.LoadBoard(BOARD_FILE)
    all_pads = [p for fp in board.Footprints() for p in fp.Pads()]
    stale = []
    for trk in board.Tracks():
        if not isinstance(trk, pcbnew.PCB_TRACK):
            continue
        for ep in (trk.GetStart(), trk.GetEnd()):
            pad = _pad_at(ep, all_pads)  # within COORD_EPS_NM
            if pad is None:
                continue
            if pad.GetNetname() == "" or pad.GetNetname() == trk.GetNetname():
                continue
            stale.append(trk)
            break  # one mismatching endpoint is enough
    for trk in stale:
        board.Remove(trk)
    pcbnew.SaveBoard(BOARD_FILE, board)
```

**Wire it into the pipeline IMMEDIATELY AFTER `02_apply_netlist.py`**
and fail the build on non-zero exit. Run the rip BEFORE silkscreen
moves / DRC / gerber so downstream steps see a consistent board:

```pwsh
& $kpy "python\02_apply_netlist.py"
if ($LASTEXITCODE -ne 0) { throw "Netlist apply failed." }

Write-Host "[rip] _rip_changed_net_tracks.py → drop stale tracks after net swaps"
& $kpy "python\_rip_changed_net_tracks.py"
if ($LASTEXITCODE -ne 0) { throw "Stale-track sweeper failed." }
```

**Guardrail.** Idempotent — runs every build, no-ops on a clean
board, no need to gate it behind "did we swap pins this run?"
logic. The cost (one `LoadBoard` + one pass over tracks) is
negligible.

**Why a 10 µm tolerance.** KiCad stores coordinates as integer
nanometres. Tracks routed from a footprint's pad anchor exactly to
the pad center; tracks routed in pcbnew's grid mode might land
sub-µm off the center due to grid quantization. 10 µm is well
above either source of noise and well below any plausible routing
tolerance (your finest track on a hobby board is ~150 µm wide).

---

## 6.10.2. Re-routing After a Rip — Helper Discipline

**Symptom 1: SwigPyObject is not iterable.** A second call to
`board.Tracks()` after `board.Remove(trk)` throws
`TypeError: 'SwigPyObject' object is not iterable`. Symptom 2:
the board file silently mutates wrong because tracks have already
been removed but the helper's "is this segment present?" probe is
looking at a stale iterator. Symptom 3: BFS over track-to-track
shared endpoints chases the chain THROUGH another part's pad
(e.g. across `D3.K` into the legitimate `D3 ↔ J3` routing) and
rips legitimate tracks.

**Root causes.**

1. **`board.Tracks()` returns a SWIG iterator** that becomes
   invalid as soon as you mutate the board (e.g. `board.Remove()`).
   You **must** materialise the list once at the top of `main()`
   and never call `board.Tracks()` again until you re-snapshot
   after all mutations are done.
2. **Pads anchor nets.** A "chain of tracks on the same net via
   shared endpoints" terminates conceptually at every pad it
   touches. A naive BFS that just follows shared endpoints will
   walk straight through a pad and eat the routing on the other
   side. Pads have to be explicit stop-signs in the walk.
3. **Pad coordinates are NOT stable across builds.** If your
   pipeline includes a placement-optimization step (`05_place.py`
   or similar) that moves footprints based on ratsnest length or
   user-specified bounding boxes, the live pad XY this build can
   differ from the XY you observed last build. **Never hardcode
   pad coordinates** in a route helper — always read them at
   runtime via `_find_pad(board, "J2", "2").GetPosition()`.

**Pattern: one-shot re-route helper.** The dance is:

1. Read live pad XY for every pad you plan to touch.
2. Read the live Y (or X) of any existing track you plan to T into,
   by scanning the snapshot for the longest matching horizontal /
   vertical segment that spans the column / row you need.
3. Build a list of "owned segments" `(start_xy, end_xy, net, layer)`
   computed from the live coordinates.
4. Rip every track on your nets that touches your pads and is NOT
   one of the owned segments.
5. Re-snapshot tracks (the rip mutated the board).
6. For each owned segment: skip if already present (endpoints match
   within `COORD_EPS_NM`), otherwise add it.

That gives you idempotency, self-healing across runs (even if a
previous run put tracks on the wrong layer or wrong coordinates),
and robustness to footprint movement.

**Crossings are the case for B.Cu cross-unders.** When two new
tracks must cross — e.g. NODE_B running east while GND runs south
through the same point — and **both endpoints of one of them are
THT (through-hole) pads**, route that track on **B.Cu**. THT pads
span F.Cu and B.Cu, so the layer change happens inside the pad
**without a via**. Free crossing. Surface-mount pads can't do this
trick — they're single-layer — and a SMT-only crossing requires a
real via or a re-route.

**Wire it into the pipeline AFTER the rip step**, with a clear
comment that it's a one-shot project-specific helper that should
be pruned (or generalized) at the next major net reshuffle:

```pwsh
# One-shot fixup for the May 2026 J2 pin-swap …
Write-Host "[route] _route_j2_swap_fixup.py → re-route NODE_B from J2.4, GND from J2.2"
& $kpy "python\_route_j2_swap_fixup.py"
if ($LASTEXITCODE -ne 0) { throw "J2 swap-fixup router failed." }
```

**Guardrails.**

- Validate **before mutating**: if the pads aren't on the nets you
  expect (`raise SystemExit` if `J2.2.GetNetname() != "GND"`), you
  almost certainly have a netlist drift and the routing plan is
  wrong. Better to fail loudly than silently route to nowhere.
- Always print the live coordinates you computed so the build log
  shows `J2.4 @ (148.67, 81.75)  NODE_B → D3.K @ (176.92, 95.25)`.
  When a future placement run moves things, the divergence will be
  obvious in the log diff.

### Lesson summary

- **Snapshot `board.Tracks()` once.** SWIG iterators don't survive
  mutation.
- **Pads stop the walk.** A BFS that chases shared endpoints must
  stop at any pad coordinate, or it'll eat foreign-net routing.
- **Read pad XY at runtime.** Placement steps move footprints; live
  pad positions are the only stable coordinate source.
- **THT-to-THT crossings are free on B.Cu.** Drop one of the two
  conflicting tracks to B.Cu and the THT pads handle the layer
  change with no via.
- **Two-pass helper discipline:** validate → plan from live data →
  rip non-owned tracks → re-snapshot → add missing owned segments.
  That recipe is idempotent, self-healing, and movement-tolerant.

---

## 6.10.3. The Ratsnest Lies — Read Actual Tracks Before Arguing Topology

**Symptom.** The agent looks at the ratsnest (or just at pad
positions in the netlist) for a board with `N` same-net pads
separated by a different-net pad and confidently declares "this
needs a B.Cu cross-under" or "you have to swap pins to make these
adjacent" — but the user has *already* hand-routed it cleanly on
F.Cu with no via. The agent then argues with the user, who has
to push back twice before the agent actually looks at the live
copper.

**Root cause.** The ratsnest renderer (§6.5) draws **straight
nearest-neighbor lines** between same-net pads. It assumes the
copper must travel pad-center to pad-center. That assumption is
useful for *placement* analysis (long fly-lines flag bad
placement) but **dangerously wrong for routability**:

- A track does not have to enter a pad on its centerline.
- The connector body's outline is just F.SilkS — it's not a
  keepout. The empty F.Cu space *above* or *below* the pad row
  (between pad-y and connector-edge-y) is fully routable.
- A small dog-leg into that band lets a track skip over an
  adjacent pad while staying on the same layer.

**Worked example (rocket-launch-controller, May 18 2026).** J2
is a 4-pos screw terminal. The pad nets, left-to-right as the
user sees them on the board, were `NODE_A · GND · NODE_A · NODE_B`.
The agent looked at the ratsnest and insisted the two NODE_A
pads (separated by GND) created an unroutable crossing,
recommending a pin swap. The user replied: *"if you look at the
actual routing I did in KiCad you will see that I did route J2.4
and J2.2 together"*. Pulling the live tracks out of pcbnew showed:

```
NODE_A track segments on F.Cu (no vias):
  J2.4 (148.67, 83.5) → (151.17, 81.0)    diagonal NE
       (151.17, 81.0) → (156.33, 81.0)    east, ABOVE the pads
       (156.33, 81.0) → J2.2 (158.83, 83.5)  diagonal back down
```

The dog-leg jogged 2.5 mm north into the empty band between the
pad row (y = 83.5) and the connector body's top edge (y ≈ 80.5),
ran east *over the top of* the J2.3 GND pad, and dropped back
south to J2.2. No crossing, no via, no pin swap needed.

**Detection.** Before arguing topology with the user — or
recommending a pin swap, or planning a B.Cu cross-under, or
declaring N connections "blocked":

1. **List the live tracks for the net.** This script answers
   "what's actually on the board right now" in one shot:

   ```python
   import pcbnew
   b = pcbnew.LoadBoard("controller.kicad_pcb")
   def mm(p): return (round(pcbnew.ToMM(p.x), 2), round(pcbnew.ToMM(p.y), 2))
   for net in ("NODE_A", "NODE_B", "GND", "V_FUSED", "V+"):
       print(f"=== {net} ===")
       for t in b.Tracks():
           if not isinstance(t, pcbnew.PCB_TRACK): continue
           if t.GetNetname() != net: continue
           layer = b.GetLayerName(t.GetLayer())
           kind  = "VIA" if isinstance(t, pcbnew.PCB_VIA) else "trk"
           print(f"  [{layer:6s}] {kind} {mm(t.GetStart())} -> {mm(t.GetEnd())}")
   ```

2. **Run DRC.** `kicad-cli pcb drc --severity-error` reports
   `0 unconnected items` if the net is fully connected, regardless
   of *how* it got connected. That's the ground truth — if DRC says
   the net is whole, it is.

3. **Only then** reason about whether a topology change would
   improve things.

**Fix pattern.** Two halves:

- **For the immediate conversation:** apologize, re-read the live
  copper, and align the SKiDL source to the routed board (pin
  swap in `00_circuit.py` so future `02_apply_netlist.py` runs
  preserve the hand-routing instead of fighting it). This is
  the SKiDL-follows-board direction of the source/board sync.

- **For future conversations:** when the user mentions any
  routing they did, the agent's first action is to dump the live
  tracks (the snippet above), *not* to consult the ratsnest or
  the pad table.

**Guardrail.**

- **Never argue routability from the ratsnest alone.** The
  ratsnest answers "what does the topology require?", not "what
  has been built?".
- **Never argue routability from pad positions alone.** Pad
  positions tell you where the *endpoints* are, not what's
  routable between them.
- **The user's actual board is the source of truth for what's
  routed.** SKiDL is the source of truth for what *should be*
  connected. When they disagree after a hand-edit, sync SKiDL
  to the board (pin swap, footprint relabel) unless the board
  is wrong.
- **DRC `0 unconnected items` ends the argument.** If the board
  builds clean, the routing works — regardless of whether the
  agent's mental model agrees.

**Lesson summary.**

- The ratsnest is a *placement* tool, not a *routability* tool.
- The empty space above/below a connector's pad row is real
  F.Cu real estate. A 2-3 mm dog-leg through it can skip over
  a same-row pad without crossings or vias.
- Pull live tracks with `board.Tracks()` before reasoning about
  routing. Five lines of Python beats five paragraphs of
  topology speculation.
- When the user contradicts the agent's routing analysis, the
  user is almost certainly right — they're looking at the
  copper, the agent is looking at an abstraction.

---

## 6.11. Component Values Don't Show in 3D — Move Them to `F.Silkscreen`

**Symptom.** Reviewing a 3D render of a board you authored from
Python: reference designators (`BAT`, `J1`, `D3`…) appear on the
white silkscreen, but the *value* fields (`+12V/GND in`, `ARM_SW`,
`1N4007`) are invisible — even though `pcbnew`'s 2D view shows them
clearly. For a hobby board where the user will be wiring screw
terminals in the field, the descriptive value text is *more* useful
than the reference designator.

**Root cause.** Every footprint has two default text fields:

| Field | Default layer | Visible in… |
|-------|---------------|-------------|
| `Reference()` (`BAT`, `J1`, …) | `F.Silkscreen` | 2D + 3D render + physical silk |
| `Value()` (`+12V/GND in`, …)   | `F.Fab`        | 2D fab plot **only** — not 3D, not physical |

`F.Fab` is the assembly-drawing layer. It's intended for the
fabricator's internal docs, not the manufactured board, so neither
`kicad-cli pcb render` (default layer set: `F.Silkscreen` + `F.Cu` +
`F.Mask` + `Edge.Cuts`) nor the actual PCB carries it.

You'll see this on every new footprint added through
`02_apply_netlist.py`, because library defaults set `Value()` to
`F.Fab`.

**Detection.** From KiCad's bundled python:

```python
import pcbnew
b = pcbnew.LoadBoard("controller.kicad_pcb")
silk = b.GetLayerID("F.Silkscreen")
for fp in b.Footprints():
    layer_name = b.GetLayerName(fp.Value().GetLayer())
    print(f"{fp.GetReference():>4} {fp.GetValue()!r:24} {layer_name}")
```

If you see `F.Fab` for any production component, it won't render in
3D and won't be on the manufactured board.

**Fix — one position-safe helper, idempotent, in the build pipeline.**

```python
# python/_silkscreen_values.py — run from KiCad's bundled python
import pcbnew, os
board = pcbnew.LoadBoard("controller.kicad_pcb")
silk = board.GetLayerID("F.Silkscreen")
moved = 0
for fp in board.Footprints():
    ref = fp.GetReference()
    # Skip mounting holes — "M2"/"M3" values clutter without helping
    if ref.startswith("H") and ref[1:].isdigit():
        continue
    if fp.Value().GetLayer() == silk:
        continue  # idempotent — already silk-screened
    fp.Value().SetLayer(silk)
    moved += 1
if moved:
    pcbnew.SaveBoard("controller.kicad_pcb", board)
```

Wire it into `build_fab.ps1` *after* `02_apply_netlist.py` and
*before* the render step. It's strictly safer than the netlist
import (only changes a layer enum on text fields; never touches
positions, nets, or pads), so it can always run — it does NOT need
to be gated behind `-SkipPlace`.

**Guardrails.**

- **Skip mounting holes.** Their values are usually `M2`/`M3` —
  meaningful in the BOM but redundant on silk where you already see
  the `H1`–`H6` reference designators.
- **Position-safe.** Only touch `.SetLayer()` on the value field;
  never `.SetPosition()`. The footprint library has already chosen a
  reasonable text position relative to the body; trust it.
- **Idempotent guard.** Skip footprints whose value field is already
  on `F.Silkscreen`. This means the helper can run on every build
  without churning the `.kicad_pcb` file.
- **Don't include `F.Fab` in the render instead.** Tempting, but
  `F.Fab` also carries courtyards and duplicate reference designators
  — the render gets cluttered fast. Moving values to `F.Silkscreen`
  is a clean one-way trip *and* the labels end up on the real board,
  which is the bigger win.

**Why this matters more than it sounds.** For a launch controller
operated in the field, having `+12V/GND in`, `ARM_SW`,
`FIRE_SW+LED`, and `OUT+/OUT-` permanently silk-screened next to
each screw terminal eliminates an entire class of "wait, which wire
goes where" mistakes — and it's the same change that makes the 3D
render review usable by anyone who isn't fluent in CAD.

### 6.11.1. Resize + Reposition the Value, or DRC Will Complain

**Symptom.** You move Value fields to `F.Silkscreen`, the 3D render
looks great, but KiCad's DRC reports

```
Warning: Silkscreen clearance
  Value field of J1 (FIRE_SW/fused+)
  Polygon of J1 on F.Silkscreen
```

…once per part you re-layered. The board fabs fine but the warning
list looks noisy and any future "0 warnings" gate breaks.

**Root cause.** KiCad's stock Value field is **1.0 mm tall, 0.15 mm
thick, sitting at the footprint origin** — which is usually *inside*
the footprint's own silkscreen polygon (the rectangle drawn around
a connector body, for example). The polygon-to-text clearance default
is ~0.15 mm; the text overlaps the polygon by several mm.

The `F.Fab` Value field doesn't trigger this because `F.Fab` isn't
in the silkscreen-clearance check. As soon as you push it to
`F.Silkscreen`, DRC starts caring.

**Fix.** When relayering Value to `F.Silkscreen`, also:

1. **Shrink the font.** 0.8 mm tall / 0.12 mm thick reads fine on a
   typical 1.5–2 mm clear band and dodges the clearance check.
2. **Push the text just OUTSIDE the footprint's `GetBoundingBox()`.**
   Half-text-height + 0.15 mm clearance + ~0.25 mm safety margin =
   ~0.8 mm offset from the bbox edge. Auto-pick "above" vs "below"
   from the footprint's Y relative to the board centroid so labels
   always land in the empty band along the nearest board edge.

Skeleton (idempotent — re-run does nothing once labels are clean):

```python
TEXT_SIZE_MM   = 0.8
TEXT_THICK_MM  = 0.12
EDGE_OFFSET_MM = 0.8

def _resize_value(val_field) -> bool:
    target_size  = pcbnew.VECTOR2I(pcbnew.FromMM(TEXT_SIZE_MM),
                                   pcbnew.FromMM(TEXT_SIZE_MM))
    target_thick = pcbnew.FromMM(TEXT_THICK_MM)
    changed = False
    if val_field.GetTextSize() != target_size:
        val_field.SetTextSize(target_size); changed = True
    if val_field.GetTextThickness() != target_thick:
        val_field.SetTextThickness(target_thick); changed = True
    return changed

def _reposition_value_outside_body(board, fp, val_field) -> bool:
    fp_bbox    = fp.GetBoundingBox()
    board_bbox = board.GetBoundingBox()
    board_cy   = (board_bbox.GetTop() + board_bbox.GetBottom()) // 2
    place_above = fp.GetPosition().y < board_cy
    target_y = (fp_bbox.GetTop()    - pcbnew.FromMM(EDGE_OFFSET_MM)
                if place_above else
                fp_bbox.GetBottom() + pcbnew.FromMM(EDGE_OFFSET_MM))
    target_x = (fp_bbox.GetLeft() + fp_bbox.GetRight()) // 2
    new = pcbnew.VECTOR2I(target_x, target_y)
    if val_field.GetPosition() == new:
        return False
    val_field.SetPosition(new)
    return True
```

**Verify warnings are actually gone.** The default `kicad-cli pcb
drc` only reports *errors*. To catch silkscreen-clearance warnings
(which are the whole point of this fix), run:

```pwsh
kicad-cli pcb drc --severity-all --output drc-warnings.rpt board.kicad_pcb
```

The build pipeline should run this variant after any silkscreen edit
so the warning regression is caught by the same script that ran the
edit.

**Anti-pattern.** Disabling the silkscreen-clearance check in
`board.kicad_dru` to make the warnings go away. The check exists
because overlapping silk prints poorly — text gets blobby and
unreadable. Fix the layout, don't silence the check.

---

## 6.12. Missing 3D Models — Generate Parametric STEP, Don't Swap Footprints

**Symptom.** A component is correctly placed on the 2D board and
shows up in `pcbnew`'s 2D view, but the 3D render
(`kicad-cli pcb render`) has a blank spot where the component
should be. Other components render fine.

**Root cause.** The component's footprint references a STEP file
that **does not actually ship with KiCad 10**. Many KiCad footprints
have `${KICAD10_3DMODEL_DIR}/.../SomePart.step` paths in their
default model list, but only a subset of those STEP files are
installed. The render silently renders nothing rather than
substituting a placeholder. Real example:
`Fuse:Fuse_Bourns_MF-RG300` references
`Fuse.3dshapes/Fuse_Bourns_MF-RG300.step` — but that STEP isn't
present in a default KiCad 10.0.3 install on Windows.

**Detection.** From KiCad's bundled python:

```python
import pcbnew, os
b = pcbnew.LoadBoard("controller.kicad_pcb")
for fp in b.Footprints():
    for m in fp.Models():
        # Resolve env vars; here ${KICAD10_3DMODEL_DIR} = the install share dir
        resolved = m.m_Filename.replace(
            "${KICAD10_3DMODEL_DIR}",
            r"C:\Program Files\KiCad\10.0\share\kicad\3dmodels",
        )
        if not os.path.exists(resolved):
            print(f"MISSING: {fp.GetReference()}  {m.m_Filename}")
```

Any footprint that prints is invisible in 3D renders.

**The wrong fix: swap to a footprint whose STEP exists.** Tempting
because KiCad ships *similar* parts (e.g., BelFuse 0ZRE radial PTCs
when Bourns MF-R is missing), but the substitute almost always has
**different pad spacing** — the BelFuse 2A part is 10.4mm pitch vs
the Bourns 5.24mm. Swapping moves your pads, which breaks any
hand-routed traces touching them and forces a re-route. **Don't.**

**The right fix: generate a parametric STEP with build123d that
matches the part you actually have, then re-target.**

1. **Look up actual part dimensions** from the manufacturer datasheet
   or the product listing where you bought it (Amazon listings often
   carry the L×W×H in the spec block).
2. **Build a STEP with build123d** at the *same* pad-local origin and
   axes as the existing footprint. The model must place its
   leads/pins at the exact pad coordinates listed in the
   `.kicad_mod` file (pad 1 typically at `(0,0)`).
3. **Save into the project tree** (e.g., `libs/3dmodels/`) and
   reference via `${KIPRJMOD}/libs/3dmodels/MyPart.step` so the model
   travels with the repo and is never confused with the missing
   stock model.
4. **Write a tiny pcbnew helper** to rewrite the footprint's
   `Models()` list — clear, push a fresh `FP_3DMODEL` with the new
   `m_Filename`, save. Idempotent (no-op if already pointing at the
   project-local path).

**Worked example (May 2026, F1 polyfuse):**

```python
# python/_generate_fuse_3d.py — runs once, output committed to repo
from build123d import (Rectangle, fillet, extrude, Cylinder, Pos,
                       Axis, Color, Compound, Vector, export_step)
PAD1, PAD2 = Vector(0, 0, 0), Vector(5.1, 1.2, 0)  # MF-RG300 frame
sketch = Rectangle(13.0, 9.0)
sketch = fillet(sketch.vertices(), radius=3.5)
body = extrude(sketch, amount=2.0).rotate(Axis.X, 90)
midpoint = (PAD1 + PAD2) * 0.5
body = Pos(midpoint.X, midpoint.Y, 5.5) * body
body.color = Color(0.95, 0.78, 0.10)  # PPTC yellow
leads = [Pos(p.X, p.Y, -1.1) * Cylinder(radius=0.3, height=4.2)
         for p in (PAD1, PAD2)]
export_step(Compound(children=[body, *leads]), "libs/3dmodels/Polyfuse_2A.step")
```

```python
# python/_link_fuse_3d.py — idempotent, runs every build
import pcbnew
b = pcbnew.LoadBoard("controller.kicad_pcb")
f1 = next(fp for fp in b.Footprints() if fp.GetReference() == "F1")
NEW = "${KIPRJMOD}/libs/3dmodels/Polyfuse_2A.step"
if [m.m_Filename for m in f1.Models()] == [NEW]:
    print("already linked"); exit(0)
while not f1.Models().empty():
    f1.Models().pop_back()
m = pcbnew.FP_3DMODEL(); m.m_Filename = NEW
f1.Models().push_back(m)
pcbnew.SaveBoard("controller.kicad_pcb", b)
```

Wire `_link_fuse_3d.py` into the build pipeline alongside any other
post-netlist patchers (`_silkscreen_values.py` etc.); the STEP itself
is committed to the repo so most consumers never need build123d.

**Guardrails.**

- **`${KIPRJMOD}` always for project-local models.** Never use
  absolute paths; never use `${KICAD10_3DMODEL_DIR}` for files you
  generated. Project-local paths travel with the repo and don't
  break on other machines or future KiCad versions.
- **Match pad positions exactly.** The model's lead/pin coordinates
  must equal the `(at X Y)` values in the original `.kicad_mod`.
  Otherwise the leads will float in space relative to the PCB holes.
- **build123d goes in a separate venv.** The skidl venv has
  pure-Python deps only; build123d brings `cadquery-ocp` which is
  huge. Use scoop's Python or a dedicated CAD venv for the
  generation step; KiCad's bundled python is fine for the link step
  (it only uses `pcbnew`).
- **Iterate against the iso render.** Run `kicad-cli pcb render
  --rotate -65,0,30` and visually check the new model sits on the
  board correctly (leads enter the holes, body doesn't intersect
  other components). Easier than checking measurements numerically.

**Pattern checklist.**

```
[ ] Identify the missing part by diff-ing pcbnew model paths vs disk
[ ] Look up actual purchased part's L×W×H + lead pitch from datasheet
[ ] Keep existing footprint (preserve pad positions, preserve routing)
[ ] Generate STEP with build123d, pad-local origin matching .kicad_mod
[ ] Save under libs/3dmodels/ (project-local, ${KIPRJMOD} path)
[ ] Idempotent linker patches Models() list and commits
[ ] Wire linker into build pipeline; STEP itself is checked in
[ ] Re-render iso view and visually confirm leads + body sit right
```

---

## 7. Headless DRC — Two Ways

### `kicad-cli` (preferred — CI-friendly)

```pwsh
kicad-cli pcb drc `
  --severity-error `
  --schematic-parity `
  --exit-code-violations `
  --output fab\drc.rpt `
  controller.kicad_pcb
```

Exit code 5 = violations. Wire into a pre-fab gate.

### `pcbnew.DRC_ENGINE` (in-process)

```python
import pcbnew

board = pcbnew.LoadBoard("controller.kicad_pcb")
board.BuildConnectivity()

drc_engine = pcbnew.DRC_ENGINE(board, board.GetDesignSettings())
drc_engine.InitEngine(pcbnew.wxFileName())  # default rules file
violations = []
def on_violation(item, pos):
    violations.append(str(item.GetErrorMessage()))
drc_engine.SetViolationHandler(on_violation)
drc_engine.RunTests(pcbnew.EDA_UNITS_MILLIMETRES, True, None)
print(f"{len(violations)} DRC violation(s)")
```

The `pcbnew.DRC_ENGINE` API is more verbose than `kicad-cli` and the
shape of `SetViolationHandler` varies slightly between KiCad versions.
Use `kicad-cli` unless you need DRC results mid-script (e.g. fail
fast on a known-bad placement before continuing).

### Quick ratsnest count

```python
board.BuildConnectivity()
unconnected = board.GetConnectivity().GetUnconnectedCount(False)
print(f"{unconnected} unconnected ratsnest item(s)")
```

This is a cheap "did I route everything?" check.

---

## 8. Net Classes, Tracks, and Design Rules in Python

Two separate problems live under this heading:

1. **Define** a net class (track widths, clearances, via sizes) and
   assign nets to it. *Lives in `.kicad_pro` JSON. No `pcbnew` or
   `kicad-cli` API.*
2. **Use** a net (lay down tracks/vias on the live board). *Lives in
   `.kicad_pcb`. Standard `pcbnew` Python API.*

Doing them headlessly takes two different patches in two different
files. Don't confuse them.

### 8.1. Defining net classes — patch `.kicad_pro` JSON

KiCad 10 has **no CLI or `pcbnew` API for net classes.** `kicad-cli
pcb` has no `netclass` subcommand, and `pcbnew.BOARD_DESIGN_SETTINGS`
exposes the board's view of them but doesn't let you persist new ones
to the project file. The supported headless workaround is to patch the
`.kicad_pro` JSON directly. Net classes are read from `.kicad_pro` at
board-open time, so editing the JSON is fully sufficient — you don't
also need to touch the `.kicad_pcb`.

A reusable idempotent patcher (`01_apply_design_rules.py`):

```python
import json, os
from copy import deepcopy

PRO_FILE = "controller.kicad_pro"

# Tuned for PCBWay 2-layer, 1.6 mm, 1 oz copper.
DEFAULT_CLASS = {
    "name": "Default",
    "track_width": 0.4, "clearance": 0.2,
    "via_diameter": 0.6, "via_drill": 0.3,
    "microvia_diameter": 0.3, "microvia_drill": 0.1,
    "diff_pair_width": 0.4, "diff_pair_gap": 0.2, "diff_pair_via_gap": 0.25,
    "bus_width": 12, "wire_width": 6, "line_style": 0,
    "priority": 2147483647,
    "pcb_color": "rgba(0, 0, 0, 0.000)",
    "schematic_color": "rgba(0, 0, 0, 0.000)",
    "tuning_profile": "",
}
POWER_CLASS = {**DEFAULT_CLASS,
    "name": "Power",
    "track_width": 1.0, "clearance": 0.3,
    "via_diameter": 0.8, "via_drill": 0.4,
    "diff_pair_width": 1.0, "diff_pair_gap": 0.3,
    "priority": 0,                              # lower = checked first
    "pcb_color": "rgb(255, 0, 28)",             # red highlight in editor
}

# Wildcards: * = any chars, ? = one char. Order matters — first match wins.
NETCLASS_PATTERNS = [
    {"pattern": "V+",      "netclass": "Power"},
    {"pattern": "V_FUSED", "netclass": "Power"},
    {"pattern": "*_RAIL",  "netclass": "Power"},   # ARMED_RAIL, FIRING_RAIL
    {"pattern": "GND",     "netclass": "Power"},
]

def _upsert_class(classes, new):
    for i, ex in enumerate(classes):
        if ex.get("name") == new["name"]:
            classes[i] = new
            return "updated" if ex != new else "unchanged"
    classes.append(new)
    return "added"

with open(PRO_FILE, encoding="utf-8") as f:
    pro = json.load(f)

pro.setdefault("net_settings", {})
pro["net_settings"].setdefault("classes", [])
pro["net_settings"].setdefault("meta", {"version": 5})
pro["net_settings"]["netclass_assignments"] = None  # legacy field; leave null

for cls in (DEFAULT_CLASS, POWER_CLASS):
    _upsert_class(pro["net_settings"]["classes"], deepcopy(cls))
pro["net_settings"]["netclass_patterns"] = deepcopy(NETCLASS_PATTERNS)

with open(PRO_FILE, "w", encoding="utf-8", newline="\n") as f:
    json.dump(pro, f, indent=2)
    f.write("\n")
```

Notes:

- **Runs from your project venv**, not KiCad's bundled python. It only
  touches JSON, so no `pcbnew` import is needed — this is one of the
  few headless KiCad scripts that doesn't have to live under
  `C:\Program Files\KiCad\10.0\bin\python.exe`.
- **Format is stable across KiCad 8/9/10.** KiCad writes the file with
  `indent=2` and no trailing-comma quirks; round-tripping through
  `json.load` + `json.dump(..., indent=2)` is byte-stable for the
  fields you don't touch.
- **Wildcards:** `*` and `?` are matched by KiCad against net names
  (not regex). `*_RAIL` matches `ARMED_RAIL` and `FIRING_RAIL` but not
  `GND_RAIL_2` (because the `_2` suffix). Use the most-specific pattern
  you can; first match wins.
- **`netclass_assignments`** is the legacy KiCad 5/6 field where you
  pinned individual nets to a class. KiCad 7+ replaced it with
  `netclass_patterns`. Set the legacy field to `None` to suppress a
  warning from the project loader.
- **Watch out when you rename nets.** A pattern like `NODE_*` stops
  matching after you rename `NODE_A`→`ARMED_RAIL`. The board still
  builds and DRC still passes, but the rails silently fall back to
  `Default` (narrow tracks, narrow clearance). Always re-run
  `01_apply_design_rules.py` after a SKiDL net-name change, and grep
  the project file:

  ```pwsh
  Select-String -Path controller.kicad_pro -Pattern '"pattern"|"netclass"'
  ```

### 8.2. Adding tracks and vias — standard `pcbnew` API

Add a track on a copper layer:

```python
track = pcbnew.PCB_TRACK(board)
track.SetStart(pcbnew.VECTOR2I(pcbnew.FromMM(10.0), pcbnew.FromMM(10.0)))
track.SetEnd(pcbnew.VECTOR2I(pcbnew.FromMM(30.0), pcbnew.FromMM(10.0)))
track.SetWidth(pcbnew.FromMM(1.0))
track.SetLayer(board.GetLayerID("F.Cu"))
net = board.FindNet("V+")
if net:
    track.SetNet(net)
board.Add(track)
```

Add a via:

```python
via = pcbnew.PCB_VIA(board)
via.SetPosition(pcbnew.VECTOR2I(pcbnew.FromMM(20.0), pcbnew.FromMM(10.0)))
via.SetWidth(pcbnew.FromMM(0.8))
via.SetDrill(pcbnew.FromMM(0.4))
via.SetViaType(pcbnew.VIATYPE_THROUGH)
via.SetLayerPair(board.GetLayerID("F.Cu"), board.GetLayerID("B.Cu"))
via.SetNet(net)
board.Add(via)
```

Scripted routing is rarely worth it for hobby boards. For repeated
patterns (LED matrix, mounting hole grid), it's the right hammer.

---

## 9. Action Plugins (Briefly)

A KiCad **Action Plugin** is a `pcbnew` script that registers a button
in the PCB Editor's Tools → External Plugins menu. Use when you want
the GUI workflow to invoke your script without typing.

```python
import pcbnew

class MyPlugin(pcbnew.ActionPlugin):
    def defaults(self):
        self.name = "Round-trip outline + holes"
        self.category = "Layout"
        self.description = "Re-assert board outline and mounting holes from script"
        self.show_toolbar_button = True

    def Run(self):
        # ... call your placement logic on pcbnew.GetBoard() ...
        pass

MyPlugin().register()
```

Install on Windows:

```text
%APPDATA%\kicad\<MAJOR>.<MINOR>\scripting\plugins\<your_plugin>.py
```

(e.g. `C:\Users\<you>\AppData\Roaming\kicad\10.0\scripting\plugins\my_plugin.py`)

KiCad loads everything in that folder at startup. **PCM** (Plugin and
Content Manager) is the official distribution channel for sharing
plugins; it installs to the same folder.

For a project-scoped script (this project), don't bother with the
plugin framework — invoking the script from a PowerShell prompt is
fine and avoids the "did the user reload plugins" question.

---

## 10. `kikit` — High-Level Panelization and Fab Presets

[`kikit`](https://github.com/yaqwsx/KiKit) is a community Python library
that builds on `pcbnew`. It does the things that are tedious to do
with raw `pcbnew`:

- **Panelization** — gang multiple boards onto one panel
- **V-cut and mouse-bite tabs** — for separating boards from the panel
- **Fab presets** — JLCPCB / PCBWay / OSH Park / AISLER one-liner
  exporter that applies vendor-specific Gerber settings
- **Stencils** — generate the paste mask for SMT
- **HTML BOMs** — interactive BOMs for assembly

Install via `pip` into a venv (not KiCad's bundled python):

```pwsh
pip install kikit
```

Then use the CLI:

```pwsh
kikit panelize --layout grid --gridsize 2x2 --tabwidth 3 --tabheight 3 `
  --mousebites 0.5;1;0.25 board.kicad_pcb panel.kicad_pcb

kikit fab pcbway --no-drc board.kicad_pcb pcbway_out
kikit fab jlcpcb --assembly board.kicad_pcb jlcpcb_out
```

`kikit fab` is a more opinionated alternative to the
`kicad-cli pcb export gerbers` + zip flow. It bakes in the per-vendor
quirks (X2 off where needed, BOM template for JLCPCB assembly,
filename conventions) so you don't manage them in your `build_fab.ps1`.

For this project, the hand-written `build_fab.ps1` is fine — it's
explicit about which vendor we target. For a project that frequently
swaps vendors or panelizes, switch to `kikit fab`.

---

## 11. `kiutils` — Pure-Python `.kicad_sch` and `.kicad_pcb` Editor

[`kiutils`](https://github.com/mvnmgrx/kiutils) is the right library
when:

- You don't want to install KiCad (CI, container, headless server)
- You need to edit the **schematic** (which `pcbnew` cannot do)
- You need to bulk-edit fields across many `.kicad_pcb` / `.kicad_sch`
  / `.kicad_sym` files

```pwsh
pip install kiutils
```

```python
from kiutils.schematic import Schematic

sch = Schematic.from_file("controller.kicad_sch")
for sym in sch.schematicSymbols:
    if sym.libId == "Device:R":
        # Bulk update all resistors' tolerance field
        for prop in sym.properties:
            if prop.key == "Tolerance":
                prop.value = "1%"
                break
sch.to_file("controller.kicad_sch")
```

Useful Schematic operations:

| Task | API |
|------|-----|
| Read symbols | `Schematic.schematicSymbols` (list) |
| Read nets | walk wires + labels (no first-class "net" concept) |
| Change reference designators | `symbol.properties[Reference].value` |
| Change values | `symbol.properties[Value].value` |
| Add custom fields | `symbol.properties.append(Property(key=..., value=...))` |
| Change footprint assignment | `symbol.properties[Footprint].value = "Lib:Name"` |

Useful Board operations:

| Task | API |
|------|-----|
| Read footprints | `Board.footprints` |
| Read tracks | `Board.traceItems` |
| Read zones | `Board.zones` |
| Read graphics (Edge.Cuts, silk) | `Board.graphicItems` |
| Edit any of the above | mutate the dataclass and `.to_file()` |

`kiutils` reads the KiCad 6 / 7 / 8 / 9 file formats. KiCad 10 support
may lag — check the project's compatibility matrix on GitHub before
upgrading.

### When `kiutils` beats `pcbnew`

- **Bulk schematic edits** — `pcbnew` can't touch the schematic
- **CI without KiCad** — `pip install kiutils` and you're done; no
  KiCad install needed
- **Cross-platform reproducibility** — no native binding versioning hell
- **Inspection** — easy to print the parsed data structure for debugging

### When `pcbnew` beats `kiutils`

- **Anything that needs the live geometry engine** — DRC, connectivity,
  ratsnest, polygon fill, courtyard collision
- **Library symbol resolution** — `pcbnew.FootprintLoad()` knows about
  KiCad's library search paths; `kiutils` doesn't
- **3D model resolution** — same reason
- **Save fidelity** — `pcbnew` always produces files that KiCad will
  accept; `kiutils` is correct in the common case but version drift
  occasionally produces files that need a manual fix-up

---

## 12. Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Forgetting `pcbnew.FromMM()` | Footprint lands at (0, 0) or way off-board | Wrap every mm value at the API boundary |
| Using a venv Python | `ImportError: No module named pcbnew` | Use KiCad's bundled `python.exe` |
| Running script with wrong working directory | `LoadBoard` can't find the file | Normalise paths from `__file__` |
| Re-running script duplicates Edge.Cuts | Multiple overlapping outlines | Clear before redraw; iterate over a snapshot list |
| Footprint reference collisions | `Add()` accepts but Update PCB later complains | Update-or-insert pattern; never blindly `Add()` if ref exists |
| `SetOrientation()` (no `Degrees`) silently takes tenths of a degree | Footprint rotated 0.9° instead of 90° | Use `SetOrientationDegrees()` |
| **Rotation direction wrong** — placed footprint's connector wires/screws end up facing 90° off from intent (e.g. terminal block wire entry points INTO the board instead of OUT) | KiCad pcbnew is **CW-positive**, not the math/right-hand-rule CCW-positive. After `SetOrientationDegrees(90)`, a feature originally on the +Y face ends up on the +X face. | Use the rotation table in §5 "Rotation convention." For asymmetric footprints (terminal blocks, polarized connectors), always compute the post-rotation pin/body coordinates explicitly with `rotate_cw()`. Verify against the DRC report's actual pad positions before iterating placement scripts. |
| Mutating `board.GetFootprints()` while iterating | Skipped items / crashes | Snapshot to a list first: `for fp in list(board.GetFootprints())` |
| KiCad already has the project open when script saves | Save races with KiCad's autosave; project state corruption | Close pcbnew before running mutation scripts, or use Action Plugin |
| Trying to script the schematic with `pcbnew` | `AttributeError` everywhere | Use `kiutils` for schematic; `pcbnew` is PCB-only |
| Hand-authoring `.kicad_sch` from scratch | Random "no symbol" errors on open | Capture in eeschema once; script subsequent edits with `kiutils` |
| `pcbnew` version mismatch (script written for one major KiCad, run on another) | API drift; `AttributeError` on renamed methods | Pin a KiCad major per project; document in README. Current stable as of May 2026 is **10.0.3**. |
| Forgetting to `BuildConnectivity()` before checking ratsnest | `GetUnconnectedCount` returns stale data | Call `board.BuildConnectivity()` after any layout change |
| **KiCad 10.0.3 — `pcbnew.FootprintLoad()` raises `AttributeError: 'SwigPyObject' object has no attribute 'FootprintLoad'`** | The top-level helper is wired to call `plug.FootprintLoad` where `plug` is a raw `SwigPyObject` | Call the manager directly: `plug = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP); fp = plug.FootprintLoad(lib, name)`. On KiCad 9 the method is `PluginFind` instead of `FindPlugin`. |
| **KiCad 10.0.3 — `FOOTPRINT` returned by `FootprintLoad` is a `SwigPyObject` (no `SetReference` etc.) if any `pcbnew.PCB_SHAPE` was constructed earlier in the same process** | Footprint loads "succeed" but every method call on the result raises `AttributeError` | **Load and place ALL footprints BEFORE constructing any `PCB_SHAPE` (Edge.Cuts segments, silk graphics, etc.).** PCB_SHAPE construction corrupts SWIG's per-class type registry, so later FOOTPRINT returns come back unwrapped. Order: footprints → edges, never edges → footprints. |
| **KiCad 10.0.3 — `pad.SetNet(net)` raises `AttributeError: 'SwigPyObject' object has no attribute 'SetNet'` after `Remove + Add` cycles on footprints** | Two-step pipeline: `FindPadByNumber()` returns a raw `SwigPyObject` after the type registry has been disturbed by `board.Remove(fp); board.Add(new_fp)` swap cycles, even after a `SaveBoard()` + `LoadBoard()` round-trip. | **Iterate `fp.Pads()` instead of `FindPadByNumber()`:** `pad = next((p for p in fp.Pads() if p.GetNumber() == str(pin)), None)`. The Python iterator always yields properly-wrapped PAD objects. A `SaveBoard()` + `LoadBoard()` round-trip between footprint-swap and pad-net-assign stages is also recommended but is not sufficient on its own. |

---

## 13. Project Layout for Python Scripts

Per `electronics-kicad-general` §2 + this skill's convention:

```text
<project>/
  controller.kicad_pro
  controller.kicad_sch
  controller.kicad_pcb
  python/
    01_board_outline_and_holes.py    # idempotent geometry lock-in
    02_place_components.py            # idempotent placement
    03_drc_and_report.py              # quick sanity check
    04_render_ratsnest.py             # KiCad-python: SVG + JSON sidecar
    05_render_ratsnest_png.py         # venv-python: PNG via matplotlib
    (06_*)                            # add more numbered scripts as needed
  build_fab.ps1                       # the fab pipeline (kicad-cli)
  README.md                           # docs the workflow
```

Numbering convention:

| Prefix | Purpose |
|--------|---------|
| `01_` | Lock in geometric constraints (outline, mounting holes) |
| `02_` | Place footprints |
| `03_` | Reports / sanity checks |
| `04_` | Ratsnest fly-line renderer (SVG + JSON sidecar; KiCad-python) |
| `05_` | Ratsnest PNG renderer (consumes JSON sidecar; venv-python + matplotlib) |
| `06_+` | Custom routing macros, panelization, post-processing |

Each script is independent and idempotent. The user runs them in
numeric order after schematic capture; reruns are safe.

---

## 14. CI / Continuous Integration

A KiCad project can run ERC + DRC + Gerber generation in CI with
`kicad-cli`:

```yaml
# .github/workflows/kicad.yml
name: KiCad CI
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    container: kicad/kicad:9.0   # official KiCad container
    steps:
      - uses: actions/checkout@v4
      - run: kicad-cli sch erc --severity-error --exit-code-violations controller.kicad_sch
      - run: kicad-cli pcb drc --severity-error --schematic-parity --exit-code-violations controller.kicad_pcb
      - run: kicad-cli pcb export gerbers --output fab/gerbers controller.kicad_pcb
      - uses: actions/upload-artifact@v4
        with:
          name: gerbers
          path: fab/
```

For PR-time validation that the Python scripts also reproduce the
committed `.kicad_pcb` byte-for-byte (modulo UUIDs), diff the saved
file against a re-run:

```pwsh
git checkout controller.kicad_pcb
& 'C:\Program Files\KiCad\10.0\bin\python.exe' python\01_board_outline_and_holes.py
& 'C:\Program Files\KiCad\10.0\bin\python.exe' python\02_place_components.py
git diff --stat controller.kicad_pcb  # expect: only UUIDs and timestamps
```

---

## Quick Reference — bug → fix

| Symptom | Cause | Fix |
|---------|-------|-----|
| `ImportError: No module named pcbnew` | Wrong Python | Use `C:\Program Files\KiCad\<MAJOR>.<MINOR>\bin\python.exe` |
| `pip install pcbnew` succeeds but `import pcbnew` is the wrong thing | PyPI has an unrelated package with the same name | Uninstall it (`pip uninstall pcbnew`); use bundled python |
| Footprint at (0,0) | Forgot `FromMM()` | Wrap all mm values |
| Footprint rotated 0.9° | Used `SetOrientation(90)` | Use `SetOrientationDegrees(90.0)` |
| Connector wires face the wrong way after rotation | Assumed CCW-positive (math convention) | KiCad pcbnew is CW-positive. See rotation table in §5 |
| Edge.Cuts has 8 segments instead of 4 | Re-ran without clearing | Add `clear_existing_edge_cuts()` step |
| `RuntimeError` on FootprintLoad | Wrong library path | Resolve via `KICAD<N>_FOOTPRINT_DIR` env var |
| **KiCad 10.0.3:** `pcbnew.FootprintLoad` raises `AttributeError: 'SwigPyObject'` | Top-level helper is broken in 10.0.3 | Use `pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP).FootprintLoad(...)` |
| **KiCad 10.0.3:** loaded footprint has no `SetReference` (is `SwigPyObject`) | A `PCB_SHAPE` was constructed earlier in the process; SWIG type registry corrupted | Load + place ALL footprints BEFORE drawing Edge.Cuts (or any other PCB_SHAPE work) |
| **KiCad 10.0.3:** `pad.SetNet()` raises `AttributeError: 'SwigPyObject'` after footprint Remove+Add | `FindPadByNumber()` returns raw SwigPyObject after the type registry is disturbed | Iterate `fp.Pads()` and match by `p.GetNumber() == str(pin)`. Also do a `SaveBoard/LoadBoard` round-trip between footprint swap and pad net assignment. |
| DRC engine errors mid-script | API drift between versions | Use `kicad-cli pcb drc` instead |
| Schematic edits don't show in KiCad | KiCad has the project open | Close eeschema before running the script |
| Can't edit `.kicad_sch` | `pcbnew` is PCB-only | Use `kiutils` |

---

## See Also

- KiCad CLI reference (master): <https://docs.kicad.org/master/en/cli/cli.html>
- KiCad scripting docs: <https://docs.kicad.org/8.0/en/contributing/scripting.html>
- `pcbnew` Python module reference: <https://gitlab.com/kicad/code/kicad/-/blob/master/pcbnew/python/plugins/__init__.py>
- `kikit` — <https://github.com/yaqwsx/KiKit>
- `kiutils` — <https://github.com/mvnmgrx/kiutils>
- `sexpdata` (raw s-expression parser, if you really need it) — <https://github.com/jd-boyd/sexpdata>
- `electronics-kicad-general` — project layout this skill plugs into
- `electronics-kicad-symbols-footprints` — how to source the libraries
  whose footprints these scripts load
- `electronics-kicad-pcb-fab-gerber` — full `kicad-cli` reference for
  the headless Gerber/drill/BOM/STEP pipeline this skill bridges into
