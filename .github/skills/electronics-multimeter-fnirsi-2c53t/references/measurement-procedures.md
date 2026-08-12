# FNIRSI 2C53T — Measurement Procedures Reference

Curated from the official FNIRSI 2C53T manual, Section 8: Common In-circuit Testing Methods.

---

## 1. Battery or DC Voltage Measurement

**Gear selection:** Below 80V → 1X. Above 80V → 10X. Probe and oscilloscope must match.

1. Set oscilloscope to **Auto** trigger mode (default after startup)
2. Set oscilloscope to matching gear (1X or 10X)
3. Set oscilloscope to **DC** coupling mode
4. Insert probe, set probe switch to matching gear
5. Ensure battery/DC source has voltage output
6. Connect probe clamp to **negative** pole, probe tip to **positive** pole
7. Press **AUTO** once — DC signal appears as a flat line with offset (VPP and frequency = 0)

**Key insight:** DC voltage shows as a straight horizontal line, not a waveform. VPP = 0, Freq = 0.

---

## 2. Crystal Oscillator Measurement

**Gear selection:** Always 10X — 1X probe capacitance (100–300pF) can stop oscillation. 10X is ~10–30pF.

1. Set oscilloscope to **Auto** trigger mode
2. Set oscilloscope to **10X** gear
3. Set oscilloscope to **AC** coupling mode
4. Insert probe, set probe switch to **10X**
5. Ensure crystal oscillator board is powered and running
6. Connect probe clamp to board **ground** (power negative)
7. Remove probe cap to expose needle tip, touch one crystal pin
8. Press **AUTO** — crystal waveform appears
9. If waveform too small/large, manually adjust in zoom mode

**Key insight:** Must use 10X to avoid loading the crystal with probe capacitance.

---

## 3. MOS/IGBT PWM Signal Measurement

**Gear selection:** 1X — PWM drive signals are typically 3–20V, well within 80V max.

1. Set oscilloscope to **Auto** trigger mode
2. Set oscilloscope to **1X** gear
3. Set oscilloscope to **DC** coupling mode
4. Insert probe, set probe switch to **1X**
5. Ensure PWM board has PWM signal output
6. Connect probe clamp to MOS **Source** pin, probe tip to **Gate** pin
7. Press **AUTO** — PWM waveform appears

**Key insight:** Probe clamp to Source, tip to Gate. Duty cycle and frequency will be displayed.

---

## 4. Signal Generator Output Measurement

**Gear selection:** 1X — generator output is ≤ 30V.

1. Set oscilloscope to **Auto** trigger mode
2. Set oscilloscope to **1X** gear, **DC** coupling
3. Insert probe, set to **1X**
4. Ensure signal generator is ON and outputting
5. Probe clamp to generator **black** clip, probe tip to **red** output
6. Press **AUTO**

---

## 5. Household Mains (220V/110V) Measurement

**Gear selection:** 10X — mains peak-to-peak is 310–733V. 10X handles up to 1600V p-p.

⚠️ **DANGER: Mains voltage is lethal. Exercise extreme caution.**

1. Set oscilloscope to **Auto** trigger mode
2. Set oscilloscope to **10X** gear
3. Set oscilloscope to **DC** coupling mode
4. Insert probe, set probe switch to **10X**
5. Ensure outlet has power
6. Connect probe clamp and tip to the two mains wires (no polarity distinction)
7. Press **AUTO** — mains sine wave appears (~50Hz or 60Hz)

---

## 6. Power Supply Ripple Measurement

**Gear selection:** Below 80V output → 1X. 80–800V → 10X.

1. Set oscilloscope to **Auto** trigger mode
2. Set oscilloscope to matching gear
3. Set oscilloscope to **AC** coupling mode (filters out DC, shows only ripple)
4. Insert probe, set to matching gear
5. Ensure power supply is ON with voltage output
6. Probe clamp to **negative** output, tip to **positive** output
7. **Wait ~10 seconds** for the waveform baseline to settle (yellow line aligns with yellow arrow)
8. Press **AUTO** — ripple waveform appears

