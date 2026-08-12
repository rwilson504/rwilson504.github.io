---
name: electronics-kicad-symbols-footprints
description: 'Source, install, and link KiCad symbols, footprints, and 3D models. Covers the official KiCad library, SnapEDA, Ultra Librarian, Component Search Engine, Octopart, manufacturer libraries, project-local vs global lib tables, ${KIPRJMOD} path convention, the symbol/footprint/3D-model triangle, and authoring footprints from a datasheet. USE FOR: finding a symbol or footprint, "I need a part for X", adding a third-party library, SnapEDA, Ultra Librarian, Component Search Engine, custom footprint from datasheet, IPC footprint calculator, 3D model link broken, ${KIPRJMOD}, sym-lib-table, fp-lib-table, project-local library, KiCad 9 embedded files, importing Eagle/Altium libs.'
---

# KiCad Symbols, Footprints, and 3D Models

> **Prerequisite:** Load `electronics-kicad-general` first. This skill
> assumes the project layout (`libs/symbols/`, `libs/footprints/`,
> `libs/3dmodels/`), the `${KIPRJMOD}` path convention, and the
> symbol/footprint/3D-model triangle described in §9 of that skill.

## Purpose

Get parts into a KiCad project quickly and reproducibly. The "thousands of
free parts" promise is real, but the workflow is the #1 place new KiCad
users get stuck — wrong library paths, missing 3D models, mismatched
footprints, and "works on my machine" project moves.

This skill covers:

- Where to find symbols, footprints, and 3D models (free and paid)
- How to register a library so it travels with the project
- How to attach the three files (symbol → footprint → 3D model) so they
  don't drift apart
- How to author a footprint from a datasheet when nobody has made it
- How to import libraries from Altium, Eagle, EasyEDA, and legacy KiCad

---

## 1. The Three Files, Briefly

Every "part" in KiCad is really three files:

| File | Extension | What it is |
|------|-----------|------------|
| Symbol | `.kicad_sym` | The schematic-side representation (pins, labels) |
| Footprint | `.kicad_mod` (inside a `.pretty` folder) | The PCB-side representation (pads, courtyard, silk) |
| 3D model | `.step` (preferred) or `.wrl` | The 3D representation for the 3D viewer and STEP export |

The symbol stores a pointer to the footprint in its `Footprint` field, and
the footprint stores a pointer to the 3D model in its 3D model field.
**Break either pointer and the part silently breaks.** Most "missing
footprint" / "missing 3D model" pain is a broken pointer.

See `electronics-kicad-general` §9 for the diagram.

---

## 2. Library Sources — Where to Find Parts

Ranked roughly by reliability for hobbyist through-hole work:

### A. Official KiCad Library (ships with KiCad)

- Installed with KiCad; registered in the **global** lib tables by default
- Coverage: all common passives, generic logic, voltage regulators, common
  ICs, connectors, mounting holes, test points
- 3D models live in `${KICAD10_3DMODEL_DIR}` (or `${KICAD9_3DMODEL_DIR}`)
- **Always check here first.** If KiCad's official library has it,
  prefer it — it's curated, IPC-compliant, and won't disappear

Browse: KiCad Preferences → Manage Symbol Libraries / Manage Footprint
Libraries → Global tab. Or open the Symbol/Footprint Chooser from the
schematic/PCB editor and search.

### B. Component Search Engine (componentsearchengine.com)

- Free with login; SamacSys-curated
- Provides KiCad **symbol + footprint + STEP 3D model** in one ZIP
- Native KiCad export — drop the `.kicad_sym` + `.pretty/` + `.step` into
  your project libs and register
- Already used in this repo by `electronics-pcb-components-cad` — same
  source for the 3D models
- Coverage: very deep on actual purchasable parts (Digi-Key, Mouser, etc.)

### C. SnapEDA (snapeda.com)

- Free with login; some premium parts
- Native KiCad downloads
- Coverage: enormous, especially modern SMT
- Quality varies — always verify footprint dimensions against the
  datasheet before fab order

### D. Ultra Librarian (ultralibrarian.com)

- Free with login (Digi-Key sponsors)
- Native KiCad export from v10+
- Coverage: similar scope to SnapEDA
- Comes with very complete 3D models from manufacturer CAD

### E. Manufacturer libraries

The big silicon vendors publish libraries directly:

| Vendor | URL pattern | Notes |
|--------|-------------|-------|
| Texas Instruments | ti.com → product page → "Design tools & simulation" | Usually IBIS/SPICE; KiCad rarely; check |
| Analog Devices | analog.com → product page → "Design Resources" | Usually Altium; convert via `kicad-cli sym/fp upgrade` |
| Bourns | bourns.com → product page → "Tools" | Direct KiCad libs for popular parts |
| Würth Elektronik | we-online.com → "REDEXPERT" | Has KiCad export |
| Adafruit | github.com/adafruit/Adafruit-KiCad-Libraries | Comprehensive, well-maintained |
| SparkFun | github.com/sparkfun/SparkFun-KiCad-Libraries | Comprehensive, well-maintained |

### F. Octopart (octopart.com)

- Aggregator; cross-references many libraries
- Useful to *find* a part across multiple sources before downloading from
  the one you trust most

### G. Roll your own

When no library has the part (rare for hobbyist work, common for
specialized industrial connectors), author the footprint from the
datasheet. See §6 below.

---

## 3. Installing a Third-Party Library

The default new-user mistake: download a SnapEDA part, double-click the
`.kicad_sym`, KiCad pops up "library not found" warnings on every
subsequent open. The fix is to use the right registration mode.

### Project-local registration (recommended for downloaded parts)

For anything that came from outside the official library, install it as
**project-local** so a fresh clone of the repo has the part. Otherwise
you're back to "works on my machine".

1. Unpack the download. Most third-party packages have:
   ```
   PART_NAME.kicad_sym
   PART_NAME.pretty/PART_NAME.kicad_mod
   PART_NAME.step
   ```
2. Move them into the project's `libs/` folder:
   ```
   <project>/libs/symbols/PART_NAME.kicad_sym
   <project>/libs/footprints/PART_NAME.pretty/PART_NAME.kicad_mod
   <project>/libs/3dmodels/PART_NAME.step
   ```
3. Open KiCad → Preferences → Manage Symbol Libraries → **Project
   Specific Libraries** tab → Add. Set:
   - Nickname: `PART_NAME` (or a category like `vendor_xyz`)
   - Library Path: `${KIPRJMOD}/libs/symbols/PART_NAME.kicad_sym`
4. Same for footprints: Manage Footprint Libraries → Project Specific
   Libraries → Add → `${KIPRJMOD}/libs/footprints/PART_NAME.pretty`
5. Fix the 3D model path inside the footprint. Open the footprint in
   Footprint Editor → Properties → 3D Models tab → set path to
   `${KIPRJMOD}/libs/3dmodels/PART_NAME.step`

Verify by closing and reopening KiCad. If you see "library not found"
warnings, a path is wrong — fix it in the lib table (it's a text file,
hand-editing is fine).

### Global registration (use sparingly)

For libraries you genuinely want across all projects (Adafruit's curated
libs, your personal collection), register globally. But understand:
**global libs do not travel with the project.** If you collaborate, or
clone to a new machine, you'll see "missing library" warnings until you
re-install the global lib there too.

Practical rule: global is fine for "I always use these"; project-local is
mandatory for "this project needs this".

---

## 4. The `${KIPRJMOD}` Convention

`${KIPRJMOD}` resolves to the directory containing the `.kicad_pro` file.
**Always use it** for project-local paths so:

- `git clone` to a new directory still works
- `Save Project As` to a new location still works
- The project survives being moved or renamed

