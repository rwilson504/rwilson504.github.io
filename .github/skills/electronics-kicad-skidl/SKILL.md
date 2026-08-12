---
name: electronics-kicad-skidl
description: 'Author KiCad circuits entirely in Python with SKiDL (no eeschema schematic capture). SKiDL produces a KiCad netlist that imports headlessly into a .kicad_pcb via a small custom pcbnew script. Covers install, Part/Net pattern, ERC, generate_netlist, the headless netlist→PCB importer pattern, version pinning (SKiDL targets KICAD9, works fine with KiCad 10), and gotchas (no .kicad_sch produced, SKiDL Tag warnings are cosmetic, footprint library env vars). USE FOR: SKiDL, skidl, circuit as code, Python schematic, programmatic schematic, headless schematic capture, skip eeschema, generate_netlist, KiCad netlist from Python, import netlist headless, .net to .kicad_pcb, hobbyist scripted PCB, pip install skidl, ERC in Python.'
---

# KiCad Circuit Authoring in Python — SKiDL

> **Prerequisites:** Load `electronics-kicad-general` first, and read
> `electronics-kicad-python-scripting` for the `pcbnew` patterns this
> skill builds on (FootprintLoad workaround, KiCad 10 SWIG bugs,
> coordinate convention).

## Purpose

Replace KiCad's eeschema schematic capture with a Python DSL so the
entire PCB authoring pipeline is one `pwsh build_fab.ps1` away from a
fab-ready ZIP. Covers:

- **SKiDL** — pure-Python circuit DSL by `xesscorp` that produces a
  KiCad netlist (`.net`).
- **The "headless netlist import" pattern** — a ~250-line `pcbnew`
  script that reads SKiDL's `.net` and adds footprints + net
  assignments to a `.kicad_pcb`. This piece is missing from KiCad
  itself (`kicad-cli pcb import` only handles non-KiCad PCB formats
  like Altium/Eagle).
- Version drift, ERC, the warnings that are noise, and the workflow
  bridge to `electronics-kicad-python-scripting`.

**Out of scope:**

- `.kicad_pcb` authoring patterns (board outline, mounting holes,
  placement) → `electronics-kicad-python-scripting`
- Gerber / drill / BOM / STEP export → `electronics-kicad-pcb-fab-gerber`
- Project layout, ERC/DRC concepts → `electronics-kicad-general`

---

## 1. When to use SKiDL vs eeschema

| Situation | Use |
|-----------|-----|
| Small/medium hobbyist board (~5-50 parts), willing to write Python | **SKiDL** |
| Want full CI/CD: edit Python → push → Gerbers in seconds | **SKiDL** |
| Need a human-readable schematic PDF for review/docs | **eeschema** (or `skidl ➜ generate_schematic` — beta) |
| Large hierarchical design with sub-sheets | **eeschema** |
| Working with non-Python collaborators | **eeschema** |
| Board uses parts not in KiCad's symbol library and you don't want to fight library tables in Python | **eeschema** |

SKiDL pairs especially well with custom hobbyist boards where the
schematic is "obvious from the BOM" — flyback diode + LEDs + screw
terminals + switches. Anywhere you'd otherwise click in eeschema for
15 minutes to capture a 10-component circuit, SKiDL pays off.

---

## 2. Install

