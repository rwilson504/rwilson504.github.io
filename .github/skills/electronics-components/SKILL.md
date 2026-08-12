---
name: electronics-components
description: 'Practical electronics component knowledge: selection, protection circuits, failure modes, and lessons learned from real builds. USE FOR: solenoid flyback protection, back-EMF, diode selection, fuse sizing, capacitor polarity, LED breakdown, battery selection, inductive loads, component protection, circuit safety.'
---

# Electronics Components — Practical Knowledge

## Purpose
Capture practical, hard-won knowledge about electronic components used in hobbyist
through-hole projects. This is the **circuit design** companion to
`electronics-pcb-components` (which covers SVG rendering). Use this skill when
selecting components, designing protection circuits, diagnosing failures, or
advising on best practices for real-world builds.

## Cross-References
- **SVG drawing** → `electronics-pcb-components/SKILL.md` (how to render these components on board diagrams)
- **Board specs** → `electronics-pcb-boards/SKILL.md` (physical board dimensions and layout rules)
- **Schematics** → `electronics-circuit-schematics/SKILL.md` (schematic symbol conventions)

---

## 1. Inductive Loads (Solenoids, Relays, Motors)

### How Back-EMF Works
When current through an inductor is suddenly interrupted (switch opens), the
collapsing magnetic field generates a **voltage spike** in the opposite polarity.
This spike can be **hundreds of volts** — far exceeding the supply voltage — and
it travels back through the wiring to every component in the circuit.

### Flyback Diode Protection
A **flyback diode** (aka snubber diode, freewheeling diode) is placed **across the
inductive load in reverse bias**:
- **Cathode** → V+ side of the load
- **Anode** → GND side of the load

During normal operation, the diode is reverse-biased and does nothing. When the
switch opens, the back-EMF forward-biases the diode, providing a safe current
path for the collapsing field to dissipate through.

**Recommended diode:** 1N4007 (1A, 1000V) — cheap, handles most hobby solenoids.
For faster-switching loads or PWM, consider a Schottky diode (1N5819) for lower
forward voltage drop.

### Lesson Learned: Dual Flyback Protection for Remote Loads

> **Project: Rocket Launch Controller**
>
> A solenoid on the launchpad was connected to the controller via a long cable.
> D1 (flyback diode) was placed across the solenoid on the launchpad board.
> Despite this, the orange FIRE LED on the **controller** board kept burning out.
>
> **Root cause:** The back-EMF spike from the solenoid traveled up the cable
> before D1 could fully clamp it. The spike appeared across the controller's
> output terminals and reverse-biased LED2 beyond its ~5V breakdown voltage,
> destroying it.
>
> **Fix:** Added D2 (a second 1N4007) on the **controller board** across the
> output terminal (T4), cathode toward V+. This provides local clamping at the
> controller end, protecting LED2 regardless of cable length or D1's response
> time.

**Rule: When an inductive load is physically separated from the control
electronics (connected by cable), place flyback diodes at BOTH ends:**
1. **At the load** — catches most of the energy close to the source
2. **At the controller** — catches residual spikes that travel through the cable

### Lesson Learned: Intermittent Fire = Connection, Not Power

> **Project: Rocket Launch Controller**
>
> User reported "works the first time, then takes 5–10 button presses to fire" at
> elevated air pressure. We initially blamed the power supply (under-voltage PD
> trigger vs. solenoid coil). Real cause turned out to be a combination of a
> **reversed flyback diode** and an **intermittent screw-terminal connection**.

**Diagnostic rule:** When a DC load (solenoid, relay, motor) fires *reliably
sometimes* at the **same** supply voltage, suspect intermittent contact first —
loose screw terminal, cold solder joint, broken strand, oxidized contact. True
power starvation is **consistent** across firings, not random. Order of triage:

1. Wiggle every screw terminal and connector while the load is active
2. Re-seat / re-tighten suspect terminals (stranded wire creeps over time)
3. Check diode-mode reading on each protection diode (see next lesson)
4. Only THEN measure voltage at the load under load

### Lesson Learned: Reverse-Polarity Flyback Diode = Supply Crowbar

> **Project: Rocket Launch Controller**
>
> A flyback diode installed backwards across an inductive load is a **dead
> short across the supply** every time the load is energized — the diode is
> now forward-biased through the coil. Symptoms mimic supply sag: the first
> press fires (cap is full), the supply collapses, then the next several
> presses fail until the supply recovers and the diode cools down.

**Always verify flyback orientation before powering on:**
- 1N4007 stripe (cathode) → V+ side of the coil
- Plain end (anode) → GND side of the coil
- Diode-mode test: ~0.55 V one direction, OL the other. A shorted-and-reversed
  1N4007 may partially survive; replace any flyback that's been run backwards
  even briefly.

