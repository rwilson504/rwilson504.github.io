---
name: electronics-enclosure-3dprint
description: 'Generate parametric 3D-printable project enclosures using Build123d Python. USE FOR: project boxes, PCB standoffs, panel cutouts for switches/LEDs/buttons, cable gland holes, snap-fit lids, debossed labels, axis wall labels, STL export, 3D printing guidelines.'
---

# 3D Printed Electronics Enclosure Skill (Build123d)

## Purpose
Generate parametric 3D-printable project enclosures for electronics projects using Build123d (Python). Enclosures are designed as two-piece snap-fit or screw-together boxes with cutouts for switches, buttons, LEDs, cable glands, and PCB mounting standoffs.

## Enclosure Anatomy — Plain Language Guide

Think of the enclosure as a shoebox: a **base** (the box) and a **lid** (the cover).
They fit together with a stepped edge, like a picture frame rabbet. This section
names every surface so we can talk about them without CAD jargon.

### The Base (looking down into the open box)

```
   ┌─────────── rim ───────────┐
   │  ┌─ lip (raised step) ─┐  │
   │  │                      │  │
   │  │    ╔════════════╗    │  │  ← walls
   │  │    ║   floor    ║    │  │
   │  │    ║ (inside)   ║    │  │
   │  │    ╚════════════╝    │  │
   │  └──────────────────────┘  │
   └────────────────────────────┘
```

| Term | What it is | In code |
|------|-----------|---------|
| **Floor** | The flat interior bottom surface. Standoffs, ridges, and ramps sit on this. | `inner_floor` (sort_by Z index [1] after shelling) |
| **Walls** | The four sides of the box. Holes for cables, ports, and switches go here. | Side faces sorted by X or Y |
| **Rim** | The top edge of the walls — the "frame" that the lid sits on. | `rim_top` (sort_by Z [-1] after shelling) |
| **Lip** | A raised step around the inside of the rim. Slots into the lid's groove to keep it aligned. | Built on `rim_top`, height = `LIP` |

### The Lid (looking at the inside / underside)

```
   ┌────────────────────────────┐
   │  ┌── groove (recessed) ──┐ │
   │  │                        │ │
   │  │   ╔══ ceiling ══╗     │ │  ← this is where
   │  │   ║  (raised    ║     │ │    features hang from
   │  │   ║   surface)  ║     │ │
   │  │   ╚═════════════╝     │ │
   │  └────────────────────────┘ │
   └────────────────────────────┘
         outer face (top, visible when closed)
```

| Term | What it is | In code |
|------|-----------|---------|
| **Outer face** | The visible top surface when the box is closed. Labels and text go here. | `lid_top` (sort_by Z [-1]) |
| **Ceiling** | The flat interior surface that features hang from — ridges, retaining walls, bosses. This is the **raised** center area, NOT the groove. | Z = `BASE_H + 5 - LID_H/2 + LIP` |
| **Groove** | The recessed channel around the perimeter where the base's lip slots in. Its bottom is lower than the ceiling by `LIP` mm. | Z = `BASE_H + 5 - LID_H/2` (raw lid bottom) |
| **Screw holes** | Through-holes that align with screw bosses in the base corners. | Cut from `lid_top` |

### The Critical Rule: Ceiling ≠ Groove

**Features that hang from the lid (ridges, retaining walls, anti-rotation bars)
must attach at the ceiling height, not the groove height.** The groove is `LIP` mm
(typically 1.5mm) lower. If you sketch at the groove height, the feature will
float below the lid with a visible gap.

```
Ceiling Z  = BASE_H + 5 - LID_H/2 + LIP    ← features attach here
Groove Z   = BASE_H + 5 - LID_H/2           ← this is lower, only for the lip fit
```

When using `Plane.XY.offset()` for lid interior features, always use the
**ceiling Z**, not the raw lid bottom Z.

## Prerequisites
```bash
pip install build123d
# Optional: VS Code OCP CAD Viewer for live preview
pip install ocp-vscode
```

## Build123d Quick Reference

### Builder Mode (recommended for enclosures)
```python
from build123d import *

with BuildPart() as part:
    Box(length, width, height)                    # Create box
    fillet(part.edges().filter_by(Axis.Z), 3)     # Round vertical edges
    topf = part.faces().sort_by(Axis.Z)[-1]       # Select top face
    offset(amount=-wall, openings=topf)            # Shell (hollow out from top)
    with Locations(topf):                          # Place on top face
        with Locations((x, y)):                    # At specific position
            Hole(radius)                           # Cut through-hole
    
export_stl(part.part, "enclosure.stl")
export_step(part.part, "enclosure.step")
```

### Key Operations for Enclosures
| Operation | Build123d | Purpose |
|-----------|-----------|---------|
| Create box | `Box(L, W, H)` | Base enclosure shape |
| Round edges | `fillet(edges, radius)` | Smooth vertical corners |
| Chamfer edges | `chamfer(edges, length)` | Bevel edges |
| Hollow out | `offset(amount=-wall, openings=face)` | Create shell with opening |
| Round hole | `Hole(radius)` or `Cylinder(r, h, mode=Mode.SUBTRACT)` | Switch/LED/cable holes |
| Square cutout | `Box(w, h, d, mode=Mode.SUBTRACT)` | Rectangular openings |
| Standoff post | `Cylinder(r_outer, height)` then `Hole(r_screw)` | PCB mounting posts |
| Emboss text | `Text("label", font_size=sz)` + `extrude(amount)` | Labels on enclosure |
| Deboss text | `Text("label", font_size=sz)` + `extrude(-depth, mode=Mode.SUBTRACT)` | Recessed labels |

### Selecting Faces
```python
# By axis direction (most common for enclosures)
top_face    = part.faces().sort_by(Axis.Z)[-1]   # highest Z = top/lid
bottom_face = part.faces().sort_by(Axis.Z)[0]    # lowest Z = bottom
front_face  = part.faces().sort_by(Axis.Y)[-1]   # +Y = front
back_face   = part.faces().sort_by(Axis.Y)[0]    # -Y = back
left_face   = part.faces().sort_by(Axis.X)[0]    # -X = left
right_face  = part.faces().sort_by(Axis.X)[-1]   # +X = right
```

### CRITICAL: Face Selection After Shelling (offset)
After `offset(amount=-WALL, openings=top_face)`, `sort_by(Axis.Z)` returns **two** bottom faces:
- `[0]` = **outer bottom** (normal points -Z, outward) — DO NOT use for standoffs
- `[1]` = **inner floor** (normal points +Z, into the cavity) — USE THIS for standoffs

```python
# WRONG — standoffs will extrude outside the box!
inner_floor = base.faces().sort_by(Axis.Z)[0]

# CORRECT — inner floor after shelling
inner_floor = base.faces().sort_by(Axis.Z)[1]
```

### CRITICAL: Select Key Faces BEFORE Adding Internal Features

`sort_by(Axis.Z)[-1]` returns the face with the highest Z coordinate. After
shelling, this is the **wall rim** (the frame-shaped top of the walls). But if
you add internal features that reach the same Z height (e.g. a divider wall
that extends to `BASE_H - WALL`), their top faces compete with the wall rim
in the sort, and `[-1]` may pick the wrong face.

**Rule: Select `inner_floor` and `rim_top` immediately after shelling and
wall cutouts, BEFORE adding any internal features (standoffs, dividers, ridges).**

```python
# Shell — open top
top_face = base.faces().sort_by(Axis.Z)[-1]
offset(amount=-WALL, openings=top_face)

# ── Cut wall holes (cable gland, window, USB, etc.) ──
# ... wall cutouts here ...

# ── Select key faces NOW, before adding internal geometry ──
# IMPORTANT: Do this BEFORE standoffs, dividers, ridges, or any feature
# whose top face might sit at the same Z as the wall rim.
inner_floor = base.faces().sort_by(Axis.Z)[1]
rim_top = base.faces().sort_by(Axis.Z)[-1]

# ── Now safe to add internal features ──
# Standoffs, dividers, ridges, etc. can create new faces at rim Z level
# but rim_top already points to the correct wall rim face.
```

**What goes wrong without this:**
- A divider wall built to `BASE_H - WALL` (same Z as wall top) adds a new
  top face at the same Z level
- `sort_by(Axis.Z)[-1]` after the divider may return the divider's top face
  instead of the wall rim
- The alignment lip sketch gets drawn on the divider face, placing it at the
  wrong X/Y position (flush with the wrong wall or floating in air)

**Face selection order in the base BuildPart:**
1. Shell the box
2. Cut wall holes (cable gland, windows, ports)
3. **Select `inner_floor` and `rim_top`** ← do this here
4. Build standoffs on `inner_floor`
5. Build ridges, dividers, ramps
6. Build axis labels (in test mode)
7. Build lip on `rim_top`
8. Build screw bosses on `inner_floor`

### CRITICAL: Extrude Direction Depends on Face Normal
Face normals determine which direction positive/negative `amount` goes:
- **Top face** (normal +Z): `amount=X` goes up, `amount=-X` goes into body
- **Bottom face** (normal -Z): `amount=X` goes down (outward!), `amount=-X` goes up into body
- **Side faces**: same principle — positive follows normal direction

```python
# Deboss on top face — negative amount cuts INTO the lid
extrude(amount=-0.5, mode=Mode.SUBTRACT)  # CORRECT

# Recess on bottom face — negative amount cuts UP into the body
extrude(amount=-LIP, mode=Mode.SUBTRACT)  # CORRECT
extrude(amount=LIP, mode=Mode.SUBTRACT)   # WRONG — cuts downward into empty air
```

