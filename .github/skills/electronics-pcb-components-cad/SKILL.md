---
name: electronics-pcb-components-cad
description: 'Place electronic components (LEDs, resistors, screw terminals, switches, headers, ICs, electrolytic caps, diodes, fuses) on PCB CAD models in build123d using vendor STEP downloads from componentsearchengine.com or simplified parametric fallbacks. USE FOR: import_step into a PCB assembly, normalize vendor STEP origins, place component by board row/column, build a parametric stand-in when no STEP is available, color-tag for assembly renders, collision check against enclosure lid, license/attribution for free CAD model downloads.'
---

# PCB Component CAD Placement Skill (build123d)

> **Prerequisites:** Load `cad-build123d-general` AND
> `electronics-pcb-board-cad` first. This skill consumes the
> `pcb_col_x()` / `pcb_row_y()` helpers and `MOUNTING_HOLES` arrays
> defined there.
>
> **Companion (SVG side):** `electronics-pcb-components` is the SVG version
> of this skill — same parts, different output medium. Components must
> appear in the same row/column on both views; treat the SVG as the human
> connectivity record and the CAD as the geometric record.

## Purpose

Turn a 2D PCB layout into a real 3D assembly by dropping component models
onto the PCB CAD substrate. Two paths, both supported:

1. **Vendor STEP** — download the manufacturer's official 3D model from
   [Component Search Engine](https://componentsearchengine.com/) (or
   SnapEDA, Ultra Librarian, manufacturer site) and `import_step()` it.
2. **Parametric fallback** — when no STEP exists, build a simplified
   stand-in (rectangular body + leads) with build123d primitives.

The result is a single STEP/3MF assembly that:

- Shows what the finished build will look like (renders for the docs page)
- Validates clearance against the enclosure lid before printing
- Catches mechanical conflicts (tall caps under lid ribs, terminal blocks
  hanging over the board edge into the wall)

---

## 1. Component Search Engine — Workflow

