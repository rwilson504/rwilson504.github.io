---
name: electronics-circuit-schematics
description: 'Generate SVG circuit schematics for electronics documentation. USE FOR: drawing circuit diagrams, schematic symbols (battery, resistor, LED, switch, diode, capacitor, inductor), net labels, color-coded wiring, signal flow diagrams, board boundary lines.'
---

# Electronics Circuit Schematic SVG Skill

## Purpose
Generate clean, color-coded SVG circuit schematics for electronics documentation pages. These schematics show the logical circuit design with proper symbols, net labels, signal flow, and component values — distinct from the physical PCB layout view.

## SVG Canvas Setup
```html
<div class="card schematic">
  <h2>Circuit Schematic</h2>
  <svg viewBox="0 0 WIDTH HEIGHT" xmlns="http://www.w3.org/2000/svg"
       style="width:100%;height:auto;display:block;margin:16px 0;background:#0d1117;border-radius:8px;">
    <!-- components here -->
  </svg>
</div>
```
Typical viewBox sizes:
- Simple circuit (one board): `0 0 700 300` to `0 0 900 400`
- Full system (two boards): `0 0 900 510`

## Component Symbol Library

### Battery / Voltage Source
```svg
<rect x="X" y="Y" width="70" height="120" rx="6" fill="#21262d" stroke="#f85149" stroke-width="1.5"/>
<!-- Cell plates (long=+, short=−) -->
<line x1="X+8" y1="Y+27" x2="X+62" y2="Y+27" stroke="#f85149" stroke-width="4"/>   <!-- + -->
<line x1="X+13" y1="Y+41" x2="X+57" y2="Y+41" stroke="#8b949e" stroke-width="1.5"/> <!-- − -->
<!-- Labels -->
<text x="CX" y="..." text-anchor="middle" fill="#f85149" font-size="12" font-weight="bold">+</text>
<text x="CX" y="..." text-anchor="middle" fill="#58a6ff" font-size="12" font-weight="bold">−</text>
<text x="CX" y="..." text-anchor="middle" fill="#c9d1d9" font-size="8.5" font-weight="bold">9V</text>
```

### Fuse
```svg
<rect x="X" y="Y" width="55" height="26" rx="4" fill="#21262d" stroke="#f85149" stroke-width="1.5"/>
<text x="CX" y="CY" text-anchor="middle" fill="#f85149" font-size="9" font-weight="bold">F1 2A</text>
```

### Toggle Switch (SPST — ARM switch)
```svg
<!-- Fixed contacts -->
<circle cx="X1" cy="Y" r="4" fill="#e3b341"/>
<circle cx="X2" cy="Y" r="4" fill="#e3b341"/>
<!-- Lever (open position — angled line) -->
<line x1="X1" y1="Y" x2="X2-7" y2="Y-20" stroke="#e3b341" stroke-width="2"/>
<!-- Label -->
<text x="MID" y="Y-28" text-anchor="middle" fill="#e3b341" font-size="9" font-weight="bold">SW1 ARM</text>
<text x="MID" y="Y+23" text-anchor="middle" fill="#3fb950" font-size="8">(via T2)</text>
```

### Momentary Pushbutton (SPST-NO — FIRE button)
```svg
<!-- Contact posts -->
<line x1="X1" y1="Y-11" x2="X1" y2="Y+13" stroke="#c9d1d9" stroke-width="2.5"/>
<line x1="X2" y1="Y-11" x2="X2" y2="Y+13" stroke="#c9d1d9" stroke-width="2.5"/>
<!-- Actuator stem (dashed) -->
<line x1="MID" y1="Y-30" x2="MID" y2="Y-13" stroke="#c9d1d9" stroke-width="2" stroke-dasharray="3,2"/>
<!-- Button cap -->
<rect x="MID-23" y="Y-48" width="46" height="19" rx="5" fill="#21262d" stroke="#c9d1d9" stroke-width="1.5"/>
<text x="MID" y="Y-35" text-anchor="middle" fill="#c9d1d9" font-size="10" font-weight="bold">FIRE</text>
```

### Resistor
```svg
<rect x="X" y="Y" width="30" height="40" rx="4" fill="#21262d" stroke="COLOR" stroke-width="1.5"/>
<text x="CX" y="CY" text-anchor="middle" fill="COLOR" font-size="9" font-weight="bold">R1</text>
<text x="CX" y="CY+12" text-anchor="middle" fill="#8b949e" font-size="8">560Ω</text>
```