Bad path (don't):
```
D:/projects/my_board/libs/footprints/MyLib.pretty
```

Good path:
```
${KIPRJMOD}/libs/footprints/MyLib.pretty
```

Same rule applies to:

- `sym-lib-table` entries
- `fp-lib-table` entries
- The 3D model field inside each footprint
- Custom drawing-sheet files

---

## 5. The Symbol → Footprint → 3D Model Chain

When you place a downloaded part on a schematic, three things have to be
wired correctly:

### Symbol's `Footprint` field

Schematic Editor → right-click symbol → Properties → `Footprint` field.
Must be `<library_nickname>:<footprint_name>` exactly as registered in
`fp-lib-table`.

Examples:
- `Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm` (official KiCad)
- `MyLib:JST_XH_4Pin` (project-local)

A wrong or empty footprint field is the most common cause of "missing
footprint" during Update PCB from Schematic.

### Footprint's `3D Model` field

Footprint Editor → open footprint → Properties → 3D Models tab. Add a row
with the path to the `.step` file.

If the model is at the origin in its source coordinate system but appears
shifted in the 3D viewer, adjust the Offset/Rotation/Scale fields. Vendor
STEPs often need a 90° rotation or a Z-axis offset to sit flat on the pads.

### Verification

After wiring all three, verify in the **3D Viewer** (PCB Editor → View →
3D Viewer or Alt+3). Every component should appear; if one is flat or
missing, its 3D model link is broken.

---

## 6. Authoring a Footprint from a Datasheet

When no library has the part:

### The IPC Footprint Calculator (built into KiCad)

For standard SMT packages (QFP, QFN, SOIC, BGA, etc.), KiCad has an
IPC-compliant calculator:

1. Open Footprint Editor
2. Tools → Footprint Wizard
3. Pick the package family, enter datasheet dimensions (body, lead pitch,
   lead width, lead length)
4. Generate; tweak as needed; save into your project lib

This produces IPC-7351 compliant footprints automatically. Use it whenever
possible — saves time and reduces error.

### Hand-authoring (for through-hole connectors, custom mechanical parts)

Open a new footprint in the Footprint Editor and place pads manually:

1. **Set the unit and grid first.** Connectors are usually 2.54 mm pitch
   (0.1"). Crystals are 0.05" or metric. Use the right grid.
2. **Pad type matters.** Through-hole = round drill + annular ring. SMT
   pad = rectangle, no drill. Read the datasheet's recommended land
   pattern — don't guess.
3. **Pin numbers must match the schematic symbol.** Pin 1 on the
   footprint = Pin 1 on the symbol. KiCad won't catch a mismatch; the
   resulting board will just be wrong.
4. **Draw the courtyard.** This is the keep-out zone around the part.
   DRC uses it to flag physical collisions. Default: pad bounding box +
   0.25 mm.
5. **Draw the silkscreen outline** on `F.SilkS` (or `B.SilkS` for
   bottom-side parts). Don't draw silk *under* pads — fabs strip that
   away.
6. **Mark pin 1.** A dot or a chamfer on the silk so the assembler
   knows which way to orient the part.
7. **Reference designator and value.** `F.Fab` layer, small text. The
   value is the part number; the reference designator is the placeholder.
8. **Save** into `<project>/libs/footprints/MyLib.pretty/PART_NAME.kicad_mod`.

### Sanity-check against a known-good footprint

Open a similar official footprint side-by-side and compare:
- Pad dimensions
- Pad-to-pad spacing
- Courtyard offset

Then *print the footprint at 1:1 scale on paper, place the physical part
on top, and verify the pads line up*. This catches almost every
hand-authored footprint error before it becomes a $50 fab failure.

---

## 7. 3D Models — Sourcing and Fixing

If a footprint has no 3D model, the 3D viewer just shows the pads flat. To
fix:

### Sources for 3D models

Same vendors as §2:
- Component Search Engine — bundled STEP
- SnapEDA — bundled STEP
- Ultra Librarian — bundled STEP
- Manufacturer site → "3D Model" or "Mechanical drawings" → STEP
- Grabcad.com — community CAD
- componentsearchengine.com (same as §2.B)

### Attaching the model

Footprint Editor → open footprint → Properties → 3D Models tab → Add.
Path: `${KIPRJMOD}/libs/3dmodels/MODEL.step`.

### Adjusting position

Vendor STEPs usually have their origin at the model's geometric center or
its pin-1. KiCad expects the model's origin at the footprint's origin (the
center of pin 1 for connectors, or the body center for ICs).

Symptoms and fixes:

| Symptom | Adjust |
|---------|--------|
| Component floating above the board | Z Offset (mm), negative value to push down |
| Component sunk into the board | Z Offset positive |
| Component rotated wrong (sideways pins) | Rotation (X/Y/Z) — typically 90° on Z |
| Component flipped (pins up) | Rotation 180° on X |
| Component much too big / too small | Scale (X/Y/Z). Vendor STEP units sometimes differ (m vs mm). Use 0.001 to convert m → mm or check the source units |

Test in the 3D Viewer after each change.

### When the STEP is "too detailed"

Sometimes vendor STEPs include screws, washers, and internal mechanism
details. This blows up file size and slows the 3D viewer.

- **Quick fix:** keep using it; only enable the 3D viewer when needed
- **Better fix:** simplify the STEP in FreeCAD or via `bd_warehouse`
  parametric models in `electronics-pcb-components-cad`

### `.wrl` vs `.step`

KiCad supports both. **Prefer STEP** — it's parametric, embeds materials
better, and is what `kicad-cli pcb export step` will use to generate a
clean mechanical model. `.wrl` is older, mesh-based, and only the 3D
viewer reads it.

---

## 8. Importing Libraries from Other Tools

The `kicad-cli sym upgrade` and `kicad-cli fp upgrade` commands convert
legacy and non-KiCad library formats.

### Supported input formats

| Source | Symbol input | Footprint input |
|--------|--------------|-----------------|
| KiCad pre-6.0 | `.lib` | `.mod`, `.emp` |
| Altium | `.SchLib`, `.IntLib` | `.PcbLib`, `.IntLib` |
| Eagle | `.lbr` | `.lbr` |
| CADSTAR | `.lib` | `.cpa` |
| EasyEDA / JLCEDA Std | `.json` | `.json` |
| EasyEDA / JLCEDA Pro | `.elibz`, `.epro`, `.zip` | same |
| GEDA/PCB | — | folder with `.fp` files |

### Convert and install

```pwsh
# Symbols
kicad-cli sym upgrade --output libs\symbols\my_lib.kicad_sym path\to\source.SchLib

# Footprints
kicad-cli fp upgrade --output libs\footprints\my_lib.pretty path\to\source.PcbLib
```

Then register the converted libraries project-locally (§3).

---

## 9. KiCad 9+ Embedded Files (Single-File Portability)

KiCad 9 added the ability to **embed** symbols, footprints, and 3D models
directly inside the `.kicad_sch` / `.kicad_pcb` files. This is the
extreme version of project-local: the project becomes a single file with
no external library dependencies.

Trade-offs:

| Embed | Pro | Con |
|-------|-----|-----|
| All libraries | Project is fully self-contained | File size grows; harder to share parts across projects |
| Just the custom ones | Fewer "missing library" warnings | Still depends on global libs |
| Nothing (default) | Standard workflow | Project breaks if libs move |

Enable per-symbol via the Symbol Editor's "Embed" toggle. Useful for
"send this project to a fab" scenarios where you don't want to also send
a libs folder.

For repo-tracked projects, project-local libs (§3) are usually a better
workflow because the libs diff cleanly in git, where embedded files
balloon the schematic file with binary content.

---

## 10. Library Naming and Organization

For a project with many custom parts, name libraries by **role**, not by
**vendor**. The schematic reads cleaner:

```
✓ Good:
  Connectors:JST_XH_4Pin
  Power:LM7805_TO220
  Sensors:DHT22

✗ Bad:
  SnapEDA_2024_07_05:JST_XH_4Pin
  AdiPart_LM7805:LM7805_TO220
  AmznSensor:DHT22
```

The library nickname is what shows up in the symbol chooser and on PCB
update logs. Future-you will thank you.

---

## 11. License Hygiene

Most free libraries (SnapEDA, Ultra Librarian, Component Search Engine)
are free *for your projects* but the parts have terms attached. Common
ones:

| License | Means |
|---------|-------|
| CC-BY-SA / similar | Attribution required if you redistribute |
| "Free for design use" | OK in your project, may not be OK to repackage as your own library |
| Manufacturer EULA | Read it once; usually OK for prototypes, sometimes restricts commercial use |

For repo-tracked custom libs that bundle third-party content, add a
`libs/LICENSE.md` listing each external part and its source. Sufficient
for personal / hobby projects; consult counsel for commercial.

---

## Quick Reference — bug → fix

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| "Missing library" on open | Lib registered globally on dev machine, not on clone | Move registration to project-local with `${KIPRJMOD}` |
| "No footprint" during Update PCB | Symbol's `Footprint` field empty or wrong format | Set `Library:Footprint` exactly; check lib nickname matches |
| 3D viewer shows component flat | Footprint has no 3D model attached, or path doesn't resolve | Add model path with `${KIPRJMOD}/libs/3dmodels/...` |
| Component floats / sinks in 3D viewer | Vendor STEP origin offset wrong | Adjust Z Offset in footprint properties → 3D Models tab |
| Component oriented wrong in 3D | Vendor STEP needs rotation | Adjust Rotation X/Y/Z in same dialog |
| New custom footprint pads don't match physical part | Hand-authored without paper print check | Print at 1:1, lay the part on top, verify |
| Footprint pin 1 on the wrong side | Hand-authored without verifying pin numbering against symbol | Open both side-by-side, confirm pin 1 → pin 1 |
| Eagle / Altium lib won't open in KiCad | Need conversion | `kicad-cli sym upgrade` / `fp upgrade` |
| Project shared with collaborator → "library not found" everywhere | Libs registered globally, not project-local | Re-register as project-local, commit lib tables |

---

## See Also

- KiCad library docs: <https://docs.kicad.org/master/en/eeschema/eeschema.html#libraries>
- Component Search Engine: <https://componentsearchengine.com>
- SnapEDA: <https://www.snapeda.com>
- Ultra Librarian: <https://www.ultralibrarian.com>
- `electronics-kicad-general` — project layout, `${KIPRJMOD}`, the
  symbol/footprint/3D-model triangle
- `electronics-pcb-components-cad` — placing the same component STEP
  models on a parametric build123d PCB assembly
