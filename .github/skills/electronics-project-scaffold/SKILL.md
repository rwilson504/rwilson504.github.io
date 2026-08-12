---
name: electronics-project-scaffold
description: 'Scaffold multi-page electronics project documentation sites. USE FOR: index.html shell with sidebar navigation, shared CSS dark theme, collapsible sections, board overview pages, circuit simulation pages, PCB layout pages, testing pages, parts list, component reference, safety recommendations.'
---

# Electronics Project Scaffold Skill

## Purpose
Scaffold a complete multi-page electronics project documentation site with a persistent left navigation menu, consistent dark theme styling, collapsible sections, and embedded interactive simulations.

## Site Architecture

### Shell Page (`index.html`)
A fixed left sidebar + iframe layout. The sidebar stays visible while content pages load in the iframe.

```
index.html          — Shell: left nav (270px fixed) + <iframe> for content
styles.css          — Shared CSS for all content pages
collapsible.js      — Auto-collapse/expand for .card sections
```

### Navigation Hierarchy
```
Project
  🏠 Project Overview          → home.html

Board 1 — [Name]
  🎛️ [Board] Overview          → board1.html
    ⚡ Circuit & Simulation    → board1_circuit.html
    🔧 PCB Layout              → board1_pcb.html
    🔬 Testing                 → board1_testing.html

Board 2 — [Name]               (repeat for each board)
  🚀 [Board] Overview          → board2.html
    ⚡ Circuit & Simulation    → board2_circuit.html
    🔧 PCB Layout              → board2_pcb.html
    🔬 Testing                 → board2_testing.html

Resources
  🛒 Parts List                → parts_list.html
  🔍 Component Reference       → component_reference.html
  ⚠️ Safety Recommendations    → safety.html
```

### Page Types

#### 1. Project Overview (`home.html`)
- What the project is and why it exists
- System architecture (which boards, what they do)
- How it works (step-by-step operational sequence)
- Power source details
- Key safety features summary
- Navigation guide

#### 2. Board Overview (`board_N.html`)
- What this board does
- Why it's needed (what problems it solves)
- Components on this board (table: Part, Value, Purpose)
- Signal flow through the board
- PCB details summary (board type, terminal assignments)
- "Explore Further" nav cards linking to circuit + PCB subpages

#### 3. Circuit & Simulation (`board_N_circuit.html`)
- SVG circuit schematic (clean, labeled, color-coded by net)
- Signal flow text diagram (ASCII art with colored spans)
- Component theory (what each part does, calculations, formulas)
- Embedded Falstad simulation:
  - `CIRCUIT` constant with Falstad text format
  - "Open in Falstad" button (uses CompressionStream + base64 URL)
  - "Copy Circuit Text" button (clipboard API)
  - Status feedback badges
  - Component map table (Simulator ↔ Real Component)
  - "How to Use" step-by-step guide
  - "Experiments to Try" section
- Fallback import instructions

#### 4. PCB Layout (`board_N_pcb.html`)
- Board reference (dimensions, grid, connectivity rules)
- Interactive SVG board diagram rendered by JavaScript
- Legend (color swatches for each component type)
- **Screw terminal assignments table** — Must include grid coordinates: format each terminal as **TN (row X, cols Y–Z)** for example: **T2 (row A, cols 7–9)** or **T1 (bottom + rail, cols 3–5)**. This allows test point references to be unambiguous.
- On-board components table (Part, Row, Columns, Notes)
- Jumper wires table (ID, From, To, Net)
- External wiring guide table
- Signal flow net trace
- Assembly order (numbered steps, low-profile to tallest)
- Board-specific shopping list

#### 5. Testing (`board_N_testing.html`)
- **Meter setup** — Lead connections, mode selection instructions for the user's specific multimeter (e.g., FNIRSI 2C35T). Document which modes are needed: continuity/buzzer, resistance (Ω), diode test, DC voltage, capacitance.
- **Pre-test checklist** — Disconnect power, disconnect external wiring, confirm meter works.
- **Continuity tests** — Numbered table of probe-point pairs. Follow the signal path from power input through each jumper, bus connection, bridge wire, and rail tap. Each row: test number, probe 1 location, probe 2 location, expected result (beep/OL), what the test confirms.
- **Resistance tests** — Verify component values (resistors). Show expected Ω reading with tolerance range.
- **Diode/LED tests** — Diode mode tests for LEDs and protection diodes. Forward voltage readings, reverse "OL" confirmation, polarity verification.
- **Capacitance tests** — If electrolytics are present, verify capacitance value with tolerance.
- **Short circuit tests** — Critical "must fail" tests. V+ to GND, output+ to output−. Must show OL/no beep. Explain consequences of a short.
- **Powered voltage tests** — After all unpowered tests pass. Measure DC voltage at key nodes with switches in each state (open, ARM on, FIRE pressed). Verify LEDs light, output voltage is correct.
- **Full system test** — End-to-end with both boards connected and load attached.
- **Troubleshooting table** — Common symptoms, likely causes, and how to fix.

Design principles for testing pages:
- **Reference test points using terminal + grid format:** `T4 pin 1 (row A, col 21)` or `T5 screw (top − rail, col 28)`. This is unambiguous and lets users find the exact hole without confusion.
- When referencing intermediate grid holes (not on a terminal), use format: `E1` or `row E, col 1`
- Color-code expected results: green for pass/beep, red for required-fail/OL
- Order tests to follow the signal path — early failures explain later ones
- Include nuances (e.g., diode direction affecting continuity readings)
- Warn about common pitfalls (reversed diode, cold solder joints)
- In multimeter instructions: always specify which screw of the terminal to probe, or which row/column if an intermediate test point