### Solenoid Sizing
- Measure coil resistance with a multimeter (expect 5–50Ω for 12V hobby valves)
- Calculate steady-state current: `I = V / R` (e.g., 12V / 7.57Ω = 1.6A)
- Ensure your power source can sustain that current without tripping protection
- Ensure your wiring and switch contacts are rated for the current

---

## 2. Diodes

### 1N4007 (General Purpose / Flyback)
- **Ratings:** 1A forward, 1000V reverse
- **Use for:** Flyback protection, reverse polarity protection, general rectification
- **Orientation:** Cathode stripe faces V+ for flyback applications (reverse-biased
  during normal operation, forward-biased during back-EMF spikes)
- **Cathode identification:** Silver/gray band printed on one end of the body

### Zener Diodes (Voltage Clamping)
- Used to clamp voltage at a specific level (e.g., 5.1V Zener across an LED)
- Connected in **reverse bias** — conducts when voltage exceeds the Zener rating
- Alternative to flyback diodes when you want to clamp to a specific voltage

### Diode Rule of Thumb
Always orient with purpose:
- **Flyback:** Cathode toward V+, anode toward GND (across the inductive load)
- **Reverse polarity protection:** In series with V+ (cathode toward load)
- **Voltage clamping (Zener):** Cathode toward V+, anode toward GND (in parallel)

---

## 3. LEDs

### Forward Voltage & Current
| Color | Typical Vf | Typical If |
|-------|-----------|-----------|
| Red | 1.8–2.2V | 20mA |
| Orange/Amber | 2.0–2.2V | 20mA |
| Yellow | 2.0–2.2V | 20mA |
| Green | 2.0–3.5V | 20mA |
| Blue | 3.0–3.5V | 20mA |
| White | 3.0–3.5V | 20mA |

### Current Limiting Resistor
`R = (Vsupply - Vf) / If`

Example: 12V supply, red LED (Vf=2V), 20mA target:
`R = (12 - 2) / 0.020 = 500Ω` → use 470Ω or 560Ω standard value

### Reverse Voltage Breakdown

> **Lesson Learned:** Standard LEDs have a **reverse breakdown voltage of only
> ~5V**. Any reverse voltage spike above this permanently damages the LED.
> This is why back-EMF from solenoids kills LEDs — the spike easily exceeds
> 5V in reverse.

**Protection strategies:**
1. Flyback diode across the inductive load (primary defense)
2. Second flyback diode at the controller end (if load is remote)
3. Series diode in front of the LED (prevents any reverse current)
4. Parallel reverse diode across the LED (clamps reverse voltage to ~0.7V)

### Polarity Identification
- **Anode (+):** Longer lead
- **Cathode (−):** Shorter lead, flat edge on the lens body
- If leads are trimmed, the flat edge is the reliable indicator

---

## 4. Capacitors

### Electrolytic (Polarized)
- **MUST observe polarity** — reversed polarity can cause venting or explosion
- **Negative (−) stripe:** Printed on the body, marks the cathode/negative lead
- **Positive (+) lead:** Longer lead (before trimming)
- Common uses: power supply filtering, decoupling, energy storage

### Lesson Learned: Capacitor Safety

> **Project: Rocket Launch Controller**
>
> An electrolytic capacitor exploded during early testing. Likely causes:
> reversed polarity and/or no current-limiting protection upstream.
>
> **Fixes applied:**
> 1. Added inline fuse (F1) upstream of the capacitor
> 2. Physically separated the capacitor from the fuse on the PCB (different
>    bus columns) so a failure in one doesn't damage the other
> 3. Clear polarity markings on all documentation and board diagrams

**Rules:**
- Always install electrolytic caps with correct polarity — double-check before
  powering on
- Place a fuse upstream of electrolytic caps in any circuit with a beefy power
  source
- Use physical separation between protection components (fuse) and the
  components they protect (cap) on the PCB

### Ceramic (Non-Polarized)
- No polarity concern — can be installed in either direction
- Common values: 100nF (0.1µF) for decoupling, 1µF–10µF for filtering
- Smaller physical size than electrolytics at the same capacitance

---

## 5. Fuses

### Purpose
Fuses protect the circuit (and the user) from overcurrent events — short
circuits, reversed components, or unexpected load conditions.

### Sizing
- Fuse rating should be **above normal operating current** but **below the
  damage threshold** of the weakest component in the circuit
- Example: Circuit draws 1.6A steady → use a 2A or 2.5A fuse
- For hobby circuits with electrolytic caps: fuse protects against reversed-cap
  short circuit

