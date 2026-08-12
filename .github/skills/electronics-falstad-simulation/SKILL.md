---
name: electronics-falstad-simulation
description: 'Embed interactive Falstad CircuitJS1 simulations in HTML pages. USE FOR: creating circuit text files, Open in Falstad buttons, CompressionStream base64 URL encoding, copy-to-clipboard, component mapping tables, simulation usage guides, experiment suggestions.'
---

# Falstad Circuit Simulation Embedding Skill

## Purpose
Embed interactive Falstad CircuitJS1 simulations directly into HTML documentation pages. Users can open the simulation in their browser or copy the circuit text for manual import — no external files needed.

## Falstad Circuit Text Format

Each line in the circuit text defines one component:
```
type x1 y1 x2 y2 flags [values...]
```
Components connect when they share endpoint coordinates. All coordinates are on a 16px grid.

### Component Codes
| Code | Component | Value Parameters |
|------|-----------|-----------------|
| `$` | Simulation config | timestep, speed, voltageRange, currentRange, ... |
| `v` | Voltage source (DC) | waveform(0=DC) freq maxVoltage bias phase duty |
| `r` | Resistor | resistance (Ω) |
| `s` | Switch (SPST) | position(0=open,1=closed) momentary(true/false) |
| `l` | Inductor | inductance (H) initialCurrent (A) |
| `c` | Capacitor | capacitance (F) initialVoltage (V) |
| `d` | Diode | model ("default" = silicon, "zener", etc.) |
| `162` | LED | fwdVoltage colorR colorG colorB brightness |
| `w` | Wire | (none) |

### Example: Simple LED Circuit
```
$ 1 0.000005 10.20027730826997 50 5 43 5e-11
v 96 432 96 144 0 0 40 9 0 0 0.5
r 96 144 240 144 0 470
162 240 144 240 432 2 default 0 0 0.8 0
w 240 432 96 432 0
```

### Modeling Components Without Direct Equivalents
- **PTC Fuse** → use a very small resistor: `r x1 y1 x2 y2 0 0.01`
- **Solenoid valve** → inductor + series resistor: `l ... 0 0.1 0` (100mH) + `r ... 0 24` (24Ω)
- **Momentary button** → switch with `true` flag: `s x1 y1 x2 y2 0 1 true`
- **Toggle switch** → switch with `false` flag: `s x1 y1 x2 y2 0 1 false`

### LED Color Parameter
The LED type `162` uses RGB float values (0.0–1.0):
- Green: `0 0 0.8 0` → R=0, G=0.8, B=0
- Red: `0 0.8 0 0` → R=0.8, G=0, B=0
- Blue: `0 0 0 0.8` → R=0, G=0, B=0.8

## Embedding Pattern

### HTML Structure
```html
<div class="card">
  <h2>Interactive Simulation — Falstad</h2>
  <p>Click the button below to open the full circuit in your browser.</p>

  <div class="btn-row">
    <button class="btn btn-primary" onclick="openInFalstad()">
      ▶ Open Circuit in Falstad
    </button>
    <button class="btn btn-secondary" onclick="copyCircuit()">
      📋 Copy Circuit Text
    </button>
    <span class="status" id="status"></span>
  </div>

  <div class="info">
    <strong>How it works:</strong> The button compresses the circuit and opens it
    in Falstad CircuitJS1. If that doesn't work, use <strong>Copy</strong> then go to
    <a href="https://www.falstad.com/circuit/circuitjs.html" target="_blank">
    falstad.com/circuit</a> → File → Import From Text → paste → Import.
  </div>
</div>
```