#### 6. Enclosure (`board_N_enclosure.html`)
- **Enclosure overview** — what the box holds, panel-mounted components, key features
- **Dimensions table** — external size, internal size, wall thickness, base/lid height, standoff height
- **STL files table** — filename, description, material for each exported part
- **Print orientation section** — for each STL: which face goes on the build plate, layer height, infill, whether supports are needed. Use a two-column layout (base on left, lid on right) for the main parts.
- **Assembly steps** — numbered sequence with bold first sentence per step
- **BOM table** — printed parts + hardware (screws, heat-set inserts, cable glands)
- **Version info** — current script version (from the Python script's VERSION constant)

Design principles for enclosure pages:
- Always include print orientation for every STL file
- Match orientations to the axis reference block `bed_face` values in the Python script
- Use `.two-col` layout for comparing base vs lid print settings
- Reference the enclosure skill's "Print Orientation per Part" table for standard orientations

#### 7. Parts List (`parts_list.html`)
- Full BOM table: Qty, Component, Spec & Notes

#### 8. Component Reference (`component_reference.html`)
- Visual identification SVGs (resistor color bands, diode markings, etc.)
- Polarity guides with clear labels

#### 9. Safety (`safety.html`)
- Warning and tip boxes for safe operation

## Shared CSS (`styles.css`)
Must include styles for:
- Dark theme (background #0d1117, cards #161b22, text #c9d1d9)
- `.card` sections with `.card h2` and `.card h3`
- Alert boxes: `.warning`, `.tip`, `.info` (and `-box` variants)
- Tables with `.qty` class
- Grid layouts: `.two-col`, `.two-boards`, `.nav-cards`
- PCB-specific: `.board-container`, `.board-svg-wrap`, `.legend-row`, `.net-label`
- Assembly: `.assembly-step`, `.step-num`, `.step-text`
- Simulation: `.btn`, `.btn-primary`, `.btn-secondary`, `.sim-link`, `.status`
- Schematic: `.schematic svg`
- Responsive breakpoints at 700px

## Lessons Learned

### Home page is a landing page, not a digest
Resist the urge to put detailed content on `home.html`. Each piece of detail belongs on
exactly one page; home links to it. Common drift we've fixed:
- **Safety details** repeated on home AND `safety.html` → keep on safety, leave a one-line
  teaser on home with a link.
- **"How It Works" 5-step breakdown** on home, when each circuit page already explains its
  own slice in detail → collapse home's version to a one-sentence summary that points to
  the per-board *Circuit & Simulation* pages.
- **"Navigate the Project" bullet list** mirroring the sidebar nav → delete it. The
  sidebar already does this job. Only keep a navigation card on home if there's no
  persistent sidebar.
- **Board cards** on home with full bulleted component lists → reduce to one-sentence
  summaries. The full list lives on each board's overview page.

**Rule of thumb:** if you can find the same fact on two pages, one of them is wrong
(stale) or one of them is redundant (delete it).

### Single-source-of-truth values across the site
These values get quoted on many pages and drift easily — pick one canonical statement
and link to it instead of restating:
- **Battery voltage** — stated definitively on `parts_list.html` and `home.html` Power
  Source. Other pages reference it.
- **LED size and lid hole diameter** — stated on the parts list and the enclosure page.
  Don't re-derive on the controller overview.
- **Resistor values** — stated on the circuit page (with the I = V/R calculation).
  Other pages reference "R1, R2 (see circuit page)".
- **Component count per board** — stated on the PCB layout page; circuit page references it.

### Sweep checklist when a global value changes
When a value used across the whole project changes (e.g. switching battery from 9 V to
10.5 V, or LED size from 4 mm to 5 mm), grep ALL of these files before declaring done:
1. `home.html` — Power Source / overview text
2. `resources/parts_list.html` — the canonical row
3. `resources/component_reference.html` — if it has a deeper write-up
4. Each `<board>.html` — component table, prose
5. Each `<board>_circuit.html` — schematic SVG label, theory paragraph (calculations!),
   Falstad `CIRCUIT` text constant
6. Each `<board>_pcb.html` — legend, component table
7. Each `<board>_enclosure.html` — panel hole sizes if the part footprint changed
8. Each `<board>_testing.html` — expected voltage / resistance readings

### When two views drift, the PCB usually wins
The physical PCB layout is the build-truth. If the schematic SVG, the Falstad text, the
component table, and the PCB diagram disagree about whether D2 exists or what value R1
is, **the PCB layout is what's actually being built**. Update everything else to match
the PCB, not the other way around. (And then double-check by re-reading the PCB.)

## Collapsible Sections (`collapsible.js`)
Automatically wraps every `.card` with an `<h2>` into a clickable header + collapsible body:
- Chevron indicator (▼ / rotates when collapsed)
- Smooth max-height animation
- All sections open by default
- "Collapse All" / "Expand All" sticky buttons at page top
- Works on any page that includes the script

## File Naming Convention
- Board pages: `board_name.html`, `board_name_circuit.html`, `board_name_pcb.html`
- Use lowercase with underscores
- Keep names descriptive but short

## New Project Checklist
1. Create project folder under the repo root
2. Copy `styles.css` and `collapsible.js` from the template or existing project
3. Create `index.html` shell with sidebar nav
4. Create `home.html` with project overview
5. For each board:
   - Create overview page
   - Create circuit & simulation page (with Falstad embed if applicable)
   - Create PCB layout page (with SVG board renderer)
   - Create testing page (meter setup, continuity/resistance/diode/voltage tests, troubleshooting)
6. Create resource pages (parts list, component reference, safety)
7. All content pages: `<link rel="stylesheet" href="styles.css">` + `<script src="collapsible.js"></script>`

## Reference Project
See `electronics/rocket-launch-controller/` in this repo for a complete working example of this architecture.