**⚠ Lid underside protrusions — the most common direction mistake:**
When adding ridges/bosses to the underside of a lid, the extrude direction is
counterintuitive. `lid_bottom = lid.faces().sort_by(Axis.Z)[0]` has its normal
pointing **down** (-Z). So:
- `extrude(amount=RIDGE_H)` → follows normal → **downward into compartment** ✓
- `extrude(amount=-RIDGE_H)` → against normal → **upward into lid body** ✗ (absorbed into existing material, ridge is invisible or much shorter than expected)

If a lid protrusion appears smaller than specified in a test print, the extrude
direction is almost certainly wrong.

### CRITICAL: Stale Face References After Geometry Changes

**After extruding a protrusion from a face, `faces().sort_by(Axis.Z)[0]` (or `[-1]`)
may now select the tip of that protrusion instead of the original surface.**

For example, after adding 14mm LED baffles from the lid ceiling:
- `lid.faces().sort_by(Axis.Z)[0]` now returns the bottom of the baffles (14mm below lid)
- Any subsequent feature sketched on that face will float 14mm below the lid surface

### DEFAULT RULE: ALWAYS use `Plane.XY.offset(CEILING_Z)` for lid interior features

**Never use `lid.faces().sort_by(Axis.Z)[0]` for ANY feature on the lid underside.**
Use `Plane.XY.offset(CEILING_Z)` for every ridge, baffle, boss, or retaining wall
that hangs from the lid — even if it's currently the first/only feature on that face.

A face selector that works today becomes stale when a future edit inserts a new
feature above it in the code. `Plane.XY.offset()` is immune to this.

```python
# ALWAYS — for every lid interior feature:
CEILING_Z = BASE_H + 5 - LID_H / 2 + LIP  # ceiling, not groove
with BuildSketch(Plane.XY.offset(CEILING_Z)):
    with Locations((x, y)):  # no Y negate needed — Plane.XY normal is +Z
        Rectangle(length, width)
extrude(amount=-RIDGE_H)  # negative = downward from +Z normal

# NEVER — even if it seems safe right now:
lid_bottom = lid.faces().sort_by(Axis.Z)[0]
with BuildSketch(lid_bottom):
    ...
extrude(amount=RIDGE_H)
```

### AUDIT RULE: When inserting a new feature, check downstream face selectors

**When you insert a new protrusion into a BuildPart, search the rest of that
BuildPart for `faces().sort_by()` calls on the same axis.** Any downstream
selector that picks the same face your new feature extends from is now stale
and must be converted to `Plane.XY.offset()`.

**Checklist when adding a protrusion to any part:**
1. Write the new feature using `Plane.XY.offset()` (not face selection)
2. Search the remaining code in the same `BuildPart` for `faces().sort_by(Axis.Z)` (or whichever axis)
3. For each match: could your new feature now be the extremum? If yes → convert to `Plane.XY.offset(known_z)`
4. Run the script and visually verify all features are attached

**When is face selection still acceptable?**
- `inner_floor` in the base — selected once, immediately after shelling, before any features
- `rim_top` in the base — same, selected before standoffs/dividers (per face selection order rule)
- Side walls — only if no protrusions have been added to that wall
- `lid_top` (outer face) — for text deboss only, where no protrusions exist on the outside

### CRITICAL: Y-Axis Flip on Bottom Faces

When sketching on `lid_bottom = lid.faces().sort_by(Axis.Z)[0]` (normal -Z),
Build123d flips the Y axis in sketch space. **Sketch Y maps to global -Y.**
This means features placed at positive sketch Y appear at negative global Y,
and vice versa. Symmetric features (centered at Y=0) are unaffected, but
any off-center feature will appear mirrored.

**Rule: Negate Y coordinates when sketching on `lid_bottom`.**

```python
# Want a ridge at global position (ARM_HOLE_X, arm_ridge_y):
lid_bottom = lid.faces().sort_by(Axis.Z)[0]
with BuildSketch(lid_bottom) as ridge_sk:
    with Locations((ARM_HOLE_X, -arm_ridge_y)):  # negate Y for lid_bottom
        Rectangle(length, width)
extrude(amount=RIDGE_H)  # positive = follows -Z normal = downward
```

This does NOT affect:
- `lid_top` (normal +Z) — sketch Y = global Y, no flip
- `inner_floor` in the base (normal +Z) — sketch Y = global Y, no flip
- Side faces — different axis mapping, check case by case

If a lid underside feature appears at the mirror-image position of where you
expected it, the Y-axis flip was not accounted for.

### Placing Multiple Features
```python
# Grid of holes
with GridLocations(x_spacing, y_spacing, x_count, y_count):
    Hole(radius)

# Specific positions
with Locations((x1, y1), (x2, y2), (x3, y3)):
    Hole(radius)

# Polar (circular) pattern
with PolarLocations(radius, count):
    Hole(radius)
```

## Enclosure Design Patterns

### Feature Independence & Grouping

**Every cutout, hole, or object must have its own independent position variables.**
Never derive one feature's position from another feature's position.

#### Rules
1. **Independent positions** — Each feature defines its own `X`, `Y`, `Z` as absolute values from enclosure center, not relative to another feature
2. **No chained offsets** — `USBC_X = PWR_BTN_X + 16` is **wrong**. Use `USBC_X = 39.5` instead
3. **No formulas in final code** — During initial design, compute positions from wall heights, bay centers, etc. Once verified, **bake the result as a literal number**. This prevents silent drift when upstream variables change.
4. **Logical groups** — Features on the same wall or serving the same component are grouped with a comment header but remain independently positioned
5. **Group-level moves** — To move an entire group, the user says "move all battery wall features 5mm toward +X" and the AI adjusts each feature's constant independently by the same amount
6. **Sub-features follow their parent** — A button's guide channel uses the button's position variable (e.g. `PWR_BTN_X`), because the channel is physically part of the button assembly

#### Two-Step Position Workflow

When the user requests a position based on geometry (e.g. "halfway down the wall"):

1. **Compute** — Look up the relevant dimension (e.g. `BASE_H = 39.6`, wall runs from -19.8 to +19.8, halfway = 0.0)
2. **Bake** — Write the result as a literal: `GLAND_Z = 0.0`
3. **Never** write `GLAND_Z = BASE_H / 2 / 2` — if BASE_H changes later, the gland would silently move

When the user requests a relative move (e.g. "move 5mm toward +X"):

1. **Read** the current baked value from the position log or code
2. **Add/subtract** the delta: `DISPLAY_X = 62.5 + 5 = 67.5`
3. **Write** the new literal: `DISPLAY_X = 67.5`

#### Code Pattern
```python
# ══════════════════════════════════════════════════════
# FEATURE GROUP: Battery Wall (+Y wall cutouts)
# ──────────────────────────────────────────────────────
# Each feature has its own independent X and Z position.
# All values are baked absolute coordinates from enclosure center.
# Moving one feature does NOT affect any other.
# ══════════════════════════════════════════════════════

# ── Feature: Display Window ──
DISPLAY_X = 62.5    # mm from center (+X direction)
DISPLAY_Z = 0.7     # mm from center
DISPLAY_W = 14      # width
DISPLAY_H = 10      # height

# ── Feature: USB-C Port ──
USBC_X = 39.5       # mm from center (+X direction)
USBC_Z = -4.3       # mm from center
USBC_W = 8
USBC_H = 5

# ── Feature: Power Button (cutout + guide channel) ──
PWR_BTN_X = 28.5    # mm from center (+X direction)
PWR_BTN_Z = -5.3    # mm from center
# Guide channel uses PWR_BTN_X/Z — physically part of the button
```

#### Naming Convention
- Group header: `# FEATURE GROUP: [Wall/Area Name]`
- Feature header: `# ── Feature: [Name] ──`
- Position vars: `FEATURE_X`, `FEATURE_Y`, `FEATURE_Z` (UPPER_CASE, absolute from center)
- Size vars: `FEATURE_W`, `FEATURE_H` (width, height)
- Sub-features note their parent: `# (part of Power Button group)`

#### Feature Completeness Check

Every feature that occupies space in a part — whether it's a hole, a cutout, or a
**secondary object printed in a different color** — **must have a matching subtract
operation** in the parent part.

This applies to:
- **Holes/Cutouts/Ports** — empty space where nothing exists (cable glands, switch holes)
- **Multi-color inserts** — a separate STL that fills a cavity in the parent part
  (LED lenses, colored badges, accent pieces). The parent part must have the cavity
  cut out so the insert fits flush. If you only create the insert STL without cutting
  the cavity, the parent part will be solid where the insert should go.

A feature section that defines position variables and is used by labels or secondary
parts can *appear* complete because downstream code references the positions — but
if the actual hole/cavity was never created in the parent, the part will be solid
where it should be open.

**Checklist for every hole, cutout, or multi-color insert:**
1. Position variables defined (`FEAT_X`, `FEAT_Y`) ✓
2. **Cavity/hole cut in parent part** (`mode=Mode.SUBTRACT` or `extrude(amount=-X, mode=Mode.SUBTRACT)`) ✓
3. Secondary STL created (if multi-color insert) ✓
4. Downstream features reference positions (labels, etc.) ✓
5. **Text insert STL matches parent subtraction** — if a label is debossed in the
   parent (lid) AND also built as a separate solid insert for two-color printing,
   both `Text()` calls must have identical: string, `font_size`, `font_style`,
   `align`, `rotation`, and position. When changing ANY text property in the parent,
   always update the matching insert `BuildPart` block too. ✓