### JavaScript (place before `</body>`)
```javascript
<script>
const CIRCUIT = `$ 1 0.000005 10.20027730826997 50 5 43 5e-11
v 96 432 96 144 0 0 40 9 0 0 0.5
... (your circuit lines here)
`;

function showStatus(msg, ok) {
  const el = document.getElementById('status');
  el.textContent = msg;
  el.className = 'status show ' + (ok ? 'status-ok' : 'status-err');
  setTimeout(() => el.classList.remove('show'), 2500);
}

async function copyCircuit() {
  try {
    await navigator.clipboard.writeText(CIRCUIT);
    showStatus('Copied!', true);
  } catch {
    const ta = document.createElement('textarea');
    ta.value = CIRCUIT;
    ta.style.cssText = 'position:fixed;left:-9999px';
    document.body.appendChild(ta);
    ta.select();
    document.execCommand('copy');
    document.body.removeChild(ta);
    showStatus('Copied!', true);
  }
}

async function openInFalstad() {
  try {
    const encoded = new TextEncoder().encode(CIRCUIT);
    const cs = new CompressionStream('deflate-raw');
    const writer = cs.writable.getWriter();
    writer.write(encoded);
    writer.close();
    const reader = cs.readable.getReader();
    const chunks = [];
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      chunks.push(value);
    }
    const totalLen = chunks.reduce((a, c) => a + c.length, 0);
    const compressed = new Uint8Array(totalLen);
    let offset = 0;
    for (const chunk of chunks) {
      compressed.set(chunk, offset);
      offset += chunk.length;
    }
    let b64 = '';
    for (let i = 0; i < compressed.length; i++) {
      b64 += String.fromCharCode(compressed[i]);
    }
    b64 = btoa(b64);
    const url = 'https://www.falstad.com/circuit/circuitjs.html?ctz=' + encodeURIComponent(b64);
    window.open(url, '_blank', 'noopener');
    showStatus('Opened!', true);
  } catch (e) {
    console.error('Compression failed:', e);
    await copyCircuit();
    window.open('https://www.falstad.com/circuit/circuitjs.html', '_blank', 'noopener');
    showStatus('Copied — paste via File → Import', false);
  }
}
</script>
```

### Key Technical Notes
- **CompressionStream API** — used to deflate-raw compress the circuit text, then base64 encode for the `?ctz=` URL parameter. This is the same format Falstad uses internally.
- **Fallback** — if CompressionStream is unavailable (older browsers), copies the text to clipboard and opens a blank Falstad window for manual paste.
- **No external dependencies** — everything is self-contained in the HTML page.

## Supporting Content to Include

### Component Map Table
Map Falstad elements to real components so users understand the simulation:
```html
<table>
  <tr><th>Simulator Element</th><th>Real Component</th><th>Falstad Type</th><th>Value</th></tr>
  <tr><td>Voltage Source</td><td>Battery pack</td><td>v (DC)</td><td>9V</td></tr>
  ...
</table>
```

## Lessons Learned

### The `CIRCUIT` constant is the easiest thing to forget
When you change a component value (battery voltage, resistor) anywhere on a circuit page,
the Falstad `CIRCUIT` text literal almost always needs the matching edit — and it's the
last thing anyone remembers because it looks like opaque data, not text.

**Always grep for the Falstad `CIRCUIT` constant when changing component values:**
- Battery voltage lives in the `v` line: `v X1 Y1 X2 Y2 0 0 40 <VOLTS> 0 0 0.5`
- Resistor values live in `r` lines: `r X1 Y1 X2 Y2 0 <OHMS>`
- Inductor in `l` lines: `l ... 0 <HENRIES> 0`
- Capacitor in `c` lines: `c ... 0 <FARADS> 0`

**Real cases we hit:**
- Battery 9 V → 10.5 V across the project: forgot the `v` line
- LED resistors 470 Ω → 560 Ω: forgot both `r` lines

### One Falstad circuit can serve multiple pages
A full end-to-end simulation (controller + launch pad combined) is often the most useful,
even on a launch-pad-only documentation page — because flyback behavior only makes sense
with the full driver chain. Don't trim the Falstad text just to match the SVG schematic
on the same page; the SVG can be board-scoped while the simulation stays whole-system.
Just call out the difference in the page copy.

### Keep `CIRCUIT` literally identical across pages that share it
If two pages embed the same Falstad circuit (e.g. controller_circuit.html and
launchpad_circuit.html both showing the full system), the `CIRCUIT` constant must be
**byte-for-byte identical**. Edit both at once when changing values.

### "How to Use" Steps
1. ARM the system (click toggle switch)
2. FIRE (click momentary switch, hold mouse)
3. Watch flyback (release FIRE, observe diode conduct)
4. Add scope (right-click → View in New Scope)
5. Experiment (change values, remove components)

### "Experiments to Try"
- Remove the flyback diode → see hundreds-of-volts spike
- Change supply voltage → observe current changes
- Change resistor values → see LED brightness change
- Remove capacitor → see slower solenoid response
- Reverse the diode → see it short the circuit

## Circuit Design Tips
- Place components on a 16px grid for clean routing
- Use horizontal wires for main signal paths
- Branch vertically for LED/indicator branches
- Keep GND rail at the bottom (large y values)
- Keep V+ rail at the top (small y values)
- Space switches apart so they're clickable without overlap
- Include the simulation parameters line (`$`) as the first line