### LED Symbol
```svg
<!-- Triangle (anode at top, cathode bar at bottom) -->
<polygon points="X-15,Y X+15,Y X,Y+43" fill="COLOR" opacity="0.7"/>
<!-- Cathode bar -->
<line x1="X-15" y1="Y+43" x2="X+15" y2="Y+43" stroke="COLOR" stroke-width="2.5"/>
<!-- Light emission arrows -->
<line x1="X+18" y1="Y+15" x2="X+33" y2="Y" stroke="COLOR" stroke-width="1.5"/>
<polygon points="X+33,Y X+25,Y+4 X+29,Y+11" fill="COLOR"/>
<!-- Label -->
<text x="X" y="Y+67" text-anchor="middle" fill="COLOR" font-size="9" font-weight="bold">LED1</text>
```

### Inductor / Solenoid (in a box)
```svg
<rect x="X" y="Y" width="64" height="168" rx="7" fill="#21262d" stroke="#58a6ff" stroke-width="1.5"/>
<!-- Coil bumps (5 rows of wave patterns) -->
<path d="M X+11,Y+25 Q X+16,Y+17 X+21,Y+25 ..." fill="none" stroke="#58a6ff" stroke-width="1.5"/>
<!-- Label -->
<text x="CX" y="..." text-anchor="middle" fill="#58a6ff" font-size="9.5" font-weight="bold">SOLENOID</text>
```

### Capacitor (schematic symbol)
```svg
<!-- Plates (two parallel lines with gap) -->
<line x1="X-18" y1="Y" x2="X+18" y2="Y" stroke="#c9d1d9" stroke-width="3.5"/>
<line x1="X-18" y1="Y+13" x2="X+18" y2="Y+13" stroke="#c9d1d9" stroke-width="3.5"/>
<!-- + marker -->
<text x="X+22" y="Y+5" fill="#c9d1d9" font-size="11" font-weight="bold">+</text>
<!-- Label -->
<text x="X" y="Y-15" text-anchor="middle" fill="#c9d1d9" font-size="9" font-weight="bold">C1</text>
<text x="X" y="Y-5" text-anchor="middle" fill="#8b949e" font-size="8.5">100µF 50V</text>
```

### Diode (triangle + bar)
```svg
<!-- Triangle (anode to cathode direction) -->
<polygon points="X-16,YBOT X+16,YBOT X,YTOP" fill="#f0883e" opacity="0.85"/>
<!-- Cathode bar -->
<line x1="X-16" y1="YTOP" x2="X+16" y2="YTOP" stroke="#f0883e" stroke-width="3"/>
<!-- Labels -->
<text x="X+32" y="YTOP+8" fill="#f0883e" font-size="9">K (−)</text>
<text x="X+32" y="YBOT+8" fill="#f0883e" font-size="9">A (+)</text>
```

### Connector / Terminal Block (off-board link)
```svg
<rect x="X" y="Y" width="75" height="50" rx="6" fill="#21262d" 
      stroke="#3fb950" stroke-width="1.5" stroke-dasharray="4,3"/>
<text x="CX" y="CY" text-anchor="middle" fill="#3fb950" font-size="9" font-weight="bold">T1</text>
<text x="CX" y="CY+15" text-anchor="middle" fill="#8b949e" font-size="8">→ Launch Pad</text>
```

### Junction Node (wire split point)
```svg
<circle cx="X" cy="Y" r="5" fill="COLOR"/>
```

## Wiring Conventions

### Wire Colors by Net
| Net | Color | Hex | Stroke Width |
|-----|-------|-----|-------------|
| V+ / Power rail | Red | `#f85149` | 2–2.5 |
| GND rail | Blue | `#58a6ff` | 2–2.5 |
| ARM switch signal | Yellow | `#e3b341` | 2 |
| FIRE button signal | Light gray | `#c9d1d9` | 2 |
| LED branch | Component color | varies | 1.5 |
| Flyback diode path | Orange | `#f0883e` | 2 |
| Inter-board cable | Gray dashed | `#484f58` | 1.5 |

### Net Labels
Place labels along wires to show signal names:
```svg
<text x="X" y="Y-10" text-anchor="middle" fill="COLOR" font-size="8">V_FUSED</text>
```

