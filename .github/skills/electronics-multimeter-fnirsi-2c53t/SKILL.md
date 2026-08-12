---
name: electronics-multimeter-fnirsi-2c53t
description: 'FNIRSI 2C53T oscilloscope/multimeter/signal generator reference. Use when writing testing instructions, continuity tests, voltage measurements, PCB testing guides, or referencing the 2C53T meter capabilities. USE FOR: controller testing pages, launchpad testing pages, component reference, meter setup instructions, probe connections, measurement procedures.'
---

# FNIRSI 2C53T Oscilloscope & Multimeter Reference

## Resources

- [Interactive Device SVG](./references/fnirsi-2c53t-device.svg) — Clean interactive SVG diagram of the device with named elements for every button, port, and the screen. Add `class="highlight"` to any `<g>` to visually highlight it.
- [Menu Screen SVG](./references/fnirsi-screen-menu.svg) — Home menu carousel showing all 4 functions (Oscilloscope, Multimeter, Signal Generator, Settings). Switchable via `data-selected` attribute.
- [Menu: Oscilloscope](./references/fnirsi-screen-menu-oscilloscope.svg) — Menu with Oscilloscope selected (standalone).
- [Menu: Multimeter](./references/fnirsi-screen-menu-multimeter.svg) — Menu with Multimeter selected (standalone).
- [Menu: Signal Generator](./references/fnirsi-screen-menu-siggen.svg) — Menu with Signal Generator selected (standalone).
- [Menu: Settings](./references/fnirsi-screen-menu-settings.svg) — Menu with Settings selected (standalone).
- [Multimeter Screen SVG](./references/fnirsi-screen-multimeter.svg) — Multimeter display with editable reading, unit, mode label, stats, and mode button highlighting.
- [Oscilloscope Screen SVG](./references/fnirsi-screen-oscilloscope.svg) — Oscilloscope display with editable timebase, measurements, channel settings, and waveform visibility.
- [Settings Screen SVG](./references/fnirsi-screen-settings.svg) — System Settings display with 7 menu items and editable sub-options panel.
- [Signal Generator Screen SVG](./references/fnirsi-screen-siggen.svg) — Signal Generator display with 7 waveform types, preview, and editable frequency/duty/amplitude.
- [Measurement Procedures](./references/measurement-procedures.md) — 11 detailed oscilloscope measurement procedures from the manual (DC voltage, crystal, PWM, mains, ripple, inverter, audio, automotive bus, IR remote, sensors)

### Using the Interactive Device SVG

Embed the SVG in testing/documentation pages to show users exactly which buttons to press and ports to use:

```html
<!-- Embed the device diagram -->
<object id="meter-svg" data="fnirsi-2c53t-device.svg" type="image/svg+xml"
        style="width: 300px;"></object>

<script>
// Highlight specific elements by ID
function highlightMeter(...ids) {
  const svg = document.getElementById('meter-svg').contentDocument;
  svg.querySelectorAll('.highlight').forEach(el => el.classList.remove('highlight'));
  ids.forEach(id => {
    const el = svg.getElementById(id);
    if (el) el.classList.add('highlight');
  });
}

// Example: highlight the VΩ and COM ports for continuity testing
highlightMeter('port-vohm', 'port-com', 'btn-move');
</script>
```

**Element IDs:**

| Category | IDs |
|----------|-----|
| Top ports | `port-ch1`, `port-ch2`, `port-siggen` |
| Screen | `screen` |
| Function buttons | `btn-move`, `btn-select`, `btn-trigger`, `btn-prm` |
| Channel buttons | `btn-ch1`, `btn-ch2` |
| D-pad | `btn-up`, `btn-down`, `btn-left`, `btn-right`, `btn-playpause` |
| Mode buttons | `btn-auto`, `btn-save`, `btn-power`, `btn-menu` |
| Multimeter ports | `port-10a`, `port-ma`, `port-com`, `port-vohm` |

### Screen SVGs

Standalone SVG files that reproduce what the device screen shows in each mode.
Use these alongside the device SVG to illustrate meter setup instructions.

#### Menu Screen — Switchable (`fnirsi-screen-menu.svg`)

Single file with CSS switching via `data-selected` attribute (requires JS for `<object>` embedding):

```html
<object id="menu-screen" data="fnirsi-screen-menu.svg" type="image/svg+xml"
        style="width: 320px;"></object>
<script>
  // Switch to: oscilloscope | multimeter | siggen | settings
  function showMenuPage(mode) {
    const svg = document.getElementById('menu-screen').contentDocument;
    svg.documentElement.setAttribute('data-selected', mode);
  }
  showMenuPage('multimeter');
</script>
```

#### Menu Screens — Individual (for device overlay)

Self-contained SVGs, one per menu selection. Use these for static embedding
or overlaying onto the device SVG screen area without JS:

| File | Shows |
|------|-------|
| `fnirsi-screen-menu-oscilloscope.svg` | Oscilloscope selected |
| `fnirsi-screen-menu-multimeter.svg` | Multimeter selected |
| `fnirsi-screen-menu-siggen.svg` | Signal Generator selected |
| `fnirsi-screen-menu-settings.svg` | Settings selected |