6. **Protrusions fused to parent body** — any feature that adds material to a part
   (ridges, bosses, tabs) must be created with sketch-on-face + extrude, NOT with
   a free-floating `Box()` or `Cylinder()` placed at absolute Z coordinates.
   The OCCT kernel does not reliably fuse geometry that merely *touches* a face
   without overlapping. Sketch + extrude from the face guarantees fusion. ✓

**Anti-pattern — free-floating Box (will NOT fuse, prints as spaghetti):**
```python
# BAD: Box placed at computed Z that only touches lid bottom
ridge_z = BASE_H + 5 - LID_H / 2 - RIDGE_H / 2
with Locations((x, y, ridge_z)):
    Box(width, depth, RIDGE_H)  # floats in space!
```

**Correct pattern — sketch + extrude from face (always fuses):**
```python
# GOOD: Sketch on lid bottom face, extrude downward (positive = follows -Z normal)
lid_bottom = lid.faces().sort_by(Axis.Z)[0]
with BuildSketch(lid_bottom) as ridge_sk:
    with Locations((x, y)):
        Rectangle(width, depth)
extrude(amount=RIDGE_H)  # positive follows face normal (-Z) = downward protrusion ✓
# WRONG: extrude(amount=-RIDGE_H) would go UP into the lid body, not down!
```

