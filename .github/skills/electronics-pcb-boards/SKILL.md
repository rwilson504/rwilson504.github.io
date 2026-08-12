---
name: electronics-pcb-boards
description: 'Render interactive SVG PCB board layouts for hobbyist breadboards. USE FOR: Adafruit Perma-Proto Full-Sized, Perma-Proto Half-Sized, ElectroCookie 1/4, board coordinate systems, through-hole grids, power rail rendering, copper trace patterns, mounting holes, vertical rotation.'
---

# PCB Board SVG Rendering Skill

## Purpose
Generate interactive SVG renderings of common hobbyist PCB/breadboard layouts for use in HTML documentation pages. These SVGs show the physical board with through-holes, copper traces, power rails, mounting holes, and component placement.

## Shared Coordinate Convention

> **This skill is the source of truth** for all board dimensions and mounting hole positions.
> Other skills (enclosure, components, schematics) reference these values.

All board measurements use this consistent convention:

| Rule | Convention |
|------|-----------|
| **Origin** | Bottom-left corner of the board |
| **Board orientation** | Horizontal (long edge = X axis, short edge = Y axis) |
| **X axis** | Left → Right (along the long edge) |
| **Y axis** | Bottom → Top (along the short edge) |
| **Format** | `(X_from_left_mm, Y_from_bottom_mm)` |
| **Mounting holes** | Listed as `mounting_holes` array with `pos`, `dia`, and `type` per hole |

This convention is used in:
- **This skill** — board specs and SVG coordinate systems
- **electronics-enclosure-3dprint** — Python `pcb_to_center()` functions convert from this to enclosure center-origin
- **electronics-pcb-components** — component placement references row/column which map to these coordinates
- **Python enclosure scripts** — `mounting_holes` arrays use this format directly

When adding a new board, always measure holes from the bottom-left corner with the board horizontal and document using the `mounting_holes` format.

## Supported Boards