All are 320×240 viewBox matching the device screen dimensions.
To overlay onto the device SVG, embed as an `<image>` at the screen position
(x=42 y=62 width=216 height=210 in the device SVG coordinate space).

#### Multimeter Screen — `fnirsi-screen-multimeter.svg`

Editable multimeter display. See the SVG header comments for full element ID list.

#### Oscilloscope Screen — `fnirsi-screen-oscilloscope.svg`

Editable oscilloscope display. See the SVG header comments for full element ID list.

#### Settings Screen — `fnirsi-screen-settings.svg`

System Settings display with left menu column and right sub-options panel.
7 menu items: Language, Sound and light, Startup on Boot, Auto Shutdown, USB Sharing, About, Factory Reset.
Add `class="setting-active"` to any `setting-*` group to highlight it.
Sub-option labels and check states are editable by ID. See the SVG header for full API.

#### Signal Generator Screen — `fnirsi-screen-siggen.svg`

Signal generator display with waveform list, preview, and 3 parameter rows.
7 waveform types visible: Sine, Square, Sawtooth, Half-wave, Full Wave, Step, Rev Step.
Add `class="wave-active"` to any `wave-*` group to highlight the selected waveform.
Editable parameters: frequency (value + unit), duty cycle, amplitude.
The waveform preview path (`wave-preview`) can be set to any SVG path `d` attribute.

## Device Overview

The FNIRSI 2C53T is a 3-in-1 handheld instrument:
1. **Dual-channel digital oscilloscope** (250MS/s, 50MHz bandwidth)
2. **Digital multimeter** (4.5 digits, 20000 counts, true RMS)
3. **DDS function signal generator** (13 waveforms, up to 50KHz)

- Display: 2.8" 320×240 LCD
- Battery: 3000mAh Li-ion, ~6h standby
- Charging: USB-C (5V/1A)
- Dimensions: 167 × 89 × 35 mm, 300g

## Probe Ports (Top of Device)

| Port | Location | Purpose |
|------|----------|---------|
| CH1 (BNC) | Top-left | Oscilloscope channel 1 |
| CH2 (BNC) | Top-center | Oscilloscope channel 2 |
| Signal Gen | Top-right | Function generator output (3.5mm) |

## Multimeter Ports (Bottom of Device)

| Port | Label | Purpose | Max Rating |
|------|-------|---------|------------|
| Left | **10A** | High current (red lead) | 10A MAX FUSED, 250V MAX |
| Center-left | **mA** | Low current (red lead) | 1A MAX FUSED, 250V MAX |
| Center-right | **COM** | Common/ground (black lead) | — |
| Right | **VΩ⏚** | Voltage/Resistance/Capacitance/Diode/Continuity (red lead) | 600V CAT IV, 1000V CAT III |

## Multimeter Modes & Ranges

### Voltage (V)
- **DC Voltage**: 1.9999V / 19.999V / 199.99V / 1000V — accuracy ±(0.5%+3)
- **AC Voltage**: 1.9999V / 19.999V / 199.99V / 750.0V — accuracy ±(1%+3)

### Current (A/mA)
- **DC Current**: 19.999mA / 199.99mA / 1.9999A / 9.999A — accuracy ±(1.2%+3)
- **AC Current**: 19.999mA / 199.99mA / 1.9999A / 9.999A — accuracy ±(1.5%+3)

### Resistance (Ω)
- 199.99Ω / 1.9999KΩ / 19.999KΩ / 199.99KΩ / 1.9999MΩ / 19.999MΩ
- Accuracy: ±(0.5%+3) for high ranges, ±(2.0%+3) for low ranges

### Capacitance
- 9.999nF / 99.99nF / 999.9nF / 9.999µF / 99.99µF / 999.9µF / 9.999mF / 99.99mF
- Accuracy: ±(2.0%+5), ±(5.0%+20) for mF range

### Other Modes
- **Temperature**: -55~1300°C / -67~2372°F — accuracy ±(2.5%+5)
- **Diode test**: Forward voltage drop measurement
- **Continuity**: Audible beep when circuit is complete
- **Auto mode**: Automatically identifies voltage (AC/DC) and resistance

## Multimeter Key Operations

| Button | Action | Function |
|--------|--------|----------|
| Power | Short press | On/Off |
| MENU | Long press | Home page (function selection) |
| AUTO | Short press | Auto-range measurement |
| ‖▶ | Short press | Data HOLD (freeze reading) |
| MOVE | Short press | Toggle AC/DC, Diode/Continuity |
| ◀ | Short press | Switch range left |
| ▶ | Short press | Switch range right |

## Probe Connection Guide

### For Continuity Testing (most common in PCB testing)
1. Red lead → **VΩ⏚** port (rightmost)
2. Black lead → **COM** port
3. Press **MOVE** to toggle to continuity mode (buzzer icon)
4. Touch probes to two points — beep = connected, no beep = open

