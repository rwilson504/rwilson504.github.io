---
name: electronics-pcb-components
description: 'Draw electronic components on PCB board SVGs with proper polarity and labels. USE FOR: screw terminals, resistors, LEDs with anode/cathode markings, electrolytic capacitors, diodes, jumper wires, bridge wires, rail-tap wires, GND bridges, color conventions.'
---

# PCB Component SVG Drawing Skill

## Purpose
Provide standardized SVG drawing functions for common electronic components placed on PCB boards. These functions generate consistent, visually clear component representations with proper polarity markings, lead indicators, and labels.

## Cross-References
- **Board specs & coordinate convention** → `electronics-pcb-boards/SKILL.md` (source of truth for dimensions, hole positions, coordinate origin)
- **Enclosure standoffs** → `electronics-enclosure-3dprint/SKILL.md` (uses same hole coordinates for 3D-printed standoff placement)
- Components are placed by **row letter + column number** (e.g. "F15") which map to the board's SVG coordinate system via `afx(col)`/`afy(row)` or `ecx(col)`/`ecy(row)` functions defined in the PCB boards skill

## Shared Constants
All component drawings use the same coordinate system as the board they're placed on:
```javascript
const HS = 26;   // hole spacing (px) = 2.54mm pitch
```

Components are placed by specifying the row(s) and column(s) where their leads land. The drawing functions handle body sizing, lead lines, labels, and polarity indicators.

## Component Library

### 1. Screw Terminal Block (2-position, 5.08mm pitch)
**Physical:** 3mm × 4mm per position. Pins span 3 holes (cols N and N+2, body covers N+1).

**Signal grid version** — `afDrawTerminal(row, col1, col2, label, pin1Label, pin2Label)`:
- Body: large green rect (width = col span + 28px, height = 36px)
- Wire entry channel slots at top
- Screw head circles (r=5.5) with cross-slot lines
- Wire entry arrows (dashed lines pointing outward)
- Block label above, pin labels below
- Pin label colors: auto-detected from text ('+' → red, '−' → blue, else white)

**Rail version** — `afDrawRailTerminal(railY, col1, col2, label, pin1Label, pin2Label, color)`:
- Same as above but positioned at a rail Y coordinate instead of a grid row
- Custom color parameter for the terminal body stroke

### 2. Axial Component (Resistor, Fuse, etc.)
**Function:** `afDrawAxial(row, col1, col2, color, label, value)`
- Horizontal component spanning two columns in the same row
- Lead lines from holes to body edges
- Rectangular body with rounded corners (18px tall)
- Component label (bold, colored) and value (gray) centered
- Works for: resistors, PTC fuses, wire-wound components

### 3. LED (4mm through-hole)
**Function:** `afDrawLed(row, col1, col2, color, label, value)`
- Large circular body (r=26px) centered between two lead holes
- Outer glow ring (subtle color at 12% opacity)
- Inner lens ring (color at 20% opacity)
- **Flat cathode edge** — thick white line on the col2 side (mimics real LED flat)
- **"+" crosshair** on anode side, **"−" bar** on cathode side inside body
- **"A+" and "K−"** labels outside the body
- **"long lead" / "short/flat"** text below each lead hole
- Lead hole markers: anode = component color, cathode = gray

### 4. Electrolytic Capacitor
**Function (ElectroCookie vertical):** `ecDrawCap(col, row1, row2, color)`
- Circular body centered between two row positions
- **Negative stripe arcs** on the body (mimics physical stripe marking)
- **"+ POS" badge** (red background) at the positive lead with "long lead" label
- **"− NEG" badge** (blue background) at the negative lead with "stripe side" label
- Component label, capacitance, and voltage rating centered
- Clear polarity indication is critical — electrolytic caps can vent if reversed

### 5. Diode (1N4007 style)
**Function (ElectroCookie vertical):** `ecDrawDiode(col, row1, row2, color)`
- Rectangular body with dark gradient fill
- **Cathode stripe band** — light gray/silver rect at the cathode end
- **"K" (cathode)** and **"A" (anode)** labels on each side
- For flyback diodes: cathode stripe faces V+ (reverse-biased during normal operation)

### 6. Jumper Wire
**Horizontal:** `afDrawJumper(row, cols, color, label)` — dashed line connecting multiple columns
**Vertical (ElectroCookie):** `ecDrawJumper(col, rows, color, label)` — dashed line connecting multiple rows
- Dashed line (4,3 pattern) with endpoint dots
- Label centered along the wire
- Color-coded per net (orange for signal, blue for GND, purple for bridge)

### 7. Bridge Wire (Center Gap Crossing)
**Function:** `afDrawBridge(row1, row2, col, color, label)`
- Vertical dashed line crossing the E-F center gap within one column
- Endpoint dots at both rows
- Label offset to the side
- Used to connect bottom bus (A-E) to top bus (F-J)

### 8. Rail-Tap Wire
**Function:** `afDrawRailTap(gridRow, col, railY, label)`
- Dashed line from a grid hole to a power rail hole
- Endpoint dots at both ends
- Label along the wire
- Used to connect signal grid to power rails (GND or V+)

### 9. GND Bridge Wire
**Function:** `afDrawGndBridge(col, label)`
- Vertical dashed line connecting the top − rail to the bottom − rail
- Spans the full board width (through all signal rows)
- Endpoint dots on both rail holes
- Label along the wire

## Color Conventions
| Net/Purpose | Color | Hex |
|---|---|---|
| V+ / Power | Red | `#f85149` |
| GND | Blue | `#58a6ff` |
| Signal (ARM) | Yellow | `#e3b341` |
| Signal (general) | Orange | `#f0883e` |
| Bridge wire | Purple | `#bc8cff` |
| Green LED / Armed | Green | `#3fb950` |
| Red LED / Fire | Red | `#f85149` |
| Terminal block | Green | `#3fb950` |
| Component body | Dark gray | `#21262d` |
| Lead wire | Light gray | `#aaa` |
| Unoccupied hole | Dark gray | `#30363d` |

## Design Rules
1. **Polarity must be unmistakable** — LEDs show A+/K−, flat edge, and lead labels. Capacitors show + POS/− NEG badges. Diodes show cathode stripe.
2. **Components must not overlap** — check physical body sizes against the grid. 4mm LEDs need ≥2 columns of clearance from adjacent components.
3. **Terminal blocks are large** — 36px tall bodies. Account for their size when placing near jumper wires.
4. **Color-code by net** — use consistent colors throughout. Jumpers and wires carrying the same signal should use the same color.
5. **Labels should be readable** — font sizes 6-10px. Place labels where they won't overlap component bodies.