Common net names: `V+`, `V_FUSED`, `NODE_A`, `NODE_B`, `FIRE_OUT`, `FIRE_RET`, `OUT+`, `OUT−`, `GND`, `V_PAD`, `GND_PAD`

### Board Boundary
For multi-board schematics, draw a dashed vertical line separating boards:
```svg
<line x1="X" y1="TOP" x2="X" y2="BOT" stroke="#484f58" stroke-width="1.5" stroke-dasharray="6,4"/>
<text x="LEFT_MID" y="TOP-10" text-anchor="middle" fill="#555e6b" font-size="9.5" font-weight="bold">◀  CONTROL BOX</text>
<text x="RIGHT_MID" y="TOP-10" text-anchor="middle" fill="#555e6b" font-size="9.5" font-weight="bold">LAUNCH PAD  ▶</text>
<text x="X" y="BOT+12" text-anchor="middle" fill="#484f58" font-size="8.5">— 18 AWG 2-wire cable —</text>
```

## Layout Strategy

### Signal Flow Direction
- Main signal flows **left to right** (battery on left, output on right)
- Ground rail runs along the **bottom** as a horizontal bus
- V+ rail runs along the **top**
- Branch circuits drop **downward** (resistor → LED → GND)

## Lessons Learned

### Schematic must match the PCB — every component, every value
The schematic SVG and the PCB layout page are two views of the **same circuit**. They drift
out of sync silently because nothing forces them to agree.

**Whenever you add or remove a component on a PCB page, immediately audit the matching
schematic page** — and vice versa. Common drift cases we've hit:
- Added a flyback diode (D2) to the controller PCB → forgot to draw it on the schematic SVG
- Added a 2A PTC fuse (F1) to the launchpad PCB → forgot to add it to the launchpad schematic SVG
- Changed LED current-limiting resistors from 470Ω to 560Ω on the PCB → schematic still showed 470Ω

**Audit checklist when changing one view:**
1. Component count matches between schematic and PCB legend/component table?
2. Every component value (Ω, µF, V, part number) identical in both?
3. Net labels (V+, GND, OUT+, NODE_A) consistent?
4. Polarity-sensitive parts (diodes, electrolytics, LEDs) drawn with the same orientation?
5. The Falstad `CIRCUIT` text on the same page — does it still match? (see
   `electronics-falstad-simulation` lessons)

### Component values are quoted in many places — sweep them all
The same value (battery voltage, resistor value, LED size) often appears in:
- Parts list table
- Project overview "Power Source" callout
- Board overview component table
- Circuit schematic SVG (label text)
- Circuit theory paragraph (calculations like `I = V/R`)
- Falstad `CIRCUIT` text constant
- Enclosure script (panel hole size for LED, button, etc.)
- Testing page expected readings

When a value changes, **grep the entire project for the old value** before declaring done.
E.g. when battery voltage went 9 V → 10.5 V, we had to touch ~7 files.

### Spacing Guidelines
- Components: minimum 60px apart horizontally
- Vertical branches: 40-60px wide
- GND rail: keep at a consistent Y coordinate (e.g. y=340 or y=448)
- Switches: 80-100px between contacts for clickability labels
- LED branches: 120-180px total height (wire + R + wire + LED + wire to GND)

### Legend (optional, at bottom of SVG)
```svg
<rect x="0" y="BOTTOM" width="FULL_WIDTH" height="46" fill="#0d1117"/>
<text x="30" y="Y" fill="#8b949e" font-size="10" font-weight="bold">Legend:</text>
<line x1="82" y1="Y-3" x2="112" y2="Y-3" stroke="#f85149" stroke-width="2.5"/>
<text x="116" y="Y" fill="#f85149" font-size="10">+V / Power</text>
<!-- ... repeat for each color/net ... -->
```

## Design Principles
1. **Color = net identity** — every wire segment uses the color of its signal net, making signal tracing visual
2. **Labels everywhere** — every node, component, and connector should be labeled
3. **Clean routing** — use right angles only, no diagonal wires except switch levers
4. **Show polarity** — capacitors get +, diodes get K/A labels, LEDs show emission arrows
5. **Off-board = dashed** — connectors to external components use dashed borders
6. **Dark background** — all schematics render on `#0d1117` background for consistency

## Reference Implementation
See `electronics/rocket-launch-controller/controller_circuit.html` and `electronics/rocket-launch-controller/launchpad_circuit.html` for complete working examples of embedded SVG schematics.