**Key insight:** AC coupling is critical here — it removes the DC component and shows only the AC ripple.

---

## 7. Inverter Output Measurement

**Gear selection:** 10X — inverter output is typically hundreds of volts.

1. Set oscilloscope to **Auto** trigger mode
2. Set to **10X** gear, **DC** coupling
3. Insert probe at **10X**
4. Ensure inverter is powered with voltage output
5. Connect to output terminals (no polarity distinction)
6. Press **AUTO** — modified sine or square wave appears

---

## 8. Power Amplifier / Audio Signal Measurement

**Gear selection:** 1X — amplifier output is generally below 40V.

1. Set oscilloscope to **Auto** trigger mode
2. Set to **1X** gear
3. Set to **AC** coupling mode
4. Insert probe at **1X**
5. Ensure amplifier is ON and outputting audio
6. Connect to speaker output terminals (no polarity distinction)
7. Press **AUTO** — audio waveform appears

---

## 9. Automotive Communication / Bus Signal Measurement

**Gear selection:** 1X — automotive signals are generally below 20V.

⚠️ Uses **Normal** trigger mode (not Auto) — bus signals are non-periodic.

1. Set oscilloscope to **Normal** trigger mode
2. Set to **1X** gear, **AC** coupling
3. Insert probe at **1X**
4. Connect to two signal wires of the communication bus (no polarity)
5. Ensure communication is active
6. Set vertical sensitivity to **50mV**
7. Set time base to **20µS**
8. When a signal appears on the bus, the oscilloscope captures and displays it
9. If no capture: adjust time base (1mS–6nS) and trigger voltage (red arrow) iteratively

**Key insight:** Normal trigger is required for non-periodic signals. Auto trigger will not capture them.

---

## 10. Infrared Remote Control Receiver Measurement

**Gear selection:** 1X — IR signals are typically 3–5V.

⚠️ Uses **Normal** trigger mode — IR remote codes are non-periodic.

1. Set oscilloscope to **Normal** trigger mode
2. Set to **1X** gear, **DC** coupling
3. Insert probe at **1X**
4. Probe clamp to IR receiver board **ground**, tip to IR receiver **data pin**
5. Set vertical sensitivity to **1V**
6. Set time base to **20µS**
7. Adjust trigger level (red arrow) ~1 grid division above the yellow arrow baseline
8. Send a signal from the remote → waveform appears showing the encoded data pulses

---

## 11. Sensor Amplifier Circuit Measurement (Temperature, Humidity, Pressure, Hall)

**Gear selection:** 1X — amplified sensor signals are within measurable range.

1. Set oscilloscope to **Auto** trigger mode
2. Set to **1X** gear, **DC** coupling
3. Insert probe at **1X**
4. Probe clamp to sensor board **ground** (power negative)
5. Locate the **amplifier output** pin, connect probe tip there
6. Set vertical sensitivity to **50mV**
7. Switch to keyboard movement mode, move yellow arrow to **bottom** of screen
8. Set time base to **500mS** (slow scan mode)
9. If yellow signal appears at top: reduce sensitivity (100mV → 200mV → 500mV...)
10. When signal is centered, begin measurement

**Key insight:** Raw sensor signals (millivolts) are too weak for direct oscilloscope measurement — always probe the amplifier output, not the sensor directly.

---

## Trigger Mode Summary

| Mode | Use Case | Signal Type |
|------|----------|-------------|
| **Auto** | Default — captures periodic signals automatically | DC voltage, AC mains, PWM, crystal, audio, ripple |
| **Normal** | Waits for trigger condition — required for non-periodic signals | Bus signals, IR remote codes, serial data |
| **Single** | Captures one event then stops | One-shot events, power-on transients |

## Coupling Mode Summary

| Mode | Effect | Use Case |
|------|--------|----------|
| **DC** | Shows full signal (AC + DC components) | Battery voltage, PWM, logic signals, DC measurements |
| **AC** | Blocks DC, shows only AC variations | Ripple measurement, audio, crystal oscillators |
