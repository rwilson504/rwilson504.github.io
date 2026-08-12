---
name: electronics-pcb-board-cad
description: 'Generate parametric build123d (Python) CAD models of hobbyist PCBs/breadboards as STEP/STL/3MF for use in 3D assemblies, enclosure design, and documentation renders. USE FOR: PCB substrate model, mounting hole drilling, plated-through-hole grid, copper rail visualization, board outline for enclosure cutouts, exporting STEP for downstream CAD, building a 3D mock of a Perma-Proto / ElectroCookie / custom PCB, integrating PCB into a build123d assembly, world-coordinate hole helpers (pcb_to_world).'
---

# PCB Board CAD Modeling Skill (build123d)

> **Prerequisite:** Load `cad-build123d-general` first — this skill assumes
> the BuildPart/BuildSketch/extrude idioms, face-selection hazards, and
> `Plane.XY.offset(z)` patterns documented there.
>
> **Source of truth for dimensions:** `electronics-pcb-boards` (SVG skill).
> Board outlines, mounting hole positions, grid pitch, and rail layout in
> THIS skill must match the SVG skill exactly. When a board spec changes,
> update the SVG skill first, then propagate the values here.

## Purpose

Generate parametric 3D CAD models of common hobbyist PCBs and breadboards
using build123d. Outputs are STEP (preferred for downstream CAD reuse),
STL/3MF (for visualization and 3D-printable mockups), and optional GLB for
web-based previews.

**What this enables:**

- **Enclosure fit checks** — drop the PCB model into the enclosure
  `BuildPart` to verify standoff alignment, panel cutout positions, and
  internal clearance before printing.
- **Assembly mockups** — combine PCB + components + enclosure into a single
  STEP and render a 3D preview for the documentation site.
- **Manufacturing-as-code** — replace hand-traced SVGs with a single
  parametric source that exports both an SVG (for the docs page) and a
  3D STEP (for the assembly).
- **Imported models for ECAD-adjacent workflows** — STEP exports drop into
  KiCad/Altium/Fusion 360 for users who want to mix the hobby PCB with a
  custom-fab board.

**What this does NOT replace:**

- The SVG board renderers in `electronics-pcb-boards` — those are the
  authoritative interactive view on the documentation site. The CAD model
  is for 3D contexts (assembly, render, fit check).
- A real ECAD tool — copper traces here are visual approximations, not
  manufacturing-quality artwork.

---

## 1. When to Reach for the CAD Model vs. the SVG

| Goal | Use |
|------|-----|
| Interactive HTML page showing the board layout | SVG (`electronics-pcb-boards`) |
| Click-to-highlight component placements on the docs page | SVG |
| Verify standoffs in `*_enclosure.py` line up with PCB mounting holes | CAD |
| Render a 3D preview image for the docs site | CAD (export PNG via ocp-vscode / YACV) |
| Hand the user a STEP they can drop into KiCad / Fusion | CAD |
| Calculate clearance between a tall component and the lid ceiling | CAD |
| Quick visual inventory of where headers/blocks land | SVG |

When both are needed, the **SVG remains the authoritative connectivity
view**; the CAD model is the geometry view. Connectivity changes happen in
SVG first, then sync to CAD.

---

## 2. Coordinate Convention

The CAD model uses the **same in-plane coordinate convention** as the SVG
boards skill, plus a Z axis for thickness:

| Axis | Origin | Direction |
|------|--------|-----------|
| X | Bottom-left corner | Along the long edge (left → right) |
| Y | Bottom-left corner | Along the short edge (bottom → top) |
| Z | PCB bottom face | Up (board top face = +PCB_THICKNESS) |

So `(0, 0, 0)` is the bottom-left corner of the PCB's bottom face. This
matches the `mounting_holes` arrays in `electronics-pcb-boards`.

### Two coordinate spaces, one helper

When the PCB is later positioned inside an enclosure (which is typically
modeled with origin at the enclosure floor center), the placement is a
single translation. Provide a helper at the top of every PCB-bearing script:

```python
def pcb_to_world(col_or_x, row_or_y_or_letter, z=0.0):
    """Map PCB-local (col, row) or (x_mm, y_mm) to world coordinates
    after the PCB has been positioned in the assembly.

    PCB local origin = bottom-left corner of the PCB.
    World origin     = whatever the parent assembly chose (often enclosure
                       floor center).
    """
    x = pcb_x(col_or_x) if isinstance(col_or_x, int) else col_or_x
    y = pcb_y(row_or_y_or_letter) if isinstance(row_or_y_or_letter, str) else row_or_y_or_letter
    return (PCB_OFFSET_X + x, PCB_OFFSET_Y + y, PCB_OFFSET_Z + z)
```

`PCB_OFFSET_*` mirrors the same constants the enclosure script uses to
position the PCB. **Define them once at the top of the assembly script
and import / reuse — never duplicate.**

---

## 3. The Parametric PCB Pattern

Every board model follows the same skeleton: substrate → drill mounting
holes → drill (or visualize) the through-hole grid → optional copper rail
overlay → optional silkscreen text. Apply these in 2D where possible.

```python
from build123d import *

# --- Spec (mirror electronics-pcb-boards values) ---
PCB_L = 158.0          # long edge (X)
PCB_W = 51.0           # short edge (Y)
PCB_H = 1.6            # standard FR-4 thickness
HOLE_PITCH = 2.54
GRID_HOLE_DIA = 1.0    # plated through-hole drill
MOUNTING_HOLES = [
    {"pos": (12,  25.5), "dia": 3.2},
    {"pos": (79,  25.5), "dia": 3.2},
    {"pos": (146, 25.5), "dia": 3.2},
]

# --- Build the substrate as a 2D sketch then extrude ---
with BuildPart() as pcb:
    with BuildSketch() as outline:
        Rectangle(PCB_L, PCB_W, align=(Align.MIN, Align.MIN))   # origin = bottom-left
        # Mounting holes (cut in 2D so we don't deal with 3D edges later)
        for h in MOUNTING_HOLES:
            with Locations(h["pos"]):
                Circle(h["dia"] / 2, mode=Mode.SUBTRACT)
    extrude(amount=PCB_H)

# Export
exporter = Mesher()
exporter.add_shape(pcb.part)
exporter.write("perma_proto_full.3mf")
export_step(pcb.part, "perma_proto_full.step")
```

Two non-obvious choices:

1. **`align=(Align.MIN, Align.MIN)`** puts the rectangle's corner at the
   sketch origin so PCB-local coordinates map directly to world X/Y.
   Without this, the rectangle is centered on the origin and every hole
   coordinate has to be shifted by `(-PCB_L/2, -PCB_W/2)`.
2. **Cut holes in 2D, before extruding.** Cylinders subtracted in 3D after
   extrusion work, but they double the topology and slow down later boolean
   operations against the enclosure.

---

## 4. Through-Hole Grid

The through-hole grid is the most expensive part of the model — 600 holes
on a full-sized Perma-Proto. Three options, pick by use case:

| Option | Geometry | Use when |
|--------|----------|----------|
| **Skip** (default) | No holes drilled | Visualization only; you only need the outline + mounting holes |
| **Engrave** (cheap) | Shallow blind hole, ~0.3 mm deep | Render needs to *show* hole locations but you'll never CSG against them |
| **Drill through** (expensive) | Full through-hole, `dia = GRID_HOLE_DIA` | You need to use the holes for collision checks or pin alignment |

```python
def add_grid_holes(builder, board_x0, board_y0, cols, rows_letters, mode=Mode.SUBTRACT, depth=None):
    with BuildSketch(Plane.XY) as grid:
        for c in range(1, cols + 1):
            for r in rows_letters:
                with Locations((pcb_col_x(c), pcb_row_y(r))):
                    Circle(GRID_HOLE_DIA / 2)
    if depth is None:
        depth = PCB_H + 0.1   # punch through with margin
    extrude(amount=depth, mode=mode)
```

Run the grid build inside an `if NEED_GRID:` guard so production exports can
turn it off when only the outline matters.

---

## 5. Copper Rails & Visual Trace Layer (Optional)

Real copper is a thin painted layer (~0.035 mm). For visualization, model it
as a **subtle color-tagged sketch extruded 0.05 mm above the board**:

```python
COPPER_T = 0.05
COPPER = Color(0.85, 0.55, 0.13)   # #B8860B-ish

with BuildPart() as copper:
    with BuildSketch(Plane.XY.offset(PCB_H)):
        # Rails — pad strips along the long edges
        with Locations((PCB_L / 2, RAIL_PLUS_Y)):
            Rectangle(PCB_L - 2 * PCB_EDGE_PAD, RAIL_W)
        with Locations((PCB_L / 2, RAIL_MINUS_Y)):
            Rectangle(PCB_L - 2 * PCB_EDGE_PAD, RAIL_W)
        # ... column buses, etc.
    extrude(amount=COPPER_T)
copper.part.color = COPPER
```

Keep copper as a **separate `BuildPart`** so you can:

- Toggle it off in production exports (smaller files, faster slicer load)
- Color it independently of the substrate
- Reuse the same sketch geometry for matching SVG generation

---

## 6. Board Specs (mirror `electronics-pcb-boards`)

These values must stay in sync with the SVG skill. When updating, change
the SVG first, then update here.

### Adafruit Perma-Proto Full-Sized (#1606)
```python
PCB_L, PCB_W, PCB_H = 158.0, 51.0, 1.6
GRID_COLS = 60
GRID_ROWS = list("ABCDEFGHIJ")
GRID_PITCH = 2.54
CENTER_GAP = 1.27         # extra gap between row E and row F
PCB_EDGE_PAD = 2.0        # board edge → nearest hole
MOUNTING_HOLES = [
    {"pos": (12,  25.5), "dia": 3.2},
    {"pos": (79,  25.5), "dia": 3.2},
    {"pos": (146, 25.5), "dia": 3.2},
]
```

### Adafruit Perma-Proto Half-Sized (#1609)
```python
PCB_L, PCB_W, PCB_H = 82.0, 51.0, 1.6
GRID_COLS = 30
# Power rails may have a center break — model as two strip pairs
```

### ElectroCookie 1/4
```python
PCB_L, PCB_W, PCB_H = 50.8, 38.1, 1.6   # note: long edge is X = 50.8 mm here
GRID_COLS = list("ABCDEFGHIJ")          # 10 columns by letter
GRID_ROWS = 17                           # 17 numbered rows
MOUNTING_HOLES = [
    {"pos": (3.15, 3.05),  "dia": 2.2},
    {"pos": (47.65, 3.05), "dia": 2.2},
    {"pos": (3.15, 35.05), "dia": 2.2},
    {"pos": (47.65, 35.05),"dia": 2.2},
    {"pos": (5.1, 19.05),  "dia": 3.2},
    {"pos": (45.7, 19.05), "dia": 3.2},
]
```

### ElectroCookie Full
```python
PCB_L, PCB_W, PCB_H = 88.9, 52.1, 1.6
GRID_COLS = list("ABCDEFGHIJ")
GRID_ROWS = 30
MOUNTING_HOLES = [
    {"pos": (3.0, 6.0),   "dia": 2.2},
    {"pos": (82.0, 6.0),  "dia": 2.2},
    {"pos": (3.0, 43.0),  "dia": 2.2},
    {"pos": (82.0, 43.0), "dia": 2.2},
    {"pos": (6.0, 24.0),  "dia": 3.2},
    {"pos": (80.0, 24.0), "dia": 3.2},
]
```

---

## 7. Helper Functions

Every PCB script defines these so component placement reads naturally:

```python
ROW_INDEX = {ltr: i for i, ltr in enumerate("ABCDEFGHIJ")}

def pcb_col_x(col):
    """Column number → X (mm from left edge)."""
    return PCB_EDGE_PAD + (col - 1) * GRID_PITCH

def pcb_row_y(letter):
    """Row letter → Y (mm from bottom edge), accounting for center gap."""
    i = ROW_INDEX[letter]
    extra_gap = CENTER_GAP if i >= 5 else 0
    return PCB_EDGE_PAD + i * GRID_PITCH + extra_gap

def pcb_hole(letter, col):
    """Convenience: full (x, y, z=top) for a signal grid hole."""
    return (pcb_col_x(col), pcb_row_y(letter), PCB_H)
```