### 1. Adafruit Perma-Proto Full-Sized Breadboard
- **Product:** Adafruit #1606
- **Dimensions:** 6.2" × 2" (158 × 51 mm)
- **Grid:** 60 columns (1–60) × 10 rows (A–J) + 4 power rail rows
- **Pitch:** 2.54 mm (0.1") standard spacing
- **Power Rails:** 4 continuous rails along the long edges:
  - Top edge (outside → inside): + rail, − rail
  - Bottom edge (outside → inside): + rail, − rail
  - Both edges have the same order: + outermost, − closest to signal grid
  - Each rail has a full row of 60 through-holes, all electrically connected
- **Connectivity:**
  - Each column has TWO independent 5-hole buses: bottom (A–E) and top (F–J)
  - No connection between columns
  - No connection between bottom and top buses (center gap)
  - No connection between signal grid and power rails
  - Power rails are each a single continuous copper bus
- **Mounting:**
  ```python
  mounting_holes = [
      {"pos": (12, 25.5),  "dia": 3.2, "type": "M3"},  # left
      {"pos": (79, 25.5),  "dia": 3.2, "type": "M3"},  # center
      {"pos": (146, 25.5), "dia": 3.2, "type": "M3"},  # right
  ]
  ```
- **Orientation:** Render VERTICALLY (90° clockwise rotation) — columns flow top-to-bottom, rows flow left-to-right. After rotation, A appears on the LEFT (near the left + rail) and J on the RIGHT (near the right + rail). All text labels counter-rotated to stay upright.

#### SVG Coordinate System (Adafruit)
```javascript
const HS = 26;    // hole spacing in pixels (2.54mm pitch)
const CG = 14;    // extra center gap between rows E and F
const BP = 20;    // board edge padding to nearest hole
const LM = 38;    // SVG margin for labels
const RAIL_HS = HS;
const NUM_LABEL_GAP = 16;

// Grid origin pushed down for top rail rows + number labels
const AF_X0 = LM + BP;
const AF_Y0 = LM + BP + 2 * RAIL_HS + NUM_LABEL_GAP;

// Column → X coordinate
function afx(col) { return AF_X0 + (col - 1) * HS; }

// Row letter → Y coordinate
// Pre-rotation: J at top (small Y), A at bottom (large Y)
// After 90° CW rotation: A on LEFT, J on RIGHT
function afy(row) {
  const i = ROWS_LETTERS.indexOf(row);
  const invI = 9 - i;  // J=0 (top), A=9 (bottom)
  return AF_Y0 + invI * HS + (invI >= 5 ? CG : 0);
}

// Power rail Y positions
// Rendered order left-to-right (after 90° CW rotation): + − A B C D E |gap| F G H I J + −
// Rails are MIRRORED: left side = + outer / − inner, right side = + inner / − outer
// Pre-rotation bottom = LEFT after rotation, pre-rotation top = RIGHT after rotation
const RAIL_BP_Y = afy('A') + NUM_LABEL_GAP + 2 * RAIL_HS; // bottom + (LEFT outer)
const RAIL_BN_Y = afy('A') + NUM_LABEL_GAP + RAIL_HS;     // bottom − (LEFT inner)
const RAIL_TN_Y = AF_Y0 - NUM_LABEL_GAP - 2 * RAIL_HS;    // top − (RIGHT outer)
const RAIL_TP_Y = AF_Y0 - NUM_LABEL_GAP - RAIL_HS;         // top + (RIGHT inner)
```

**Final rendered order (left to right):** `+ − A B C D E |gap| F G H I J + −`

**Important:** The rails are **mirrored** — not identical on both sides:
- Left side (near A): `+` outermost, `−` innermost
- Right side (near J): `+` innermost, `−` outermost

Board height/extent calculations must use `RAIL_BP_Y` (left-side outer + rail, largest Y in pre-rotation coords).

#### Rendering Layers (draw order)
1. PCB substrate (rounded rect, blue-teal fill)
2. Mounting holes (circles at center gap line)
3. Power rail copper strips (colored background rects)
4. Column bus copper traces (vertical strips per column, A-E and F-J)
5. Center gap visual divider
6. Column number labels (between rail rows and signal rows)
7. Row letter labels (A-J on both sides)
8. Rail row labels (+/− on both sides)
9. Power rail through-holes (4 rows × 60 columns)
10. Signal grid through-holes (10 rows × 60 columns)
11. Custom components and wires (drawn by the caller)
12. Text counter-rotation (all `<text>` elements get `transform="rotate(-90 cx cy)"`)
13. Outer 90° CW rotation wrapper (`<g transform="translate(H 0) rotate(90)">`)

### 2. ElectroCookie 1/4 Breadboard
- **Dimensions:** 1.5" × 2" (38.1 × 50.8 mm) — width × height
- **Grid:** 17 rows × 10 columns (A–J)
- **Grid area:** 1.25" × 1.75" (31.8 × 44.5 mm)
- **Pitch:** 2.54 mm
- **Connectivity:** Each row has TWO independent 5-hole buses: left (A–E) and right (F–J)
- **Mounting:**
  ```python
  mounting_holes = [
      {"pos": (3.15, 3.05),  "dia": 2.2, "type": "M2"},  # corner bottom-left
      {"pos": (47.65, 3.05), "dia": 2.2, "type": "M2"},  # corner bottom-right
      {"pos": (3.15, 35.05), "dia": 2.2, "type": "M2"},  # corner top-left
      {"pos": (47.65, 35.05),"dia": 2.2, "type": "M2"},  # corner top-right
      {"pos": (5.1, 19.05),  "dia": 3.2, "type": "M3"},  # center left
      {"pos": (45.7, 19.05), "dia": 3.2, "type": "M3"},  # center right
  ]
  ```
- **Orientation:** Render in STANDARD orientation (columns → X, rows → Y)

#### SVG Coordinate System (ElectroCookie)
```javascript
const EC_COLS = ['A','B','C','D','E','F','G','H','I','J'];
const EC_ROWS = 17;

function ecx(col) {
  const i = EC_COLS.indexOf(col);
  return EC_X0 + i * HS + (i >= 5 ? CG : 0);  // gap between E and F
}
function ecy(row) { return EC_Y0 + (row - 1) * HS; }
```

### 2b. ElectroCookie Full-Sized Solderable Breadboard
- **Dimensions:** 3.5" × 2.05" (88.9 × 52.1 mm)
- **Grid:** 30 rows × 10 columns (A–J)
- **Pitch:** 2.54 mm
- **Grid area:** 3.1" × 1.4" (78.7 × 35.6 mm)
- **Connectivity:** Same as 1/4 size — each row has TWO independent 5-hole buses: left (A–E) and right (F–J), center gap between E and F
- **Mounting:** 6 holes total (measured with calipers):
  ```python
  mounting_holes = [
      {"pos": (3.0, 6.0),   "dia": 2.2, "type": "M2"},  # H1 corner bottom-left
      {"pos": (82.0, 6.0),  "dia": 2.2, "type": "M2"},  # H2 corner bottom-right
      {"pos": (3.0, 43.0),  "dia": 2.2, "type": "M2"},  # H3 corner top-left
      {"pos": (82.0, 43.0), "dia": 2.2, "type": "M2"},  # H4 corner top-right
      {"pos": (6.0, 24.0),  "dia": 3.2, "type": "M3"},  # H5 center left
      {"pos": (80.0, 24.0), "dia": 3.2, "type": "M3"},  # H6 center right
  ]
  ```
- **Power jumper:** Solder jumper near corner to connect power rails (if board has power rails)
- **Orientation:** Render in STANDARD orientation (columns → X, rows → Y)

#### SVG Coordinate System (ElectroCookie Full)
```javascript
const ECF_COLS = ['A','B','C','D','E','F','G','H','I','J'];
const ECF_ROWS = 30;

function ecfx(col) {
  const i = ECF_COLS.indexOf(col);
  return ECF_X0 + i * HS + (i >= 5 ? CG : 0);  // gap between E and F
}
function ecfy(row) { return ECF_Y0 + (row - 1) * HS; }
```

### 3. Adafruit Perma-Proto Half-Sized Breadboard
- **Product:** Adafruit #1609
- **Dimensions:** 3.2" × 2" (82 × 51 mm)
- **Grid:** 30 columns × 10 rows + 4 power rails
- **Note:** Same connectivity pattern as full-sized but with 30 columns. Power rails may have a center break.

## Key SVG Helper Function
All board renderers use this shared element builder:
```javascript
function el(tag, attrs, children) {
  let s = `<${tag}`;
  for (const [k, v] of Object.entries(attrs || {})) s += ` ${k}="${v}"`;
  if (children !== undefined) s += `>${children}</${tag}>`;
  else s += '/>'; 
  return s;
}
```

## Occupied Map Convention
Track which holes are occupied using a string-keyed object:
```javascript
const occupied = {};
// Signal grid: 'ROW,COL' e.g. 'A,1', 'J,15'
occupied['A,7'] = '#3fb950';   // green = terminal block
// Power rails: '+T,COL', '-T,COL', '+B,COL', '-B,COL'
occupied['+B,3'] = '#3fb950';  // bottom + rail, col 3
occupied['-T,26'] = '#58a6ff'; // top − rail, col 26
```

## Design Guidelines
- Use dark theme colors: background #0d1117, board fill #1a5276, copper traces #B8860B
- Occupied holes: bright colors with white stroke. Unoccupied: #30363d with #555 stroke, 0.6 opacity
- Power rails: + = #f85149 (red), − = #58a6ff (blue)
- Always render copper bus traces behind the holes as subtle background indicators
- Label column numbers every 5th column plus column 1
- Show the center gap clearly between the two bus halves

## Safety-First Layout Rules

> **Safety is paramount. A few extra jumper wires are always worth it.**

### Screw terminal physical footprint
- **5.08mm pitch screw terminals block the adjacent column/row/rail.** A 2-position KF301-5.08 terminal solders into one column/row but its body overhangs into the next, making it unusable for components.
- **This applies to ALL screw terminals on any board type:**
  - On **ElectroCookie** boards: terminal in column A blocks column B
  - On **Adafruit Perma-Proto** (signal grid): terminal in row A blocks row B
  - On **Adafruit Perma-Proto** (power rails): terminal on + rail blocks − rail (and vice versa)
- **SVG rendering:** Draw ALL terminal bodies large enough to visually cover the blocked adjacent column/row/rail. Show a "blocked" text label over the blocked area. This must apply to every `afDrawTerminal`, `afDrawRailTerminal`, and `ecDrawTerminal` call — not just some of them.
- **Rule of thumb:** After placing screw terminals, start placing components 2 columns/rows away from the terminal pin position.

### Physical separation of high-risk components
- **Never place a capacitor and diode on the same bus in adjacent columns** if they share rows. Electrolytic capacitor bodies are cylindrical (6–13mm diameter) and overhang into neighboring holes. A cap body touching a diode lead can cause shorts.
- **Use the center gap** (A–E / F–J split) as a physical barrier between components that could short. Place the capacitor on one bus and the diode on the other, with bridge wires to connect them electrically.
- A few extra bridge/jumper wires are always preferable to a short circuit or component failure.

### Inline fuse protection
- **Always include an inline fuse on the V+ path** of any board that has a capacitor. If the cap is installed backwards, the fuse trips instead of the cap exploding.
- Place the fuse **before** the capacitor, diode, and load in the signal path.
- PTC resettable fuses (polyfuses) are preferred — they auto-recover after cooling and don't need replacement.

### Capacitor polarity safeguards
- Mark capacitor polarity prominently in both the documentation AND the SVG diagram with:
  - `+ POS` / `− NEG` labels with color-coded backgrounds (red/blue)
  - "long lead" / "stripe side" physical identification text
  - Stripe band on the SVG cap body near the negative lead
- In assembly instructions, always state the polarity rule and reference the physical indicators