### For Resistance Measurement
1. Red lead → **VΩ⏚** port
2. Black lead → **COM** port
3. Press ◀/▶ to select Ω mode and range
4. Touch probes across component (circuit must be de-energized!)

### For DC Voltage Measurement
1. Red lead → **VΩ⏚** port
2. Black lead → **COM** port
3. Select V mode, DC coupling
4. Black probe to ground/negative, red probe to test point

### For Diode Testing
1. Red lead → **VΩ⏚** port
2. Black lead → **COM** port
3. Press **MOVE** to toggle to diode mode
4. Red to anode, black to cathode — should show ~0.5-0.7V for silicon diodes

### For Current Measurement
- **< 1A**: Red lead → **mA** port, Black → **COM**
- **1A–10A**: Red lead → **10A** port, Black → **COM**
- ⚠️ **ALWAYS connect in SERIES** with the circuit
- ⚠️ Exceeding port rating burns the internal fuse

## Oscilloscope Quick Reference

### Key Parameters
- Channels: 2 (independent 50MHz each)
- Sample rate: 250MS/s
- Storage depth: 1Kpts
- Input impedance: 1MΩ
- Time base: 10ns/div – 20s/div
- Vertical sensitivity: 10mV/div – 10V/div (1X probe)
- Max input: ±400V (1X probe)
- Trigger modes: Auto / Normal / Single
- Trigger types: Rising edge / Falling edge
- Display modes: Y-T / Rolling / X-Y
- Coupling: AC / DC

### Probe Settings
| Probe Switch | Oscilloscope Setting | Max Voltage | Use Case |
|---|---|---|---|
| 1X | 1X | 80V peak | Low-voltage signals, audio, logic |
| 10X | 10X | 800V peak | Crystal oscillators, mains, high-V |

**Both probe AND oscilloscope must be set to the same multiplier.**

### Oscilloscope Key Operations
| Button | Action | Function |
|--------|--------|----------|
| AUTO | Short press | Auto-scale waveform |
| AUTO | Long press | Baseline calibration (remove probes first!) |
| ‖▶ | Short press | Run/Stop |
| ‖▶ | Long press | 50% center |
| SAVE | Short press | Screenshot (saves BMP) |
| SAVE | Long press | View saved screenshots |
| CH1 | Short press | Channel 1 settings |
| CH2 | Short press | Channel 2 settings |
| SELECT | Short press | Toggle d-pad function |
| TRIGGER | Short press | Trigger settings |
| PRM | Short press | Parameter selection |
| PRM | Long press | Show/hide measurement parameters |

### Quick Shortcuts (Long Press)
| Button | Goes To |
|--------|---------|
| MOVE | Multimeter |
| SELECT | Oscilloscope |
| TRIGGER | Signal Generator |

## Signal Generator

- Output: 3.5mm jack (top-right of device)
- Channels: 1
- Frequency: 1Hz – 50KHz (1Hz step)
- Amplitude: 0.1 – 3.0V
- 13 waveforms: Sine, Square, Sawtooth, Half-wave, Full-wave, Step, Reverse Step, Exp Rise, Exp Fall, DC, Multi-tone, Sinc Pulse, Lorentz

## Writing Testing Instructions

When writing PCB testing pages for the rocket launch controller project, use this format for each test:

### Meter Setup Block
```
**Meter Setup:**
- Mode: [Continuity / Resistance / DC Voltage / Diode]
- Red lead: VΩ⏚ port
- Black lead: COM port
- [Additional setting notes]
```

### Test Step Format
```
**Test N: [What you're testing]**
1. [Probe placement - be specific about which pad/pin]
2. Expected result: [beep / specific resistance / voltage value]
3. If FAIL: [what to check]
```

### Signal Path Testing Order
When writing continuity tests, follow the signal path:
1. Power input connections first
2. Power distribution (fuses, switches)
3. Signal paths (control lines, data)
4. Ground connections
5. Output connections

### Safety Warnings to Include
- ⚠️ **De-energize before continuity/resistance testing**
- ⚠️ **Never measure resistance on a powered circuit**
- ⚠️ **For voltage tests: verify meter is in voltage mode before connecting to powered circuit**
- ⚠️ **Dual-channel oscilloscope: ground clips MUST be connected together — channels share ground. Connecting to different potentials will short-circuit and destroy the device.**

## Common Measurements for Rocket Launch Controller

### Battery Voltage Check
- Mode: DC Voltage
- Expected: ~12.6V (3S LiPo) or battery nominal voltage
- Probe: red to battery +, black to battery –

### Continuity Through Arming Switch
- Mode: Continuity
- Switch OFF: no beep (open)
- Switch ON: beep (closed)

### LED Forward Voltage
- Mode: Diode test
- Red to anode, black to cathode
- Expected: ~1.8-2.2V (red LED), ~2.0-3.0V (green/blue LED)

### Relay Coil Resistance
- Mode: Resistance (200Ω–2KΩ range)
- Expected: typically 50-200Ω for small signal relays

### Cable Continuity (Launch Pad Cable)
- Mode: Continuity
- Test each conductor end-to-end
- Expected: beep on all conductors, no beep between conductors (no shorts)