### Placement
- **Inline with V+**, before any other components
- On the PCB, use an axial fuse holder or solder a fuse with formed leads
- Physical fuse types: glass cartridge (5×20mm), PTC resettable, axial lead

### Lesson Learned: Fuse Placement on PCB

> Place the fuse at the **entry point** of power on the board, before it
> reaches any other component. If the fuse and the component it protects are
> on the same bus segment, a short in the component may draw current
> *around* the fuse through the shared copper.

---

## 6. Resistors

### Color Code (4-Band)
| Band 1 | Band 2 | Multiplier | Tolerance |
|--------|--------|------------|-----------|
| Color → digit | Color → digit | Color → ×10^n | Gold ±5%, Silver ±10% |

Common values in hobby circuits: 220Ω, 330Ω, 470Ω, 1kΩ, 10kΩ

### Power Rating
- Standard 1/4W resistors handle most LED and signal applications
- For current-sense or high-current paths, calculate: `P = I² × R`
- If calculated power > 1/4W, use a 1/2W or 1W resistor

---

## 7. Switches & Buttons

### Key-Lock Switches (Arming)
- Used for safety-critical enable/disable functions
- Physical key prevents accidental activation
- Wire between V+ and the load — open = circuit broken, key-turn = circuit live

### Momentary Pushbuttons (Firing)
- Spring-loaded, normally open — circuit only completes while pressed
- Critical for safety: releasing the button immediately cuts the circuit
- Use buttons rated for the circuit's current (most hobby buttons: 0.5–3A)

### Switch Debouncing
- Mechanical switches bounce (open/close rapidly) for a few milliseconds
- For solenoids and relays this doesn't matter (inertia smooths it out)
- For microcontroller inputs, add a 100nF cap or software debounce

---

## 8. Batteries & Power Sources

### Alkaline AA/AAA in Series
- 1.5V per cell (fresh), ~1.2V under load, ~1.0V near end of life
- No overcurrent protection — will deliver as much current as the load demands
  (until internal resistance limits it)
- 8× AA in series = 12V nominal, can sustain 1–2A for short bursts

### Rechargeable (Li-ion / LiPo) with BMS
- Built-in Battery Management System (BMS) includes overcurrent protection
- BMS may trip at a current lower than your load requires

### Lesson Learned: BMS Overcurrent Tripping

> **Project: Rocket Launch Controller**
>
> A heated-jacket battery (Li-ion with BMS) was used to power a solenoid
> (1.6A draw). The BMS overcurrent protection tripped at ~1.5A, cutting
> power intermittently. LEDs flickered, solenoid didn't actuate reliably.
>
> **Fix:** Switched to 8× AA alkaline batteries (2 × 4-cell holders in
> series). No BMS, no overcurrent cutoff. Solenoid operates reliably.

**Rule:** For inductive loads that draw >1A in bursts, verify your battery
can sustain that current. Li-ion packs with BMS may have surprisingly low
overcurrent thresholds (1–2A). Raw alkaline cells have no such limit but
drain faster.

---

## Quick Reference — Protection Circuits

| Threat | Protection | How |
|--------|-----------|-----|
| Solenoid back-EMF | Flyback diode | 1N4007 across load, cathode → V+ |
| Remote back-EMF (via cable) | Dual flyback | Second 1N4007 at controller end |
| LED reverse breakdown | Flyback diode upstream | Clamp spike before it reaches LED |
| Reversed capacitor | Inline fuse + polarity markings | Fuse blows before cap explodes |
| Short circuit | Inline fuse | Fuse at power entry, rated above normal I |
| Battery overcurrent trip | Use appropriate battery type | Alkaline for high-current loads |
| Reverse power supply | Series diode on V+ | 1N4007 in series, cathode toward load |

## Quick Reference — Failure Diagnosis

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| LED burns out repeatedly | Back-EMF from inductive load | Add flyback diode(s) |
| LED dim or flickering | Power source overcurrent protection tripping | Check battery BMS rating vs load current |
| LED measures ~0.3V both directions | LED destroyed (junction shorted) | Replace LED + add protection |
| Capacitor vented/exploded | Reversed polarity or overvoltage | Check polarity, add upstream fuse |
| Solenoid doesn't actuate | Insufficient current from supply | Measure coil resistance, verify supply current capability |
| Intermittent operation | Loose connections or BMS tripping | Check solder joints, try different power source |

## See Also

- **SVG component rendering:** `electronics-pcb-components` (how to draw these on board diagrams)
- **Circuit schematics:** `electronics-circuit-schematics` (schematic symbol conventions)
- **Board layout safety:** `electronics-pcb-boards` (PCB layout rules including fuse placement, component separation)