[componentsearchengine.com](https://componentsearchengine.com/) is a free
ECAD library hosted by Samacsys / Supplyframe. Most parts have:

- Schematic symbol (SVG / native ECAD)
- PCB footprint
- **3D model in STEP format** ← this is what we want
- Optional native exports for Altium, KiCad, Eagle, etc.

### One-time setup

1. Register a free account at <https://componentsearchengine.com/register>
   (no credit card; required to download).
2. **Optional but recommended:** install the Library Loader desktop app
   only if you also use a supported ECAD tool (Altium, KiCad, etc.). For a
   pure build123d workflow you don't need it — download STEP files
   directly from the part page.

### Per-part workflow

1. Search the part by manufacturer part number (MPN) — e.g. `1N4007`,
   `R1966ABLKBLKGR`. Generic part numbers (`220R`) won't return useful
   3D models.
2. Open the part page.
3. Click **3D Model** → download the STEP file (`.step` or `.stp`).
4. Save to the project under `cad/components/<mpn>.step`. Use the
   manufacturer's MPN exactly as the filename so the source is
   self-documenting.
5. Note the original origin/orientation in `cad/components/README.md`
   (see § 4 below). Vendor STEPs are inconsistent about where pin 1 sits.

### When the part isn't there

- Use the **Self Build Tool** (web-based wizard) — usable but slow.
- Use the **48-hour build request** — Samacsys engineers create the model
  for free; usually under 2 business days.
- Or build a parametric fallback (see § 5) — almost always faster than
  waiting if the part is geometrically simple (resistor, capacitor, LED,
  generic header).

### License & attribution

Component Search Engine models are free for design use. The license
generally permits embedding the geometry into your project's CAD/STEP
exports. **Do not redistribute the bare STEP files** as a standalone
library — link to the part page in `cad/components/README.md` so
downstream users can re-download from source.

---

## 2. Project Layout for Component CAD Files

```
<project>/
  cad/
    components/
      README.md             # source URLs + origin/orientation notes
      1N4007_DO-41.step     # vendor STEPs, named by MPN
      LED_5MM_RED.step
      KF301-02P.step        # 5.08 mm screw terminal
      ...
    parametric/
      led_5mm.py            # parametric fallback: build_led_5mm(color="red")
      resistor_axial.py     # build_resistor(value="220R", body_color="beige")
      ...
  pcb_assembly.py           # imports both vendor + parametric, places on PCB
```

`cad/components/` holds the **immutable downloaded artifacts**.
`cad/parametric/` holds **the code** that builds fallback models. Never
mix the two — vendor STEPs are inputs, parametric models are derived.

---

## 3. Importing a Vendor STEP

build123d exposes `import_step(filename)` which returns a `Compound`
(possibly with multiple sub-shapes if the vendor split the model into
body + leads + plating).

```python
from build123d import import_step, Location, Rotation, Color, Compound
from pathlib import Path

COMPONENT_DIR = Path(__file__).parent / "cad" / "components"

def load(mpn: str) -> Compound:
    """Load a vendor STEP by MPN. Raises FileNotFoundError if missing."""
    path = COMPONENT_DIR / f"{mpn}.step"
    if not path.exists():
        raise FileNotFoundError(f"No STEP for {mpn} in {COMPONENT_DIR}")
    return import_step(str(path))
```

### Always normalize the origin

Vendor STEPs have wildly inconsistent origins:

- Some put the origin at the body centroid (most common)
- Some put it at pin 1 (or pin 1 footprint anchor)
- Some put it at the bottom-center (PCB-side anchor — best for our use)
- A few are positioned in arbitrary world coordinates from the original
  ECAD layout

**Before placing anything**, normalize once into a canonical pose and save
the recipe alongside the STEP. The canonical pose for through-hole
components is:

> Pin 1 at `(0, 0, 0)`, body extends along +Z, secondary pins along +X
> at the documented pitch.

```python
def normalize_through_hole(model: Compound, pin_pitch: float, lead_length: float) -> Compound:
    """Move/rotate a vendor STEP so pin 1 is at origin and leads point -Z.

    Recipe lives in cad/components/README.md per part.
    """
    # Example for a part whose vendor origin is at body centroid
    # with leads along -Y instead of -Z:
    rot = Rotation(X=-90)
    bbox_after_rot = (model.moved(rot)).bounding_box()
    # Translate so pin 1 (assume +X side after rotation) is at origin:
    dx = -bbox_after_rot.min.X
    dy = -(bbox_after_rot.min.Y + bbox_after_rot.max.Y) / 2
    dz = -bbox_after_rot.min.Z
    return model.moved(rot).moved(Location((dx, dy, dz)))
```

The right transforms are part-specific. Document them in
`cad/components/README.md`:

```markdown
## 1N4007_DO-41.step
- Source: https://componentsearchengine.com/part-view/1N4007/onsemi
- Vendor origin: body centroid, axis along Y
- Normalize: Rotation(X=-90), translate so pin 1 (cathode side) lands at (0,0,0)
- Pin pitch: 7.62 mm (axial through-hole)
```

---

## 4. Placement on a PCB Assembly

Once normalized, placement is one helper call per component:

```python
from electronics_pcb_board_cad.perma_proto_full import (
    pcb_col_x, pcb_row_y, pcb_hole, PCB_H,
)

def place(model: Compound, row: str, col: int, *, rotation_z: float = 0.0,
          z_lift: float = 0.0) -> Compound:
    """Place a normalized component model so its pin 1 lands in (row, col).

    rotation_z: degrees around Z, applied BEFORE translation.
    z_lift:     extra Z above PCB top (for parts that sit raised, e.g. on
                a socket).
    """
    x, y, z = pcb_hole(row, col)
    placed = model.moved(Rotation(Z=rotation_z)).moved(Location((x, y, z + z_lift)))
    return placed

# Usage
d1   = place(load("1N4007_DO-41"),  row="A", col=15)
led1 = place(load("LED_5MM_RED"),   row="F", col=21)
t1   = place(load("KF301-02P"),     row="A", col=27, rotation_z=90)
```

### Multi-pin component placement

For two-pin axial parts (resistors, diodes), place by **pin 1** and let
the body span to pin 2 via the part's own geometry. Don't try to compute
a midpoint — the STEP already encodes pin spacing.

For multi-pin terminal blocks and headers, the pin pitch must match the
PCB grid (or a multiple of it). 5.08 mm screw terminals = 2 × 2.54 mm =
two columns; 2.54 mm headers = one column per pin.

---

## 5. Parametric Fallback Library

When no vendor STEP exists or downloading would be overkill, build a
simplified stand-in. The goal is geometry good enough for clearance and
visualization, not photorealism.

### LED, 5 mm through-hole

```python
def build_led_5mm(color: tuple = (0.95, 0.2, 0.2)) -> Compound:
    """5 mm through-hole LED. Pin 1 (anode, longer lead) at origin.
    Cathode lead at (+2.54, 0, 0). Body sits above PCB."""
    LEAD_DIA = 0.5
    LEAD_LEN_ANODE  = 25.0
    LEAD_LEN_CATHODE = 23.0   # cathode is shorter — encodes polarity
    BODY_DIA  = 5.0
    BODY_H    = 8.6           # dome height
    PIN_PITCH = 2.54

    with BuildPart() as led:
        # Anode lead at origin, going down
        with Locations((0, 0, -LEAD_LEN_ANODE / 2)):
            Cylinder(LEAD_DIA / 2, LEAD_LEN_ANODE)
        # Cathode lead 2.54 mm over, slightly shorter
        with Locations((PIN_PITCH, 0, -LEAD_LEN_CATHODE / 2)):
            Cylinder(LEAD_DIA / 2, LEAD_LEN_CATHODE)
        # Body sits centered between the two leads, on top of PCB
        with Locations((PIN_PITCH / 2, 0, BODY_H / 2)):
            Cylinder(BODY_DIA / 2, BODY_H)
        # Top dome
        top = led.faces().sort_by(Axis.Z)[-1]
        with BuildSketch(top):
            Circle(BODY_DIA / 2)
        revolve(axis=Axis.Z, revolution_arc=180)   # rough dome
    led.part.color = Color(*color, 0.85)           # translucent
    return led.part
```

### Axial resistor (1/4 W, through-hole)

```python
def build_resistor_axial(pitch: float = 10.16) -> Compound:
    """Axial resistor at pin 1 origin, body centered between two pins.
    Default pitch = 10.16 mm (4 columns) — typical for 1/4 W."""
    LEAD_DIA = 0.6
    BODY_L = 6.5
    BODY_DIA = 2.5
    BODY_LIFT = 1.0    # body sits ~1 mm above PCB
    LEAD_LEN = 25.0    # uncut leads from body

    body_x = pitch / 2
    with BuildPart() as r:
        # Two leads going down through the PCB
        for x in (0, pitch):
            with Locations((x, 0, -LEAD_LEN / 2)):
                Cylinder(LEAD_DIA / 2, LEAD_LEN)
            # Lead arc up to body height (simplified: short vertical segment)
            with Locations((x, 0, BODY_LIFT / 2)):
                Cylinder(LEAD_DIA / 2, BODY_LIFT)
        # Horizontal body
        with Locations((body_x, 0, BODY_LIFT + BODY_DIA / 2)):
            with Rotation(Y=90):
                Cylinder(BODY_DIA / 2, BODY_L)
    r.part.color = Color(0.85, 0.78, 0.55)   # beige
    return r.part
```

### Other recipes

| Component | Body shape | Notes |
|-----------|-----------|-------|
| Electrolytic cap (radial) | Cylinder, vertical | Mark stripe with thin slot subtraction; pin 1 = +, pin 2 = − |
| 1N400x diode (DO-41) | Cylinder, horizontal | Cathode end gets a thin band (Color override on a sub-region) |
| 0.1" pin header (1×N) | Box body + N square pins | Body height 2.5 mm, pin length 11.5 mm |
| Screw terminal (KF301-02P, 5.08 mm) | Box body + screw cylinders | Body 9 × 7.5 × 10 mm; two M3 screws |
| Tactile pushbutton | Box base + cylindrical actuator | 6 × 6 × 5 mm body, 3.5 mm tall actuator |
| TO-220 transistor | Box body + tab | Tab 13 × 4.5 × 1.3 mm; body 9.5 × 9.5 × 4.5 mm; 3 leads at 2.54 mm pitch |

Build these on demand — don't pre-build a giant library. Each project
typically needs 3-6 distinct part types.

---

## 6. Color Tagging for Renders

Vendor STEPs come without colors (or with arbitrary ECAD colors). Tag
every placed component for a consistent rendered look:

```python
COMPONENT_COLORS = {
    "led_red":      Color(0.95, 0.2, 0.2, 0.85),
    "led_green":    Color(0.2, 0.85, 0.3, 0.85),
    "resistor":     Color(0.85, 0.78, 0.55),
    "cap_electro":  Color(0.15, 0.15, 0.15),
    "diode":        Color(0.10, 0.10, 0.10),
    "terminal":     Color(0.20, 0.65, 0.30),
    "header":       Color(0.10, 0.10, 0.10),
    "ic_plastic":   Color(0.08, 0.08, 0.08),
    "pcb_substrate":Color(0.07, 0.30, 0.45),
    "copper":       Color(0.85, 0.55, 0.13),
}
```

Apply via `placed.color = COMPONENT_COLORS["led_red"]` after each
`place(...)` call. These colors carry through STEP and 3MF exports and
match the SVG color conventions in `electronics-pcb-components`.

---

## 7. Collision / Clearance Checks

The whole reason to build a CAD assembly: catch fit problems before
printing. Two cheap checks once the PCB and components are placed:

### Tallest-component-vs-lid

```python
assembly_top_z = max(c.bounding_box().max.Z for c in [pcb] + components)
clearance = LID_INTERIOR_Z - assembly_top_z
print(f"Tallest point: {assembly_top_z:.2f} mm  Clearance to lid: {clearance:.2f} mm")
if clearance < 1.0:
    print("  ⚠ Less than 1 mm clearance — risk of contact")
```

### Footprint vs PCB outline

```python
for c, name in zip(components, names):
    bb = c.bounding_box()
    if bb.min.X < 0 or bb.max.X > PCB_L or bb.min.Y < 0 or bb.max.Y > PCB_W:
        print(f"  ⚠ {name} extends past PCB outline")
```

These run in <1 s even with 30 components and prevent expensive failed
prints.

---

## 8. Synchronizing CAD ↔ SVG ↔ Schematic

Same drift rule as enclosures and the PCB SVG:

> **The PCB is the build-truth.** When the SVG, CAD assembly, schematic,
> and Falstad simulation disagree, update everything else to match the
> PCB.

When swapping a component (e.g. 220 Ω → 470 Ω resistor), update:

1. PCB SVG (`<board>_pcb.html`) — value text on the component
2. PCB CAD — usually no geometry change; just update the BOM / color
3. Schematic SVG (`<board>_circuit.html`) — symbol value
4. Falstad `CIRCUIT` constant — the `r` line resistance value
5. Parts list (`resources/parts_list.html`)
6. `cad/components/README.md` — if the part itself changed (different MPN)

A useful sweep: `grep -r "220R\|220 ohm\|220Ω"` over the project folder.

---

## 9. Quick Reference: Common Mistakes

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Imported STEP is rotated 90° from expected | Vendor's "up" axis is +Y, not +Z | Add `Rotation(X=-90)` in the normalizer; record in `cad/components/README.md` |
| Component lands offset from row/col | Forgot to normalize pin 1 to origin | Re-run normalizer with correct translation |
| Two-pin component oriented along Y instead of X | `rotation_z=90` forgotten or applied twice | Set `rotation_z=0` for X-axis (cols), `90` for Y-axis (rows) |
| Components float above the PCB | Used `pcb_hole(...)` which returns Z = `PCB_H` (top face), then component already has its own +Z body | Correct — leads should still descend through PCB. If body floats, the STEP's pin 1 wasn't on its lead bottom |
| Lid hits a tall capacitor in the slicer | No clearance check run before printing | Add the bounding-box check; raise `LID_INTERIOR_Z` or shorten the cap leads |
| Vendor STEP file is huge (10+ MB) | Manufacturer included high-detail internals (silicon die, solder bumps) | Open in a viewer, accept; consider not including vendor STEPs in `production` exports |
| Parametric LED color doesn't render in 3MF viewer | Color set on `BuildPart` but not on the final `Compound` returned | Set `part.color = ...` on the value being returned, not on intermediate builders |
| `import_step` returns nothing visible | STEP file uses millimeters but viewer assumed meters | This is an OCCT default in some configs; confirm units in the STEP header (`SI_UNIT(.MILLI.,.METRE.)`) |

---

## See Also

- `electronics-pcb-board-cad` — substrate model, mounting holes, helpers
- `electronics-pcb-components` — SVG side (matching parts on the docs page)
- `electronics-enclosure-3dprint` — using the assembled PCB for fit checks
- `cad-build123d-general` — Compound moves, Location, Rotation, color tagging
- `cad-build123d-bd-warehouse` — bd_warehouse fasteners, bearings, gears, threads (use for stand-offs, M3 mounting screws, headers built from primitives)
- `cad-partcad-repository` — community CAD parts catalog (broader than bd_warehouse)
- `cad-render-images` — render the populated PCB assembly to PNG/GIF for documentation pages
- Component Search Engine: <https://componentsearchengine.com/>
- SnapEDA (alternative source): <https://www.snapeda.com/>
- Ultra Librarian (alternative source): <https://www.ultralibrarian.com/>
- build123d STEP I/O: <https://build123d.readthedocs.io/en/latest/import_export.html>