SKiDL is on PyPI. Install into your project venv (NOT KiCad's bundled
python — SKiDL doesn't need pcbnew).

```pwsh
d:/path/to/.venv/Scripts/python.exe -m pip install skidl
```

Verify:

```pwsh
d:/path/to/.venv/Scripts/python.exe -c "import skidl; print(skidl.__version__)"
```

As of mid-2026 the latest is **`2.2.3`**. SKiDL's named tool list goes
up to `KICAD9` — there is no `KICAD10` enum yet, but the netlist
format is unchanged between KiCad 9 and 10. Use `set_default_tool(KICAD9)`.

---

## 3. Pointing SKiDL at KiCad's symbol libraries

SKiDL reads `.kicad_sym` library files to look up symbols. Tell it
where KiCad lives via environment variables **set BEFORE `import skidl`**:

```python
import os

KICAD_ROOT = r"C:\Program Files\KiCad\10.0\share\kicad"
SYMBOL_DIR = os.path.join(KICAD_ROOT, "symbols")

os.environ.setdefault("KICAD_SYMBOL_DIR", SYMBOL_DIR)
os.environ.setdefault("KICAD9_SYMBOL_DIR", SYMBOL_DIR)
os.environ.setdefault("KICAD8_SYMBOL_DIR", SYMBOL_DIR)

import skidl
from skidl import Part, Net, ERC, generate_netlist, set_default_tool, KICAD9
set_default_tool(KICAD9)
```

> KiCad 10's symbol library format works with `KICAD9_SYMBOL_DIR`
> — just point it at KiCad 10's `symbols/` folder.

You'll see harmless warnings about missing `KICAD6_SYMBOL_DIR` /
`KICAD7_SYMBOL_DIR` — these are noise (legacy versions you don't have).

`fp-lib-table not found` warnings are also harmless — SKiDL only
needs the **symbol** libraries for ERC; footprint strings are passed
through verbatim to the netlist for KiCad's PCB editor to consume.

---

## 4. The Part / Net pattern

Every component is a `Part(library, symbol, **kwargs)`. Every wire is
a `Net(name)`. Connect by `+=`:

```python
from skidl import Part, Net

# Components (footprint string is "lib:name" using KiCad footprint libs)
BAT = Part(
    "Connector", "Screw_Terminal_01x02",
    ref="BAT", value="+12V/GND in",
    footprint="TerminalBlock_Phoenix:TerminalBlock_Phoenix_MKDS-1,5-2-5.08_1x02_P5.08mm_Horizontal",
)
R1 = Part(
    "Device", "R", ref="R1", value="560",
    footprint="Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal",
)
D1 = Part("Device", "LED", ref="D1", value="GRN", footprint="LED_THT:LED_D5.0mm")

# Nets
v_plus = Net("V+")
gnd    = Net("GND")

# Wiring — pins by number (.[1], .[2]) or by symbol name (.["A"], .["K"])
BAT[1] += v_plus
BAT[2] += gnd
v_plus += R1[1]
R1[2]  += D1["A"]      # LED anode (symbol name)
D1["K"] += gnd          # LED cathode (symbol name)
```

### Pin lookup forms

- `part[1]`, `part[2]` — by pin number (works for everything)
- `part["A"]`, `part["K"]` — by symbol pin name (e.g. LED A/K)
- `part["GND"]`, `part["VCC"]` — by symbol pin name on ICs

In the generated netlist, pin numbers (not names) appear — KiCad
resolves them via the symbol library.

### Power flags

KiCad ERC complains "power input not driven" unless you mark power
nets as power sources. SKiDL exposes this via `net.drive`:

```python
v_plus.drive = 3   # 3 = POWER (highest drive strength)
gnd.drive    = 3
```

---

## 5. ERC + generate_netlist

```python
from skidl import ERC, generate_netlist

ERC()                           # raises only on actual errors; prints warnings
generate_netlist(file_="controller.net")
```

ERC catches: floating pins, multiple drivers on one net, missing power
flags. Run it before writing the netlist — `generate_netlist` will
happily produce a file with disconnected pins.

---

## 6. The Missing Piece: Headless netlist → PCB importer

`kicad-cli pcb import` does **not** import KiCad netlists — it only
handles non-KiCad formats (Altium, Eagle, etc.). The official path is
to open the PCB editor and `File → Import → Netlist` (GUI). For
headless use you need ~250 lines of `pcbnew` Python.

### Algorithm

1. Parse the netlist (s-expression — no comments, simple shape).
2. For each `(comp ...)` in the netlist:
   - Load the footprint from its KiCad library
   - Set reference, value, FPID
   - Add to the board (or update existing footprint with same ref)
3. **Save and reload the board** between stages 2 and 3 — see § 8.
4. For each `(net ...)`:
   - Create the net in the board's net registry (or look up existing)
   - For each `(node (ref ...) (pin ...))`, find the footprint by ref,
     find the pad by number, call `pad.SetNet(net)`.
5. `SaveBoard`.

### Key snippets

```python
import pcbnew

# Footprint load — uses the KiCad 10 SWIG workaround documented in
# electronics-kicad-python-scripting (see "Pitfalls" table).
def load_footprint(lib_root: str, lib_name: str, fp_name: str):
    mgr = pcbnew.PCB_IO_MGR.FindPlugin(pcbnew.PCB_IO_MGR.KICAD_SEXP)
    return mgr.FootprintLoad(f"{lib_root}/{lib_name}.pretty", fp_name)

# Net creation (idempotent)
net = board.FindNet("V+")
if net is None:
    net = pcbnew.NETINFO_ITEM(board, "V+")
    board.Add(net)

# Pad assignment
# DO NOT use FindPadByNumber() — it can return a raw SwigPyObject in
# KiCad 10 after Remove+Add cycles, even after a SaveBoard/LoadBoard
# round-trip. Iterating fp.Pads() always yields properly-wrapped PAD
# objects with .SetNet() etc. attached.
pad = next((p for p in footprint.Pads() if p.GetNumber() == "1"), None)
if pad is not None:
    pad.SetNet(net)
```

### Idempotency

Track refs already on the board. If the footprint string matches,
just refresh the value (preserve position). If it changed, do a
Remove + Add and inherit the previous position. On a clean board,
cascade new footprints into a temporary clump outside the outline so
script `03_place_components.py` can move them to final coordinates
without colliding.

A complete reference implementation lives in
`electronics/rocket-launch-controller/controller/kicad/python/02_apply_netlist.py`
in this repo.

---

## 7. Recommended file layout

Per-project, alongside `controller.kicad_pcb` etc.:

```
<project>/kicad/
    controller.kicad_pcb
    controller.net            ← SKiDL output (gitignore the build/* tree)
    python/
        00_circuit.py             ← SKiDL circuit (run from venv)
        01_board_outline_and_holes.py
        02_apply_netlist.py       ← parses .net, adds footprints + nets
        03_place_components.py    ← positions footprints
        04_export_bom.py          ← walks PCB → CSV BOM
    build_fab.ps1                 ← orchestrates the whole flow
```

`build_fab.ps1` runs:

```pwsh
& $venv_py     python\00_circuit.py        # SKiDL → controller.net
& $kicad_py    python\02_apply_netlist.py  # → controller.kicad_pcb
& $kicad_py    python\03_place_components.py
& $kicad_cli   pcb drc ...                 # gate
& $kicad_cli   pcb export gerbers ...      # fab outputs
```

---

## 8. Pitfalls — read this twice

| Symptom | Cause | Fix |
|---------|-------|-----|
| `AttributeError: 'SwigPyObject' object has no attribute 'SetNet'` on the **second** run of the importer | KiCad 10 SWIG corrupts PAD type info after `Remove + Add` cycles. | After stage 1 (footprint swap), `SaveBoard()` and `LoadBoard()` to flush state before stage 2 (pad net assignment). Reference: `02_apply_netlist.py` in `rocket-launch-controller`. |
| Same `'SwigPyObject' object has no attribute 'SetNet'` error **even with** the SaveBoard/LoadBoard round-trip in place | `fp.FindPadByNumber(pin)` itself returns the raw SwigPyObject — the round-trip is necessary but not sufficient. | Don't use `FindPadByNumber()`. Iterate `fp.Pads()` and match by `p.GetNumber() == str(pin)`. The iterator always yields properly-wrapped PADs. Same project for reference. |
| `swig/python detected a memory leak of type 'FOOTPRINT *'` spam | KiCad 10's bindings are noisy about object lifetimes. | Harmless. Ignore. |
| `WARNING: KICAD6_SYMBOL_DIR environment variable is missing` | SKiDL probes for every historical KiCad version. | Harmless if you've set `KICAD9_SYMBOL_DIR`. Suppress by setting them all to the same path if you want quiet output. |
| `WARNING: fp-lib-table file was not found` | SKiDL doesn't need footprint libs (footprint strings are pass-through). | Harmless. The netlist's `(footprint "Lib:Name")` is what KiCad consumes. |
| `WARNING: Missing tag on <Symbol> ... Random tag XXXX generated` | SKiDL's anti-collision tag for re-runs across machines. | Harmless. Suppress by passing `tag=` to `Part(...)` if you want deterministic netlists. |
| ERC errors `Net <X>: only one pin` | Net was declared but only one pin attached. | Either remove the dangling `Net()` or attach the second pin. |
| ERC errors `Pin <ref>.<pin> not driven by power source` | Power input pin (5V, 3V3, GND) lacks a driver. | Set `net.drive = 3` on V+, GND, etc. |
| Footprint not found at fab time | Footprint string typo or library not on KiCad's `fp-lib-table`. | The importer raises `FileNotFoundError: lib_path` — fix the string in `00_circuit.py`. |
| `kicad-cli sch erc` blows up on the empty `.kicad_sch` stub | SKiDL doesn't produce `.kicad_sch`; the stub left from `kicad-cli sch upgrade` has no symbols. | Drop the ERC gate from `build_fab.ps1`. SKiDL's `ERC()` already validates the circuit. |
| `kicad-cli pcb drc --schematic-parity` flags everything | Same root cause — the `.kicad_sch` is empty. | Drop `--schematic-parity`. Trust the SKiDL netlist as the source of truth. |
| `kicad-cli sch export bom` produces an empty CSV | Same. | Use a custom `04_export_bom.py` that walks `board.GetFootprints()`. |

---

## 9. What SKiDL doesn't give you

- **No `.kicad_sch` file.** No schematic PDF for review/docs out of the
  box. SKiDL has an experimental `generate_schematic()` that produces
  a `.sch` layout, but it's beta and orientation/layout is rough.
- **No interactive ERC waivers.** SKiDL's ERC is all-or-nothing per
  rule; you can suppress with `ERC(loglevel=skidl.ERROR)` but you lose
  the warning detail.
- **No multi-sheet hierarchy** in a polished form. Possible via
  `subcircuit` decorators but ergonomics aren't great.

For a small board (≤ ~50 components), none of these matter.

---

## 10. Verifying the netlist before importing

A quick sanity check between `00_circuit.py` and `02_apply_netlist.py`:

```pwsh
# Component count
Select-String -Path controller.net -Pattern '\(comp ' | Measure-Object | Select-Object Count

# Net summary
d:/path/to/.venv/Scripts/python.exe -c @"
import re
t = open('controller.net').read()
for m in re.finditer(r'\(net\s+\(code "?\d+"?\)\s+\(name \"([^\"]+)\"\)', t):
    print(m.group(1))
"@
```

If the count or net names don't match what you wrote in
`00_circuit.py`, fix the SKiDL source — don't try to hand-edit the
netlist.

---

## See Also

- KiCad netlist format spec (KiCad master docs):
  <https://docs.kicad.org/master/en/eeschema/eeschema.html#netlist-formats>
- SKiDL GitHub: <https://github.com/devbisme/skidl>
- SKiDL docs: <https://devbisme.github.io/skidl/>
- `kicad-cli` reference: <https://docs.kicad.org/master/en/cli/cli.html>
- Sister skills:
  - `electronics-kicad-general` (foundational workflow)
  - `electronics-kicad-python-scripting` (pcbnew Python, SWIG bugs, kiutils, kikit)
  - `electronics-kicad-pcb-fab-gerber` (kicad-cli for Gerbers, DRC, BOM, STEP)
  - `electronics-kicad-symbols-footprints` (where symbol/footprint strings come from)