Components consume these via `electronics-pcb-components-cad` —
**do not duplicate the helpers in the components skill.**

---

## 8. Export Workflow

Same export-mode pattern as enclosures (see `cad-build123d-general` and
the rocket controller's enclosure scripts):

```python
EXPORT_MODE = "design"   # "design" | "test" | "production"

if EXPORT_MODE == "design":
    NEED_GRID = True
    NEED_COPPER = True
    NEED_SILKSCREEN = True
elif EXPORT_MODE == "test":
    NEED_GRID = True
    NEED_COPPER = False
    NEED_SILKSCREEN = False
else:  # production
    NEED_GRID = False
    NEED_COPPER = False
    NEED_SILKSCREEN = False

# Always export both formats
export_step(pcb.part, f"{NAME}.step")
exporter = Mesher()
exporter.add_shape(pcb.part)
if NEED_COPPER:
    exporter.add_shape(copper.part)
exporter.write(f"{NAME}.3mf")
```

`.step` is the universal interchange format and what the user wants for
KiCad / Fusion / Onshape. `.3mf` is what 3D viewers and slicers prefer.
STL is acceptable but loses color information.

---

## 9. Snap into an Enclosure Assembly

The whole point of having the CAD model is to verify the enclosure. Inside
`*_enclosure.py`:

```python
from perma_proto_full import build_pcb, MOUNTING_HOLES, PCB_L, PCB_W, PCB_H

# Place PCB in enclosure space (enclosure origin = floor center)
PCB_OFFSET_X = -PCB_L / 2
PCB_OFFSET_Y = -PCB_W / 2
PCB_OFFSET_Z = STANDOFF_H

pcb_solid = build_pcb().moved(Location((PCB_OFFSET_X, PCB_OFFSET_Y, PCB_OFFSET_Z)))

# Verify each standoff lines up with a mounting hole
for h in MOUNTING_HOLES:
    standoff_x = PCB_OFFSET_X + h["pos"][0]
    standoff_y = PCB_OFFSET_Y + h["pos"][1]
    # ... build standoff at (standoff_x, standoff_y) ...

# Optional: include the PCB in a "design" export to visualize fit
if EXPORT_MODE == "design":
    exporter.add_shape(pcb_solid)
```

This eliminates the entire class of bugs where a standoff was 1 mm off
because somebody manually copied a hole coordinate.

---

## 10. Quick Reference: Common Mistakes

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Mounting holes don't align with standoffs | Copy-pasted coords from SVG that uses pixel units, not mm | Pull `MOUNTING_HOLES` from `electronics-pcb-boards` |
| PCB origin in wrong corner | Forgot `align=(Align.MIN, Align.MIN)` on the outline rectangle | Add the alignment, or shift all hole coordinates |
| 600 grid holes blow up render time | Drilling all through-holes when you don't need them | Set `NEED_GRID = False` for production export |
| Copper layer shows through enclosure walls in render | Copper extruded too tall, intersecting the lid | Keep `COPPER_T <= 0.05`; ensure lid ceiling clears `PCB_OFFSET_Z + PCB_H + COPPER_T + tallest_component` |
| Y-flipped components when sketching on PCB top face | Sketched on a face whose normal is +Z (correct) but reused a -Z lid pattern | Use `Plane.XY.offset(PCB_H)` for the top-face workplane (cleaner than face selection) |
| `import_step` of own export looks chunky/faceted | Confusing STEP (BREP, smooth) with the 3MF mesh re-import | STEP is correct; 3MF is meshed by definition |

---

## See Also

- `electronics-pcb-boards` — SVG renders + authoritative dimensions
- `electronics-pcb-components-cad` — placing component models on the PCB
- `electronics-enclosure-3dprint` — using the PCB model to verify standoffs
- `cad-build123d-general` — extrude direction, face selection, sketch frame gotchas
- `cad-build123d-tools` — ocp-vscode, YACV (3D viewers for the exported model)
- `cad-render-images` — generate PNG/GIF/MP4 renders of the assembled PCB for documentation pages
- build123d Mesher / `export_step` docs: <https://build123d.readthedocs.io/>