**Anti-pattern — missing cavity (looks complete but isn't):**
```python
# ── Feature: LED Holes ──
LED1_POS = (-33.6, 25.0)
LED2_POS = (-11.6, 25.0)
LED_POSITIONS = [LED1_POS, LED2_POS]
# Labels use these positions... ✓
# Lens STL uses these positions... ✓
# BUG: no Circle + extrude(SUBTRACT) in the lid! Lid is solid, lenses have nowhere to go.
```

**Correct pattern:**
```python
# ── Feature: LED Holes ──
LED1_POS = (-33.6, 25.0)
LED2_POS = (-11.6, 25.0)
LED_POSITIONS = [LED1_POS, LED2_POS]

# Cut holes in the parent part (lid) so lenses can fill them
for pos in LED_POSITIONS:
    with BuildSketch(lid_top) as led_hole_sk:
        with Locations(pos):
            Circle(LED_HOLE / 2)
    extrude(amount=-LID_H, mode=Mode.SUBTRACT)

# ... later, in a separate BuildPart:
# Lens cylinders fill these holes (printed in clear filament)
```

**When to check:** After writing any feature that defines positions for:
- Holes, cutouts, or ports → verify the subtract exists in the parent part
- Multi-color inserts (lenses, badges) → verify the parent part has the matching cavity
- Do this check **before** moving on to labels or dependent features

#### Print Feature Positions

Always include a position summary after building the base so both the AI and user
can verify where features actually ended up. This catches direction mistakes immediately.

```python
print(f"  Feature Positions (from enclosure center):")
print(f"    Cable Gland:     X=-87.0 (on -X wall), Y={GLAND_Y:.1f}, Z={GLAND_Z:.1f}")
print(f"    Display Window:  X={DISPLAY_X:.1f}, Y=55.5 (+Y wall), Z={DISPLAY_Z:.1f}")
# ... etc for each feature
```

#### Naming Convention
- Group header: `# FEATURE GROUP: [Wall/Area Name]`
- Feature header: `# ── Feature: [Name] ──`
- Position vars: `FEATURE_X`, `FEATURE_Z` (UPPER_CASE, absolute from center)
- Size vars: `FEATURE_W`, `FEATURE_H` (width, height)
- Sub-features note their parent: `# (part of Power Button group)`

#### Cross-Part Dependencies

Enclosure scripts often produce **multiple STL files** (base, lid, lenses, buttons).
When features in different parts share the same positions or dimensions, document
the dependency explicitly so moving one doesn't orphan the other.

#### Interpreting User Directional Language

Users describe new features relative to existing ones. Here's how to translate
their language into geometry:

**Edge references:**
- "underneath the hole" / "below the hole" → -Z edge of the feature
- "above the hole" → +Z edge of the feature
- "to the left of" → -X or -Y depending on context (check axis labels)
- "to the right of" → +X or +Y depending on context

**Sizing by reference:**
- "same depth as the power button guide" → look up `PWR_GUIDE_DEPTH` and reuse
- "runs the length of the hole" → match the hole's width/height dimension
- "same as X" → always look up the actual value, never guess

**Anchoring to edges (not centers):**
When the user says "underneath the USB-C hole", compute the edge position:
```python
# Bottom edge of USB-C hole:
usbc_bottom = USBC_Z - USBC_H / 2
# New feature sits just below that:
SHELF_Z = usbc_bottom - SHELF_H / 2
```

**Direction "into the box":**
On a +Y wall, "into the box" = toward -Y. Position using:
```python
shelf_y = bat_wall_y - WALL - SHELF_DEPTH / 2
```

**Why this works well:**
1. User describes **what** and **why** ("keep cables from blocking the port")
2. AI picks shape from purpose (shelf, not wall or ridge)
3. User references existing features for dimensions ("same depth as...")
4. AI looks up the actual value and reuses it — no guessing
5. The resulting code uses named constants from the referenced feature

**Rules:**
1. **Define shared vars once** — e.g. `LED_POSITIONS` defined in the lid section, reused by lenses
2. **DEPENDS ON comment** — every separate `BuildPart` that references another part's variables must have a `# DEPENDS ON:` comment listing what it uses and where it's defined
3. **SHARED POSITIONS comment** — at the definition site, list all consumers so you know what will break if you change it

**Code Pattern:**
```python
# In the lid BuildPart:
    # ── Feature: LED Holes ──
    # SHARED POSITIONS: LED1_POS, LED2_POS are also used by:
    #   - LED Lenses (separate STL)
    #   - LED Labels (debossed on lid)
    LED1_POS = (-50.5, 35.0)
    LED2_POS = (-50.5, 12.9)
    LED_POSITIONS = [LED1_POS, LED2_POS]

# In the lenses BuildPart:
# ══════════════════════════════
# LED LENSES — separate STL
# ══════════════════════════════
# DEPENDS ON: LED_POSITIONS (defined in Lid section above)
# If LED positions change, lenses auto-update.
```

**What NOT to do:**
```python
# BAD — lens positions hardcoded separately from lid holes:
LENS1_POS = (-50.5, 35.0)   # duplicated! will drift if lid changes
```

#### Relationship Comments (RELATED / DEPENDS ON / ON RESIZE)

Features within the **same BuildPart** that are physically related (e.g. a switch hole
and its label) use **RELATED**, **DEPENDS ON**, and **ON RESIZE** comments to document
the link and trigger proactive checks when things change.

**Four comment types:**
- `# SHARED POSITIONS:` — at the definition site, lists ALL other features/parts that use these vars
- `# DEPENDS ON:` — at the consumer site, names the variable AND where it's defined
- `# RELATED:` — lighter-weight, for features in the same BuildPart that reference each other
- `# ON RESIZE:` — at the definition site, lists features whose **position** depends on
  this feature's **size**. When the size changes, the AI must check/ask if those features
  need repositioning.

**Why ON RESIZE is needed:**
`DEPENDS ON` tells you *what* a feature uses, but not *when to act*. A label that's
positioned "5mm from the edge of the hole" uses both the hole's position AND its
diameter. If the hole moves, the label moves (same vars). But if the hole's size
changes (LED_HOLE goes from 4.2 → 10.2mm), the edge moves but the label stays put
because its position was baked. `ON RESIZE` flags this so the AI proactively asks:
"The LED holes got bigger — should I move the Armed/Firing labels to maintain clearance?"

**Code Pattern:**
```python
# ── Feature: LED Holes ──
# SHARED POSITIONS: LED1_POS, LED2_POS used by lenses + labels
# ON RESIZE: LED_HOLE size change affects:
#   - Armed/Firing label positions (offset from hole edge)
#   - Lens cylinder diameters (auto via LED_HOLE var)
LED_HOLE = 10.2
LED1_POS = (-33.6, 25.0)
LED2_POS = (-11.6, 25.0)

# ── Feature: Armed LED Label ──
# DEPENDS ON: LED1_POS, LED_HOLE (from LED Holes above)
# Position is edge-relative: LED1_X - LED_HOLE/2 - gap
ARMED_LED_LABEL_X = -42.7
```

**AI behavior when a sized feature changes:**
1. Look for `ON RESIZE` comments on the feature being changed
2. For each listed dependent, check if its position uses the changed dimension
3. If a dependent's position was baked from an edge calculation (e.g. `LED_X - LED_HOLE/2 - gap`),
   **ask the user**: "LED holes changed size — should I adjust [Armed/Firing label] positions?"
4. If the dependent uses the variable directly (e.g. lens uses `LED_HOLE` for its radius),
   it auto-updates — no action needed, but confirm it in the output

**When to add ON RESIZE:**
- Any feature whose **size** (width, height, diameter) is used by another feature's
  **position** calculation (edge offsets, clearance gaps)
- Not needed when dependents use the same position variable (they auto-update)
- Not needed for purely cosmetic relationships (label text content doesn't change with size)

**When to use which:**
- `RELATED` → same BuildPart, lightweight hint (the switch says "my label is below")
- `DEPENDS ON` → the consumer explains exactly what it uses and from where
- `SHARED POSITIONS` → cross-BuildPart sharing (lid holes → lens cylinders)
- `ON RESIZE` → parent flags that its SIZE affects dependents' POSITIONS
- `PAIRED WITH` → two BuildParts that produce matching geometry (cavity + insert)

#### Paired Part Comments (PAIRED WITH)

When a feature in one `BuildPart` has a matching counterpart in another `BuildPart`
(e.g. a debossed label in the lid and the same label as a solid insert for two-color
printing), **both sides must have a `# PAIRED WITH:` comment** pointing to each other.
This makes the link visible at both locations so any edit triggers a check of the partner.

**When to add PAIRED WITH:**
- A cavity in the parent part has a matching solid insert in a separate STL
- Text debossed from one part is also extruded as a standalone insert
- Any feature split across two BuildParts where both must match exactly

**What must match between paired features:**
- String content, `font_size`, `font_style`, `align`, `rotation`, position
- Shape dimensions (width, height, depth) and tolerances

**Code pattern:**
```python
# In the lid BuildPart:
    # ── Feature: ARM Label ──
    # PAIRED WITH: ARM label in lid_text BuildPart (text insert STL)
    # Any change here must be mirrored there.
    with BuildSketch(lid_top) as arm_lbl:
        with Locations((ARM_LABEL_X, ARM_LABEL_Y)):
            Text("ARM", font_size=6, font_style=FontStyle.BOLD, ...)
    extrude(amount=-TEXT_DEPTH, mode=Mode.SUBTRACT)

# In the lid_text BuildPart:
    # ARM switch label
    # PAIRED WITH: ARM label in lid BuildPart (deboss subtraction)
    # Any change here must be mirrored there.
    with BuildSketch(Plane.XY.offset(LID_TOP_Z)) as t3:
        with Locations((ARM_LABEL_X, ARM_LABEL_Y)):
            Text("ARM", font_size=6, font_style=FontStyle.BOLD, ...)
    extrude(amount=-TEXT_DEPTH)
```

**AI behavior when editing a feature with PAIRED WITH:**
1. Read the PAIRED WITH comment to find the partner location
2. Make the identical change in both places in the same edit
3. If unsure whether a property change affects the partner, update both anyway

#### Multi-Color Text Visibility (Flush Inserts)

When converting text from single-color debossed to flush two-color inserts,
**proactively suggest visibility improvements to the user.** Debossed text relies on
shadows for readability; flush two-color text relies solely on color contrast.
Text that was readable when debossed may become invisible as a flush insert.

**When the user asks to convert to two-color text, suggest:**
1. Increasing `font_size` (recommend at least 6 for labels, 8+ for branding)
2. Using `font_style=FontStyle.BOLD` for wider strokes
3. Using UPPERCASE for small labels (wider letter forms fill more area)

Phrase these as suggestions, not mandates — the user may have specific
aesthetic preferences. Example: *"Since two-color text relies on color contrast
alone (no shadows), I'd suggest increasing the font size and using bold/uppercase
to ensure readability. Want me to make those changes?"*

**Guidelines for flush multi-color text:**
- Use `font_style=FontStyle.BOLD` for all flush text inserts. Bold strokes are wider
  and create more visible color boundaries.
- Use a larger `font_size` than you would for single-color debossed text. What looks
  fine as a recessed label (where shadows help readability) may be invisible as a
  flush color change. Start at `font_size=6` minimum for control labels.
- If bold + larger size is still not enough, consider increasing `font_size` further
  before resorting to raised text.

**When raised (protruding) text is safe:**
- The text surface does NOT face the build plate during printing. For example, text
  on the lid top surface is safe to raise because the lid prints face-down — the text
  faces upward during printing and is fully supported.
- The part has enough flat surface around the text to rest on the build plate.

**When raised text is NOT safe:**
- The text surface faces the build plate during printing. If text protrudes from a
  surface that sits on the heated bed, the rest of the part would be elevated above
  the bed — printing over open air. For example, text raised above the base floor
  would lift the entire base off the build plate.
- Any surface where the text is the first layer to touch the bed.

**Rule of thumb:** If the text-bearing surface prints against the bed, keep text flush
or debossed. If it prints facing upward, raised text is an option for extra visibility.

### PCB Orientation in Enclosure

PCBs are often mounted rotated inside an enclosure (e.g. a wide board turned
sideways to fit a narrow box). **Always document the mapping** between:

1. **User language** ("from the left", "from the bottom") — physical directions when looking at the board in the enclosure
2. **PCB coords** (hx along long edge, hy along short edge) — from the PCB boards skill
3. **Enclosure coords** (X, Y, Z from center) — what the Build123d code uses

#### Documentation Pattern (in Python comments)
Every enclosure script must include a mapping block like this:

```python
# ── PCB Orientation in Enclosure ──
# The board is mounted [ROTATED 90° / FLAT / etc.]:
#
#   User says            PCB coord    Enclosure axis
#   ─────────            ─────────    ──────────────
#   "from left"     →    hx (long)  → X axis
#   "from bottom"   →    hy (short) → Y axis
#   component height →    —          → Z axis (toward lid)
#
# pcb_to_center(hx, hy) handles this conversion.
```

This block goes near `pcb_to_center()` so anyone reading the code (or an AI)
knows exactly how user directions map to coordinates.

#### CRITICAL: Rotated Board Measurement Conversion

When the board is mounted **rotated 90°**, user measurements taken on the physical
board **do not map directly** to `pcb_to_center(hx, hy)`. The axes are swapped
AND one axis may be mirrored depending on which corner is "bottom-left" after rotation.

**`pcb_to_center(hx, hy)` always uses the board's NATIVE coordinate system:**
- `hx` = mm from left along the **long edge** (PCB_L)
- `hy` = mm from bottom along the **short edge** (PCB_W)

**When the user measures on a rotated board:**
- Their "from left" is along the **short edge** → maps to `hy`
- Their "from bottom" is along the **long edge** → maps to `hx`
- BUT the "bottom" of the rotated board may be the RIGHT end of the native
  long edge, so `hx = PCB_L - user_measurement`

**Conversion formula for 90° rotation:**
```python
# User measures on the ROTATED board:
#   user_from_left  = measurement along short edge (visible left-right)
#   user_from_bottom = measurement along long edge (visible bottom-top)
#
# Convert to pcb_to_center native coords:
#   hy = user_from_left                          # short edge maps directly
#   hx = PCB_L - user_from_bottom                # long edge is MIRRORED
#
# Example: User says "31mm from left, 41mm from bottom" on rotated board
#   hy = 31
#   hx = 88.9 - 41 = 47.9
#   pcb_to_center(47.9, 31)
```

**Why the mirror?** When you rotate a board 90° CCW, the native "left" edge (hx=0)
ends up at the top, and the native "right" edge (hx=PCB_L) ends up at the bottom.
So the user's "from bottom" measures from hx=PCB_L downward.

**Three-step checklist when converting rotated measurements:**
1. **Swap axes** — user's "from left" → hy, user's "from bottom" → hx
2. **Check mirror** — does the rotated "bottom" correspond to hx=0 or hx=PCB_L?
   If hx=PCB_L, mirror: `hx = PCB_L - user_measurement`
3. **Verify** — compute pcb_to_center and sanity-check: is the result in the
   expected quadrant of the enclosure?

**Always verify by asking:** "Are these LEDs/components closer to the -X wall or
the +X wall? Closer to -Y or +Y?" If the result doesn't match the physical board,
the mirror direction is wrong.

### Coordinate Conversion: Board → Enclosure

Board hole positions (from `electronics-pcb-boards/SKILL.md`) use **bottom-left corner origin**.
Enclosure models use **center origin**. Convert with:

```python
def pcb_to_center(hx, hy):
    """Convert PCB bottom-left-corner coords to enclosure center coords.
    hx = mm from left along long edge → enclosure X
    hy = mm from bottom along short edge → enclosure Y"""
    return (
        PCB_BAY_CENTER_X + hx - PCB_L / 2,
        PCB_BAY_CENTER_Y + hy - PCB_W / 2,
    )
```

This means you can copy hole coordinates directly from the PCB boards skill into
`PCB_CORNER_HOLES` / `PCB_CENTER_HOLES` arrays — `pcb_to_center()` handles the rest.

### Pattern 1: Two-Piece Box (Base + Lid)

```python
from build123d import *

# ── Parameters ──
LENGTH = 120        # internal length (mm)
WIDTH = 70          # internal width (mm)
BASE_H = 25         # base height (mm)
LID_H = 8           # lid height (mm)
WALL = 2.0          # wall thickness (mm)
CORNER_R = 3        # corner fillet radius
LIP = 1.5           # lip height for lid alignment
LIP_TOL = 0.3       # tolerance gap for lip fit

INT_L = LENGTH
INT_W = WIDTH
EXT_L = LENGTH + 2*WALL
EXT_W = WIDTH + 2*WALL

# ── Base ──
with BuildPart() as base:
    Box(EXT_L, EXT_W, BASE_H)
    fillet(base.edges().filter_by(Axis.Z), CORNER_R)
    top = base.faces().sort_by(Axis.Z)[-1]
    offset(amount=-WALL, openings=top)
    # Inner lip for lid alignment — sits INSIDE the cavity on top of the wall
    # Outer = INT size (flush with inner wall surface)
    # Inner = INT - 2*LIP (inset further into cavity)
    # Lid drops over the outer wall and catches on this inner lip.
    # LIP must be <= WALL so the lip sits fully on solid wall material.
    rim_top = base.faces().sort_by(Axis.Z)[-1]
    with BuildSketch(rim_top) as lip_sk:
        Rectangle(INT_L, INT_W)
        Rectangle(INT_L - 2*LIP, INT_W - 2*LIP, mode=Mode.SUBTRACT)
    extrude(amount=LIP)

# ── Lid ──
with BuildPart() as lid:
    Box(EXT_L, EXT_W, LID_H)
    fillet(lid.edges().filter_by(Axis.Z), CORNER_R)
    bot = lid.faces().sort_by(Axis.Z)[0]
    # Recess matches lip outer edge (INT) + tolerance
    # IMPORTANT: bottom face normal is -Z, so use NEGATIVE amount to cut INTO lid
    with BuildSketch(bot) as recess_sk:
        Rectangle(INT_L + LIP_TOL, INT_W + LIP_TOL)
    extrude(amount=-LIP, mode=Mode.SUBTRACT)
```

### Pattern 2: PCB Standoffs

```python
# Inside the base BuildPart, after offset():
pcb = board_specs  # e.g. {"length": 158, "width": 51, "holes": [...]}
STANDOFF_H = 5     # height above base floor
STANDOFF_OD = 6    # outer diameter
SCREW_ID = 2.5     # M3 screw hole (2.5mm for self-tap into plastic)

# IMPORTANT: After shelling, [0] is outer bottom, [1] is inner floor!
inner_floor = base.faces().sort_by(Axis.Z)[1]

# Build standoff cylinders on the inner floor
with BuildSketch(inner_floor) as standoff_sk:
    for (x, y) in pcb["holes"]:
        with Locations((x - pcb["length"]/2, y - pcb["width"]/2)):
            Circle(STANDOFF_OD / 2)
extrude(amount=STANDOFF_H)

# Cut screw holes through standoffs using sketch + subtract
# (more reliable than Hole() after shelling)
for (x, y) in pcb["holes"]:
    with BuildSketch(inner_floor) as hole_sk:
        with Locations((x - pcb["length"]/2, y - pcb["width"]/2)):
            Circle(SCREW_ID / 2)
    extrude(amount=STANDOFF_H, mode=Mode.SUBTRACT)
```

#### Standoff Sizing Guidelines

Tall, thin standoffs are prone to snapping when screws are tightened — especially
with PLA, which is rigid but brittle. The taller the standoff, the greater the
leverage applied at the base when the screw pulls the PCB down.

**Minimum outer diameter by height:**

| Standoff Height | Min OD (M2 screw) | Min OD (M3 screw) | Notes |
|-----------------|--------------------|--------------------|-------|
| ≤ 5mm           | 5.0mm              | 6.0mm              | Standard — low snap risk |
| 6–10mm          | 6.0mm              | 7.0mm              | Moderate height — add material |
| 11–15mm         | 7.0mm              | 8.0mm              | Tall — needs thick walls |
| 16–25mm         | 8.0mm              | 9.0mm              | Very tall — max OD practical |
| > 25mm          | Consider buttress or gusset at base instead of wider OD |

**Key rules:**
- **Wall thickness around screw hole ≥ 2mm** — measure from screw hole edge to
  standoff outer edge: `(STANDOFF_OD - SCREW_ID) / 2 ≥ 2.0`
- **Height-to-OD ratio ≤ 3:1** — if `STANDOFF_H / STANDOFF_OD > 3`, the standoff
  is at high snap risk. Increase OD or add a tapered base (fillet/chamfer at floor).
- **PLA is brittle under lateral load** — screwing into a tall standoff applies
  significant side force. PETG or ABS are more forgiving but the sizing rules still apply.
- **When in doubt, go wider** — a 7mm OD standoff uses negligible extra material
  but is dramatically stronger than a 5mm one at height.

**Example — checking a 20mm tall M3 standoff:**
```python
STANDOFF_H = 20.0
STANDOFF_OD = 7.0   # 7mm OD for 20mm height
SCREW_ID = 2.5      # M3 self-tap

wall = (STANDOFF_OD - SCREW_ID) / 2  # = 2.25mm ✓ (≥ 2mm)
ratio = STANDOFF_H / STANDOFF_OD     # = 2.86  ✓ (≤ 3.0)
```

### Pattern 3: Panel Cutouts (Lid)

```python
# Work on the lid's top face
lid_top = lid.faces().sort_by(Axis.Z)[-1]
with BuildSketch(lid_top) as panel_sk:
    # Toggle switch (12mm hole)
    with Locations((-30, 10)):
        Circle(6)  # 12mm diameter
    # Momentary button (16mm hole)
    with Locations((10, 10)):
        Circle(8)  # 16mm diameter
    # LED holes (5mm)
    with Locations((-10, -10), (10, -10)):
        Circle(2.5)  # 5mm diameter
extrude(amount=-LID_H, mode=Mode.SUBTRACT)
```

### Pattern 4: Cable Gland Hole (Side Wall)

```python
# PREFERRED: World-space cylinder subtraction — avoids face selection issues
# Punch through the +X wall at a specific Y, Z position
gland_r = 6.25  # e.g. PG7 = 12.5mm diameter

# CENTER the hole on the wall height — use z=0 so there's equal clearance
# above and below the hole for the cable gland nut to fit and spin freely.
# Avoid arbitrary offsets like BASE_H * 0.45 — these leave uneven margins
# and the nut may not have room to thread on.
gland_z = 0  # exact vertical center of the wall

with Locations((EXT_L / 2, 0, gland_z)):  # X=wall, Y=centered, Z=centered
    Cylinder(
        radius=gland_r,
        height=WALL * 3,         # long enough to punch through
        rotation=(0, 90, 0),     # rotate to point along X axis
        mode=Mode.SUBTRACT,
    )

# For -X wall: use (-EXT_L / 2, y, z)
# For +Y wall: use (x, EXT_W / 2, z) with rotation=(90, 0, 0)
# For -Y wall: use (x, -EXT_W / 2, z) with rotation=(90, 0, 0)
```

### Pattern 5: Ventilation Slots

```python
# Array of slots on a side face
side = base.faces().sort_by(Axis.Y)[-1]
with BuildSketch(Plane(side)) as vent_sk:
    with GridLocations(5, 0, 8, 1):  # 8 slots, 5mm apart
        SlotCenterToCenter(center_separation=10, height=2)
extrude(amount=-WALL, mode=Mode.SUBTRACT)
```

### Pattern 6: Debossed Label

```python
lid_top = lid.faces().sort_by(Axis.Z)[-1]
with BuildSketch(lid_top) as label_sk:
    Text("ROCKET CTRL", font_size=8, align=(Align.CENTER, Align.CENTER))
extrude(amount=-0.5, mode=Mode.SUBTRACT)  # 0.5mm deep deboss
```

**Text alignment convention for component labels:**
Labels for switches, buttons, and LEDs should be **center-aligned** (`Align.CENTER, Align.CENTER`)
on the same X as their component hole, offset in Y for clearance. This keeps labels
visually centered on their component. Use `Align.MIN` only when the user explicitly
requests left/bottom-aligned text.

Note: when the user says "center justified" they mean "center aligned" (`Align.CENTER`).
Interpret text alignment requests in terms of Build123d `Align` values, not typography justification.

## Common Component Hole Sizes

| Component | Hole Diameter (mm) | Notes |
|-----------|-------------------|-------|
| 3mm LED | 3.2 | Tight press-fit |
| 4mm LED | 4.2 | Slight clearance |
| 5mm LED | 5.2 | Standard |
| Toggle switch (small) | 6.2 | M6 thread |
| Toggle switch (standard) | 12.0 | 12mm panel mount |
| Key switch | 19.0 | Standard ignition key |
| Momentary button (small) | 7.0 | 7mm panel mount |
| Momentary button (standard) | 16.0 | 16mm panel mount |
| Momentary button (large) | 22.0 | 22mm industrial |
| USB-C connector | 9.0 × 3.2 | Rectangular cutout |
| Barrel jack (5.5mm) | 8.0 | Standard DC jack |
| Cable gland PG7 | 12.5 | 3-6.5mm cable |
| Cable gland PG9 | 15.5 | 4-8mm cable |
| Cable gland PG11 | 18.5 | 5-10mm cable |
| M3 screw (clearance) | 3.4 | Through-hole |
| M3 screw (self-tap) | 2.5 | Into plastic standoff |
| M2.5 standoff | 2.8 | PCB mounting |

## PCB Board Dimensions

> **Do NOT duplicate board specs here.** Board dimensions and mounting hole
> positions are defined in the **electronics-pcb-boards** skill
> (`electronics-pcb-boards/SKILL.md`). Always read that skill first.

When generating enclosure standoffs, read the board's `mounting_holes` array
from the PCB boards skill and use each hole's `type` to pick the right standoff:

| Hole Type | Standoff OD | Screw Hole (self-tap) | Screw Hole (clearance) |
|-----------|-------------|----------------------|----------------------|
| M2 | 5.0 mm | 1.8 mm | 2.4 mm |
| M2.5 | 6.0 mm | 2.2 mm | 2.8 mm |
| M3 | 7.0 mm | 2.5 mm | 3.4 mm |

### Coordinate Conversion: Board → Enclosure

```python
def pcb_to_center(hx, hy):
    """Convert PCB bottom-left-corner coords to enclosure center coords.
    Board mounting_holes use (X_from_left, Y_from_bottom) format.
    Enclosure uses center origin."""
    return (
        PCB_BAY_CENTER_X + hx - PCB_L / 2,
        PCB_BAY_CENTER_Y + hy - PCB_W / 2,
    )

# Usage: iterate the board's mounting_holes array
for hole in mounting_holes:
    cx, cy = pcb_to_center(*hole["pos"])
    # Use hole["type"] to pick standoff OD and screw ID from table above
```

## 3D Printing Guidelines

### Tolerances
- **Hole tolerance:** +0.2mm from nominal (e.g. 12mm switch → 12.2mm hole)
- **Lip/socket fit:** 0.3mm gap per side (0.6mm total)
- **Screw holes in plastic:** -0.5mm from screw diameter (self-tapping)
- **Press-fit for LEDs:** +0.1mm (tight) to +0.2mm (snug)

### Print Settings (PLA)
- **Layer height:** 0.2mm (standard) or 0.12mm (fine detail for labels)
- **Infill:** 20-30% (boxes don't need strength)
- **Walls:** 3 perimeters minimum
- **Top/bottom layers:** 4 minimum
- **Supports:** Only if needed for side-wall holes (print box upside-down to avoid)

### Design-for-Print Tips
1. **Print lid face-down** — top surface quality is best on the build plate
2. **Print base right-side-up** — standoffs print cleanly upward
3. **Chamfer bottom edges** — 0.5mm chamfer on the first layer prevents elephant's foot
4. **Minimum wall: 1.6mm** — 2.0mm recommended for strength
5. **No overhangs > 45°** — or design for supports
6. **Bridge span ≤ 20mm** — for unsupported horizontal sections
7. **Use circular holes instead of square cutouts** in internal walls — arches are self-supporting during FDM printing (each layer only overhangs slightly). Square holes create an unprintable flat overhang on the top edge that sags or requires supports.
8. **Add support ramps under wall-mounted protrusions** — any feature that sticks out horizontally from a wall (guide channels, shelves, ledges) creates an overhang on its underside. Add a right-triangle wedge underneath that tapers from the wall face down to the free edge. This eliminates the overhang while fitting neatly under the existing feature.

### Print Orientation per Part

Every exported part must have a **defined print orientation** — which face goes on
the build plate. This must be communicated in three places:

1. **In the script** — pass `bed_face` to `export_with_reference()` for the axis
   reference block (design mode). Example: `bed_face="-Z"` means -Z face on bed.
2. **In the console output** — print a summary table at the end of the script.
3. **In the documentation** — the enclosure HTML page must list print orientation
   for every STL file.

**Standard orientations for enclosure parts:**

| Part | Bed Face | Orientation | Reason |
|------|----------|-------------|--------|
| Base | -Z | Right-side up | Standoffs and walls print upward; no overhangs |
| Lid | +Z | Face-down (outer surface on bed) | Smooth top surface from bed; holes and features print upward |
| Lid text insert | +Z | Same as lid | Must align with lid cavities |
| LED lenses | +Z | Same as lid | Cylindrical; flat surface on bed |
| Small buttons/plungers | -Z | Flat bottom down | Largest flat face on bed for stability |

**Console output pattern:**
```python
print(f"\n  Print Orientation (bed_face = face on build plate):")
print(f"    controller_base.stl          — BED: -Z (right-side up, open top faces up)")
print(f"    controller_lid.stl           — BED: +Z (face-down, outer surface on bed)")
print(f"    controller_lid_text.stl      — BED: +Z (face-down, same as lid)")
print(f"    controller_lid_lenses.stl    — BED: +Z (face-down, same as lid)")
print(f"    controller_power_button.stl  — BED: -Z (flat bottom on bed)")
```

**AI behavior:**
- When creating a new part, **always determine the correct print orientation** before
  writing the export call. Consider: largest flat face for stability, overhangs,
  surface quality requirements, and whether features print upward.
- Always pass `bed_face` to `export_with_reference()`.
- Always include the part in the print orientation console summary.
- Always document the orientation in the enclosure HTML page.

### Support Ramp Pattern for Wall Protrusions

When a box-shaped feature protrudes horizontally from an internal wall face, the
bottom face of that box is an unsupported overhang. Add a **right-triangle wedge**
underneath it:

```
   Wall
    │  ┌──────────┐  ← protrusion (guide, shelf, etc.)
    │  │          │
    │  └──────────┘
    │  ╲          │  ← support ramp fills this triangle
    │    ╲        │     (top = protrusion bottom,
    │      ╲      │      vertical = wall face,
    │        ╲    │      diagonal = 45° slope)
    │          ╲  │
    │            ╲│
    │
```

**Implementation (Build123d):**

Sketch the triangle on a YZ plane offset to one edge of the protrusion, then
extrude across its full width. Use absolute coordinates — no `Locations` wrapper.

```python
# Given: protrusion at (FEAT_X, feat_y, FEAT_Z) with width FEAT_W, depth FEAT_DEPTH
# Bottom of protrusion:
feat_bottom_z = FEAT_Z - FEAT_H / 2
wall_inside_y = bat_wall_y - WALL           # inside face of wall
feat_free_y = wall_inside_y - FEAT_DEPTH    # free edge of protrusion

# Sketch on YZ plane, offset to -X edge of protrusion
with BuildSketch(Plane.YZ.offset(FEAT_X - FEAT_W / 2)):
    Polygon(
        (wall_inside_y, feat_bottom_z),                  # top corner at wall
        (feat_free_y, feat_bottom_z),                    # top corner at free edge
        (wall_inside_y, feat_bottom_z - FEAT_DEPTH),     # bottom corner at wall (taper)
        align=None,
    )
extrude(amount=FEAT_W)  # extrude across full width of protrusion
```

**Key rules:**
- Ramp height = protrusion depth (gives ~45° slope, always self-supporting)
- Use **absolute world coordinates** in the Polygon vertices — relative offsets
  with `Locations` are error-prone for triangles and often place the shape incorrectly
- The ramp goes **underneath** the protrusion, not above or beside it
- Extrude `amount` = protrusion width (same dimension along X)

### Separate BuildPart for Internal Walls

When an internal wall (e.g. a bay divider) needs holes or cutouts, **build it as
a separate `BuildPart` then `add()` it to the base**. This prevents the hole's
`Mode.SUBTRACT` cylinder from accidentally clipping adjacent base walls or floor.

**CRITICAL: Internal wall height limit.**
Internal walls (dividers, ridges, retaining walls) must **never extend into the
lip zone**. The maximum height for any internal feature is:

```
MAX_INTERNAL_H = BASE_H - WALL   # floor to wall top (lip sits above this)
```

If an internal wall reaches into the lip zone (`BASE_H - WALL + LIP`), the lid
cannot seat over the lip and will sit proud of the base. This is a common mistake
when making internal walls "full height" — use `BASE_H - WALL`, not
`BASE_H - WALL + LIP`.

```python
# Inside the base BuildPart, after standoffs/ridges:

    # ── Divider wall between bays ──
    # Built as separate part so cable hole subtraction can't clip base walls.
    # HEIGHT RULE: Must stop at wall top (BASE_H - WALL), NOT lip top.
    DIVIDER_X = PCB_BAY_CENTER_X + PCB_L / 2 + PAD / 2
    DIVIDER_H = BASE_H - WALL   # floor to wall top (below lip, so lid can seat)
    DIVIDER_Z = bat_floor_z + DIVIDER_H / 2

    with BuildPart() as divider_part:
        with Locations((DIVIDER_X, 0, DIVIDER_Z)):
            Box(DIVIDER, INT_W, DIVIDER_H)

        # Circular cable routing hole — self-supporting for FDM printing.
        # Bottom tangent to floor, offset from wall for structural support.
        CABLE_DIA = 10.0
        CABLE_Y = INT_W / 2 - CABLE_DIA / 2 - 2   # 2mm from +Y wall
        CABLE_Z = bat_floor_z + CABLE_DIA / 2       # bottom on floor
        with Locations((DIVIDER_X, CABLE_Y, CABLE_Z)):
            Cylinder(
                radius=CABLE_DIA / 2,
                height=DIVIDER * 3,
                rotation=(0, 90, 0),
                mode=Mode.SUBTRACT,
            )

    add(divider_part.part)  # merge into base
```

**When to use this pattern:**
- Internal divider walls that need cable routing holes
- Any internal feature where a `Mode.SUBTRACT` operation might extend beyond the feature into adjacent geometry
- Complex internal structures with multiple cutouts

**Why not just use the base BuildPart directly?**
A `Cylinder(mode=Mode.SUBTRACT)` at the junction of a divider and a wall will
subtract from *everything* in the current BuildPart — including the wall. Building
the divider separately scopes the subtraction to only the divider solid.

## Axis Wall Labels Convention

All enclosures should include **debossed axis labels** on the outer walls of the base. These labels (+X, -X, +Y, -Y) allow the user to communicate precisely about which wall, face, or direction a feature should be placed or moved.

### Why
When the user says "move the USB-C hole toward the -X wall by 10mm", or "put the cable gland on the +Y wall", there is zero ambiguity. Without labels, descriptions like "left" or "front" depend on orientation and are error-prone.

### Implementation
```python
# Deboss axis labels on each outer wall of the BASE
# Place each label centered on its wall face, near the top edge.
LABEL_DEPTH = 0.6  # mm into wall
LABEL_SIZE = 8     # font size

# +X wall
with BuildSketch(Plane(base.faces().sort_by(Axis.X)[-1])) as lbl:
    Text("+X", font_size=LABEL_SIZE, align=(Align.CENTER, Align.CENTER))
extrude(amount=-LABEL_DEPTH, mode=Mode.SUBTRACT)

# -X wall
with BuildSketch(Plane(base.faces().sort_by(Axis.X)[0])) as lbl:
    Text("-X", font_size=LABEL_SIZE, align=(Align.CENTER, Align.CENTER))
extrude(amount=-LABEL_DEPTH, mode=Mode.SUBTRACT)

# +Y wall
with BuildSketch(Plane(base.faces().sort_by(Axis.Y)[-1])) as lbl:
    Text("+Y", font_size=LABEL_SIZE, align=(Align.CENTER, Align.CENTER))
extrude(amount=-LABEL_DEPTH, mode=Mode.SUBTRACT)

# -Y wall
with BuildSketch(Plane(base.faces().sort_by(Axis.Y)[0])) as lbl:
    Text("-Y", font_size=LABEL_SIZE, align=(Align.CENTER, Align.CENTER))
extrude(amount=-LABEL_DEPTH, mode=Mode.SUBTRACT)
```

### Rules
- Always add axis labels to the **base** (not the lid) — they’re always visible even when the lid is off
- Labels go on the **outer** face of each wall
- Use a consistent font size (8pt) and depth (0.6mm)
- The labels should be centered on each wall face
- When describing enclosure features in documentation, always reference walls by their axis label (e.g. "+Y wall", "-X wall")
- When the user describes a direction ("move toward -X", "shift toward +Y"), interpret it relative to these labeled axes

### User Orientation Map

Axis labels (+X, -X, etc.) are precise but don't match how users naturally think
about direction ("move it up", "shift it left"). The orientation depends on how
the user holds/views the enclosure, which varies per project.

**Establish a direction map when the enclosure is first designed.** Ask the user
or infer from context: "When looking at the lid from above, which way is up?"
Then bake the mapping into the script as a constant dictionary.

```python
# ── User Orientation Map ──
# Maps user-friendly directions to enclosure axes.
# Established when the enclosure is first designed.
# Viewing the lid from above with the cable gland (-X) at the front:
ORIENTATION = {
    "front":  "-X",   # toward cable gland
    "back":   "+X",   # toward battery
    "left":   "-Y",   # toward back wall
    "right":  "+Y",   # toward battery wall (USB-C, display)
    "top":    "+Z",   # lid
    "bottom": "-Z",   # floor
}
```

**Use the orientation map to interpret user requests:**
When the user says "move it toward the front 15mm", look up `ORIENTATION["front"]` = `-X`,
then subtract 15 from the X coordinate. Never guess the direction — always consult
the map.

**Include friendly labels on the axis reference block:**
The reference cube should show both the axis label AND the friendly direction
on each mapped face (e.g. "+X" at top of face, "Down" at bottom). This way
when the user sees the cube in the slicer, they immediately know the mapping.

```python
def make_axis_reference_block(size=15, label_depth=0.5, font_size=6, dir_font_size=3.5):
    dir_labels = {v: k.capitalize() for k, v in ORIENTATION.items()}
    with BuildPart() as ref:
        Box(size, size, size)
        for axis, signs in [(Axis.X, ("+X", "-X")), (Axis.Y, ("+Y", "-Y")), (Axis.Z, ("+Z", "-Z"))]:
            for idx, label in enumerate(signs):
                face = ref.faces().sort_by(axis)[-1 if idx == 0 else 0]
                # Axis label at top of face
                with BuildSketch(face):
                    with Locations((0, size / 2 - font_size * 0.7)):
                        Text(label, font_size=font_size, align=(Align.CENTER, Align.CENTER))
                extrude(amount=-label_depth, mode=Mode.SUBTRACT)
                # Friendly direction below, if this axis has a mapping
                if label in dir_labels:
                    with BuildSketch(face):
                        with Locations((0, -size / 2 + dir_font_size * 1.2)):
                            Text(dir_labels[label], font_size=dir_font_size,
                                 align=(Align.CENTER, Align.CENTER))
                    extrude(amount=-label_depth, mode=Mode.SUBTRACT)
    return ref.part
```

**When to establish the map:**
- At the start of any new enclosure project
- If the user says directional terms (front/back/left/right/up/down) and no map
  exists yet, **ask** which axis they mean before proceeding — do not guess
- If they've already used directional language consistently, infer the map and
  confirm it with them

**Recommended terms:** Use Front/Back, Left/Right, Top/Bottom as the six directions.
These are universally understood and cover all 3 axes. Avoid Up/Down for X/Y axes —
reserve vertical language for the Z axis (Top = lid, Bottom = floor).

**Rules:**
- The map is per-project (different enclosures may have different orientations)
- All 6 axes should be mapped: Front/Back for one horizontal axis, Left/Right for the other, Top/Bottom for Z
- Document which physical feature is at each end (e.g. "front = -X = cable gland end")
- When the user says "move it to the front", consult the map — never assume

**Where labels appear by export mode:**

| Label type | Design | Test | Production |
|-----------|--------|------|------------|
| Axis reference block (separate cube with all 6 labels) | Yes | No | No |
| Base walls: axis + friendly name (e.g. "-X Front") | No | Yes | No |
| Base floor: "-Z Bottom" | No | Yes | No |
| Lid top: "+Z" in corner | No | Yes | No |
| Lid edges: axis + friendly name (e.g. "-X Front") | No | Yes | No |

**On-part label pattern (test mode):**
Each wall/edge shows the axis label and friendly name together. The axis label
is in larger font above, the friendly name in smaller font below.

```python
if EXPORT_MODE == "test":
    dir_labels = {v: k.capitalize() for k, v in ORIENTATION.items()}
    LABEL_DEPTH = 0.6
    LABEL_SIZE = 8
    DIR_LABEL_SIZE = 5

    # Example: +X wall
    px_face = base.faces().sort_by(Axis.X)[-1]
    with BuildSketch(px_face):
        with Locations((0, 4)):
            Text("+X", font_size=LABEL_SIZE, align=(Align.CENTER, Align.CENTER))
    extrude(amount=-LABEL_DEPTH, mode=Mode.SUBTRACT)
    if "+X" in dir_labels:
        with BuildSketch(px_face):
            with Locations((0, -5)):
                Text(dir_labels["+X"], font_size=DIR_LABEL_SIZE,
                     align=(Align.CENTER, Align.CENTER))
        extrude(amount=-LABEL_DEPTH, mode=Mode.SUBTRACT)

    # Lid edges — same pattern, using lid_top face with edge offsets
    # "-X Front" near -X edge, "+Y Right" near +Y edge, etc.
```

## File Output

### Part Version Numbering

Every part large enough to hold readable text should have a **debossed version
number** on a hidden surface. This helps identify which iteration of the design
a printed part came from, especially during iterative test printing.

**Version format:** `vMAJOR.MINOR` (e.g. `v1.0`, `v1.3`, `v2.0`)

**When to increment:**
| Change type | Action | Example |
|-------------|--------|---------|
| New enclosure project | Start at `v1.0` | First design |
| Dimensional change (hole size, position, wall height) | Bump minor: `v1.0` → `v1.1` | Moved LED hole 3mm |
| Added/removed feature | Bump minor | Added USB-C shelf |
| Major redesign (layout change, new bays) | Bump major: `v1.5` → `v2.0` | Reorganized PCB bay |
| Cosmetic-only change (label text, font size) | No bump needed | Changed "FIRE" to "Fire" |

**AI behavior:**
- **When making changes that affect fit or function, always increment the minor
  version and regenerate.** Do this automatically — don't wait for the user to ask.
- When the user says "let's do a test print" or "prep for print", confirm the
  current version in the output so the user knows which version they're printing.
- When multiple changes are made in a session before a print, bump once at the end
  (not once per change).

**Where to place the version:**
- **Base**: inside of a vertical wall (e.g. inside -X wall, near floor corner) — hidden when assembled, no bridging issues
- **Lid**: inside of a vertical edge wall (e.g. inside -X edge) — hidden when lid is on, no bridging issues
- **Small parts** (lenses, buttons, plungers): skip — not enough surface area
- **NEVER on a bed-facing surface** — debossed text on the first layer creates recesses that the second layer must bridge over, causing poor surface quality. Always use a vertical wall instead.
- **Prefer the INSIDE of the enclosure** — version labels are development aids, not cosmetic features. Placing them on interior walls keeps the exterior clean while still being readable when the enclosure is open. Use the exterior only if the user explicitly requests it.

**Implementation:**
```python
# ── Part Version ──
VERSION = "v1.0"

# On base — inside of -X wall, near floor corner (vertical surface)
base_inner_mx_wall = base.faces().sort_by(Axis.X)[0]
with BuildSketch(base_inner_mx_wall):
    with Locations((EXT_W / 2 - 8, -BASE_H / 2 + 5)):
        Text(VERSION, font_size=4, align=(Align.CENTER, Align.CENTER))
extrude(amount=-0.4, mode=Mode.SUBTRACT)

# On lid — inside of -X edge wall (vertical surface)
lid_inner_mx = lid.faces().sort_by(Axis.X)[0]
with BuildSketch(lid_inner_mx):
    with Locations((EXT_W / 2 - 8, 0)):
        Text(VERSION, font_size=4, align=(Align.CENTER, Align.CENTER))
extrude(amount=-0.4, mode=Mode.SUBTRACT)
```

**Rules:**
- Define `VERSION` as a string constant at the top of the script
- Use 4pt font, 0.4mm depth (2 layers) — readable but subtle
- **Always place on a vertical wall, never on a bed-facing surface** — debossed text on the first layer creates bridging problems on the second layer
- **Verify the label does not overlap any hole or cutout on the same wall.** Before choosing a position, check all features on that wall (cable gland, display window, USB-C port, etc.) and confirm the label center is well clear of every hole's bounding circle/rectangle. Place the label in a corner far from any cutouts.
- All parts in the same script share the same version number
- The version is always debossed (into the surface), never multi-color
- Print the version in the build output so the user can confirm before printing

### Axis Reference Block

Every exported STL should include a small **axis reference cube** placed alongside
the part. This 15mm cube has all 6 axis labels (+X, -X, +Y, -Y, +Z, -Z) debossed
on its faces, so when the user opens the STL in a slicer, orientation is immediately
obvious. The user deletes the cube before printing.

The cube also shows a **"BED" label** on whichever face should sit on the build plate.
This tells the user exactly how to orient the part in their slicer without needing
to check documentation.

```python
def make_axis_reference_block(size=15, label_depth=0.5, font_size=6, dir_font_size=3.5,
                              bed_face=None, bed_font_size=4):
    """Create a small cube with axis labels, direction labels, and optional BED indicator.
    bed_face: e.g. "-Z" or "+Z" — which face goes on the build plate."""
    dir_labels = {v: k.capitalize() for k, v in ORIENTATION.items()}
    with BuildPart() as ref:
        Box(size, size, size)
        for axis, signs in [(Axis.X, ("+X", "-X")), (Axis.Y, ("+Y", "-Y")), (Axis.Z, ("+Z", "-Z"))]:
            for idx, label in enumerate(signs):
                face = ref.faces().sort_by(axis)[-1 if idx == 0 else 0]
                # Axis label at top of face
                with BuildSketch(face):
                    with Locations((0, size / 2 - font_size * 0.7)):
                        Text(label, font_size=font_size, align=(Align.CENTER, Align.CENTER))
                extrude(amount=-label_depth, mode=Mode.SUBTRACT)
                # Friendly direction label below axis label
                if label in dir_labels:
                    with BuildSketch(face):
                        with Locations((0, -size / 2 + dir_font_size * 1.2)):
                            Text(dir_labels[label], font_size=dir_font_size,
                                 align=(Align.CENTER, Align.CENTER))
                    extrude(amount=-label_depth, mode=Mode.SUBTRACT)
                # BED indicator — centered on the face that goes on the build plate
                if bed_face and label == bed_face:
                    with BuildSketch(face):
                        Text("BED", font_size=bed_font_size, font_style=FontStyle.BOLD,
                             align=(Align.CENTER, Align.CENTER))
                    extrude(amount=-label_depth, mode=Mode.SUBTRACT)
    return ref.part


def export_with_reference(part, filename, offset_x=0, offset_y=0, offset_z=0,
                          bed_face=None):
    """Export a part as STL with an axis reference block placed alongside it.
    bed_face marks which face goes on the build plate (design mode only)."""
    if EXPORT_MODE == "design":
        ref_block = make_axis_reference_block(bed_face=bed_face)
        ref_block = ref_block.move(Location((offset_x, offset_y, offset_z)))
        combined = Compound(children=[part, ref_block])
        export_stl(combined, filename)
    else:
        export_stl(part, filename)
```

**Placement:** Offset the block 20mm beyond the part's bounding box in +X so it
doesn't overlap. Place its Z so it sits on the same floor plane as the part.

**Usage:**
```python
export_with_reference(base.part, "controller_base.stl",
                      offset_x=EXT_L / 2 + 20, offset_y=0, offset_z=-BASE_H / 2 + 7.5,
                      bed_face="-Z")   # base prints right-side up
export_with_reference(lid.part, "controller_lid.stl",
                      offset_x=EXT_L / 2 + 20, offset_y=0, offset_z=BASE_H + LID_H / 2 + 7.5,
                      bed_face="+Z")   # lid prints face-down
```

### Export Modes: Design / Test / Production

Enclosure development is iterative: design, review in slicer, test print, fit check,
adjust, repeat. The script should support three export modes that control what gets
included in the STL output.

**Add a mode flag at the top of the script:**
```python
# ── Export Mode ──
# "design"     — include axis reference blocks for reviewing orientation on screen
# "test"       — clean STLs, cosmetic parts marked optional
# "production" — clean STLs, no axis labels on parts (final appearance)
EXPORT_MODE = "design"
```

**What each mode does:**
| Feature | Design | Test | Production |
|---------|--------|------|------------|
| Axis reference blocks in STL | Yes | No | No |
| Structural parts (base, lid) | Yes | Yes | Yes |
| Cosmetic-only parts (lenses, text inserts) | Yes | Yes (marked optional) | Yes |
| Axis labels on walls/floor/lid (+X,-X,+Y,-Y,-Z,+Z) | Yes | Yes | **No** |

**CRITICAL: Always regenerate ALL STL files** when switching modes. Never skip
exporting a part — if you skip a cosmetic part, the old file from a previous mode
(with a ref block baked in) remains on disk and the user may accidentally print it.
Instead, always export every part and just note which are optional.

**Cosmetic-only parts** are parts that serve no structural or functional purpose —
they're purely visual. Examples:
- LED lenses (transparent inserts for light pipes)
- Decorative badges or logos (separate color STLs)
- Accent pieces printed in a different material/color

During test prints, cosmetic parts are **optional** (user decides whether to include):
- **Open LED holes let you verify alignment** without printing lenses
- **Saves filament and time** if you skip them on the print plate
- But the STL file is always clean and up-to-date on disk

**Mark cosmetic parts in code:**
```python
# ══════════════════════════════════════════════════════
# LED LENSES — cosmetic only, print in clear filament
# COSMETIC: Optional for test prints. Open holes allow LED alignment check.
# ══════════════════════════════════════════════════════

LENS_H = LID_H - LIP
with BuildPart() as lenses:
    for pos in LED_POSITIONS:
        with Locations((pos[0], pos[1], BASE_H + 5 + LIP / 2)):
            Cylinder(radius=LED_HOLE / 2, height=LENS_H)

print("LED lenses built successfully.")
export_with_reference(lenses.part, "controller_lid_lenses.stl", ...)
if EXPORT_MODE == "test":
    print("Exported: controller_lid_lenses.stl (cosmetic — optional for test prints)")
else:
    print("Exported: controller_lid_lenses.stl")
```

**Use it in the export function:**
```python
def export_with_reference(part, filename, offset_x=0, offset_y=0, offset_z=0):
    """Export STL. In design mode, includes axis reference block alongside the part
    so orientation is obvious when reviewing in a slicer or CAD viewer.
    In test/final mode, exports the part alone."""
    if EXPORT_MODE == "design":
        ref_block = make_axis_reference_block()
        ref_block = ref_block.move(Location((offset_x, offset_y, offset_z)))
        combined = Compound(children=[part, ref_block])
        export_stl(combined, filename)
    else:
        export_stl(part, filename)
```

**Workflow:**
1. Start with `EXPORT_MODE = "design"` while making changes and reviewing in slicer
2. User says "test print" → switch to `"test"`, all STLs clean, cosmetic parts optional
3. User says "production print" or "final print" → switch to `"production"`, axis labels removed
4. After printing, if more changes are needed, switch back to `"design"`

**MANDATORY: Rebuild immediately after every mode switch.**
Changing `EXPORT_MODE` without running the script leaves stale STLs on disk that
don't match the current mode. Every mode change must be followed by running the
script to regenerate all STL files. This is the same as any other script edit —
do not wait for the user to ask.

**Rules:**
- Default to `"design"` for new scripts
- "test print", "quick print", "check fit" → `"test"`
- "production print", "final print", "ready for real" → `"production"`
- Making design changes or reviewing orientation → `"design"`
- When adding a new part, decide: is it structural or cosmetic? Cosmetic parts are always exported but marked optional in test mode

**Axis labels in production mode:**
Wrap all axis label code (base walls, floor, lid) in `if EXPORT_MODE != "production":`.
Axis labels are helpful during design and test fitting but should not appear on the
final product. Note: axis labels are always **debossed** (not multi-color inserts)
since they're development aids, not design features.

```python
# ── Axis labels on each outer wall (debossed for reference) ──
# Skipped in production mode for clean final appearance.
if EXPORT_MODE != "production":
    LABEL_DEPTH = 0.6
    LABEL_SIZE = 8
    # +X, -X, +Y, -Y walls...
    # -Z on floor, +Z on lid...
```

### STL / STEP Export
```python
# STL for 3D printing
export_stl(base.part, "controller_base.stl")
export_stl(lid.part, "controller_lid.stl")

# STEP for further editing in Fusion360/FreeCAD
export_step(base.part, "controller_base.step")

# View in VS Code with OCP CAD Viewer
from ocp_vscode import show
show(base, lid)
```

## Additional References

For detailed examples and verified troubleshooting:

- [Complete Example: Controller Box](./references/complete-example.md) — Full Build123d script with base, lid, standoffs, cutouts, and debossed labels
- [Common Gotchas & Advanced Patterns](./references/gotchas-and-patterns.md) — 19 verified gotchas, captive button plunger pattern, lid screw bosses, rounded alignment lip, and recommended build order

## Reference
- Build123d docs: https://build123d.readthedocs.io/
- Builder mode examples: https://build123d.readthedocs.io/en/latest/introductory_examples.html
- OCP CAD Viewer: https://github.com/bernhard-42/vscode-ocp-cad-viewer
