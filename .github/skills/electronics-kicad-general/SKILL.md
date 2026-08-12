---
name: electronics-kicad-general
description: 'Foundational KiCad workflow, file layout, and project conventions for designing custom-fabricated PCBs. Covers project structure, schematic capture + ERC, footprint assignment, PCB layout + DRC, layer stack, version control hygiene, and the design phases that lead to a fab order. USE FOR: starting a custom PCB project, KiCad project file layout, .kicad_pro / .kicad_sch / .kicad_pcb, sym-lib-table / fp-lib-table, schematic capture, ERC, DRC, layer stack, hierarchical sheets, net labels, design rules, version control for KiCad, .gitignore for KiCad, KiCad version pinning, the phases from schematic to fab.'
---

# KiCad General — Project Layout, Workflow, and Conventions

> **Foundational skill.** Load this before any other `electronics-kicad-*`
> skill. The other KiCad skills (`-symbols-footprints`,
> `-pcb-fab-gerber`) assume the file layout, design phases, and naming
> conventions documented here.

## Purpose

Establish a clean, reproducible KiCad project layout and a phased workflow
that takes a board design from schematic capture all the way to a fab-ready
output package. Every KiCad project in this repo should follow the
conventions here so other agents, scripts, and humans can pick the project
up later without reverse-engineering it.

**Scope:**

- Project file layout, what each file does, and what to gitignore
- Version targeting (KiCad 10.x at time of writing)
- The six design phases and what "done" means at each phase
- ERC, DRC, and electrical safety checklists
- Layer stack basics for 2-layer hobby boards
- The symbol / footprint / 3D-model triangle
- Useful project variables and path conventions

**Out of scope** (covered by sibling skills):

- Finding and adding symbols/footprints → `electronics-kicad-symbols-footprints`
- Generating Gerbers, drill files, and fab packages → `electronics-kicad-pcb-fab-gerber`
- Bridging KiCad STEP into build123d → `electronics-pcb-board-cad`

---

## 1. Version Targeting

**Pin a KiCad major version per project.** KiCad changes file formats
between majors; opening a v10 project in v8 will fail, and opening a v8
project in v10 silently upgrades it (write the result back and v8 can no
longer open it).

```
# At the top of every project README:
KiCad version: 10.x   (any 10.0.x is fine; do NOT open with 9.x or older)
```

Current latest stable at time of writing: **KiCad 10.0.3** (May 2026).
KiCad 9.x is still supported as the previous LTS. Older majors should be
upgraded before continuing work.

The `kicad-cli version --format about` output is what you paste into bug
reports and what you should record in each project README the first time
you save the project.

---

## 2. Project File Layout

A KiCad project is a folder, not a single file. Minimum files for a real
project:

```
<project-slug>/
  <project-slug>.kicad_pro      # project settings, design rules, paths
  <project-slug>.kicad_sch      # root schematic (more if hierarchical)
  <project-slug>.kicad_pcb      # PCB layout
  <project-slug>.kicad_prl      # per-user UI state (NOT committed)
  fp-info-cache                 # footprint lib cache (NOT committed)
  <project-slug>-backups/       # autosave (NOT committed)

  libs/                         # PROJECT-LOCAL libraries (committed)
    symbols/
      <project-slug>.kicad_sym
    footprints/
      <project-slug>.pretty/
        Custom_Footprint.kicad_mod
    3dmodels/
      Custom_Model.step

  fp-lib-table                  # project-local footprint library registration
  sym-lib-table                 # project-local symbol library registration

  fab/                          # outputs of the fab skill (NOT committed)
    gerbers/
    bom/
    pos/
    drc.rpt
    erc.rpt
    <project-slug>-fab.zip

  README.md                     # spec, version, ordering notes
  decisions/                    # ADRs (per repo convention)
```

### What each file is

| File | Role | Edit how |
|------|------|----------|
| `*.kicad_pro` | Project settings: text-based JSON. Net classes, board stackup, DRC rules, custom field templates. | KiCad UI (Project → Properties), or hand-edit |
| `*.kicad_sch` | Root schematic. S-expression format, diffs cleanly. | Schematic Editor (eeschema) |
| `*.kicad_pcb` | PCB layout, footprints, tracks, zones. S-expression. | PCB Editor (pcbnew) |
| `*.kicad_prl` | Per-user UI state (panel layout, last view). | KiCad — never hand-edit, never commit |
| `*.kicad_sym` | Symbol library file. | Symbol Editor or hand-edit |
| `*.pretty/*.kicad_mod` | One file per footprint. | Footprint Editor or hand-edit |
| `fp-lib-table` / `sym-lib-table` | Maps library nicknames to files. **Project-local entries use `${KIPRJMOD}` paths.** | KiCad Library Manager, or hand-edit |
| `fp-info-cache` | Footprint metadata cache for fast UI. | Auto-regenerated; ignore |

### `.gitignore` for KiCad projects

```gitignore
# KiCad per-user / cache / autosave
*.kicad_prl
fp-info-cache
*-backups/

# Build outputs (regenerated from source)
fab/
*.zip

# Crash dumps
*-crash.log
```

Everything else (the `.kicad_pro`, `.kicad_sch`, `.kicad_pcb`, the project
libs, the lib tables, the README, the decisions) gets committed. KiCad's
text formats diff cleanly enough that you can review PRs against board
files — though for any non-trivial change, attach a screenshot too.

---

## 3. The Six Design Phases

KiCad work is naturally phased. Don't skip ahead — each phase has a "done"
gate that catches bugs cheaper than the next phase will.

| # | Phase | "Done" gate | Common mistakes |
|---|-------|-------------|-----------------|
| 1 | **Spec** | README written: function, I/O, voltage rails, mechanical envelope, target fab vendor | Skipping this; "I'll figure out the connector later" |
| 2 | **Schematic capture** | All nets connected; ERC clean; every symbol has a footprint assigned | Floating power nets; missing decoupling caps |
| 3 | **Footprint assignment** | Every symbol → footprint mapped; 3D model attached where useful | Wrong footprint variant (THT vs SMD); missing 3D models so you can't fit-check |
| 4 | **PCB layout** | All ratsnest connected; board outline drawn; mounting holes placed; component side chosen | Routing before placing; forgetting clearance to board edge; mounting holes overlap copper |
| 5 | **DRC + verification** | DRC clean (or all violations explicitly waived); 3D viewer matches expectation; STEP exported and fit-checked against enclosure | Shipping with DRC violations "because they look OK" |
| 6 | **Fab output** | Gerber package generated, ZIPed, sanity-checked in GerbView or tracespace, uploaded | Wrong layer set; X2 attributes on for a fab that rejects them |

Each phase has a **decision record** opportunity. Anything non-obvious
("why 4-layer instead of 2", "why ENIG instead of HASL", "why this
connector") goes in `decisions/NNNN-*.md` per the repo convention.

---

## 4. Schematic Capture — Conventions and ERC

### Naming

- **Reference designators** follow standard letters: `R` resistor, `C`
  capacitor, `L` inductor, `D` diode, `Q` transistor, `U` IC, `J`
  connector, `SW` switch, `F` fuse, `Y`/`X` crystal, `BT` battery,
  `TP` test point, `LED`/`D` LED.
- **Annotate first, then assign footprints.** Tools → Annotate Schematic
  before going to PCB.
- **Use power symbols (`+5V`, `GND`, `+BATT`) instead of net labels for
  power rails** — they have implicit global connectivity and ERC will
  flag dangling power.
- **Use hierarchical sheets** when a sub-circuit is reused or when the
  root schematic gets above ~50 components. Sheet pins are the contract
  between parent and child.

### ERC (Electrical Rules Check)

Run from Schematic Editor → Inspect → Electrical Rules Checker. Or
headless:

```pwsh
kicad-cli sch erc --severity-all --exit-code-violations my_board.kicad_sch
```

Pre-PCB ERC must be clean of errors. Common ones:

| ERC error | Cause | Fix |
|-----------|-------|-----|
| Pin not connected | Stray wire or unconnected I/O | Wire it, or add the `~` "no-connect" flag |
| Power input not driven | Forgot a `+5V` power flag on the source | Add a `PWR_FLAG` symbol on the supply net |
| Conflicting drivers | Two outputs on one net | Re-route or add buffering |
| Different units (same pin) | Pin reused across multi-unit symbol | Annotate units explicitly |

Warnings are usually safe to ignore but read them once and dismiss
deliberately.

---

## 5. Footprint Assignment

Every schematic symbol must have a footprint chosen before PCB layout. Do
this in **Tools → Edit Symbol Fields** or in the Footprint Assignment
dialog (Tools → Assign Footprints).

A symbol → footprint mapping is stored in the symbol's `Footprint` field
as `Library:Footprint` (e.g. `Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm`).

Footprint sourcing is its own deep topic — see
`electronics-kicad-symbols-footprints` for: official KiCad library,
SnapEDA, Ultra Librarian, Component Search Engine, Octopart, IPC footprint
calculator, and the `${KIPRJMOD}` path-variable convention for project-local
libraries.

---

## 6. PCB Layout — Layer Stack

A standard hobby PCB is **2 layers** of copper on an FR-4 substrate:

| Layer | KiCad name | What goes here |
|-------|------------|----------------|
| Top copper | `F.Cu` | Routing, pads, top-side components |
| Top silkscreen | `F.SilkS` | Component labels, logos |
| Top solder mask | `F.Mask` | Negative — defines where copper is NOT covered |
| Top paste | `F.Paste` | SMT stencil openings |
| Bottom copper | `B.Cu` | Routing, pads, bottom-side components |
| Bottom silkscreen | `B.SilkS` | |
| Bottom solder mask | `B.Mask` | |
| Bottom paste | `B.Paste` | |
| Board outline | `Edge.Cuts` | The physical board shape — fab cuts here |
| Drawings | `User.Drawings` | Notes, dimensions; not plotted by default |
| Comments | `User.Comments` | Same |
| Eco1/Eco2 | `Eco1.User` / `Eco2.User` | Engineering change orders |
| Fab | `F.Fab` / `B.Fab` | Assembly drawings (not on the board) |
| Courtyard | `F.CrtYd` / `B.CrtYd` | Clearance zone around footprints (DRC) |

For **4+ layer boards**, internal copper layers are `In1.Cu`, `In2.Cu`,
etc. Set the stackup in File → Board Setup → Physical Stackup.

### Edge.Cuts is sacred

Anything drawn on `Edge.Cuts` becomes a cut in the fabricated board. Use
the Draw Lines tool with the Edge.Cuts layer active. Common shapes:

- **Rectangle** with rounded corners (Draw Rectangle with corner radius)
- **Circles** for cutouts (USB pass-through, screw clearance)
- **Slots** are cuts, not drilled holes — fabs charge per slot

**Mounting holes** are footprints from the `MountingHole.pretty` library,
not Edge.Cuts cuts. They have plated and non-plated variants; non-plated
(NPTH) is usually the right pick for M2/M3 mounting because plating
shorts the hole to a copper ring.

---

## 7. Net Classes and Design Rules

The default net class is fine for hobby boards. Add a class for any net
that needs different rules:

| Net class | Why | Typical settings |
|-----------|-----|------------------|
| `Default` | Signal | 0.25 mm track, 0.2 mm clearance, 0.6 mm via |
| `Power` | VCC, GND | 0.5–1.5 mm track depending on current |
| `HV` | Anything > 24 V | Wider clearance (0.5 mm+); see IPC-2221 |
| `USB` | USB D+/D- | Differential pair, 90 Ω, length-matched |

Set in File → Board Setup → Net Classes. Assign nets to classes in the
schematic via Net Class Directives, or in the PCB via the Net Inspector.

### Fab-driven minimums

Your fab's spec sheet is the floor. PCBWay's standard is `6/6 mil`
(0.152 mm) track/clearance for the cheap tier; JLCPCB similar. Going
tighter costs more or moves you to a higher-spec tier.

---

## 8. DRC — Design Rule Check

DRC is the PCB-side equivalent of ERC. Run from PCB Editor → Inspect →
Design Rules Checker, or headless:

```pwsh
kicad-cli pcb drc --severity-all --schematic-parity --exit-code-violations my_board.kicad_pcb
```

`--schematic-parity` cross-checks that the PCB matches the schematic
(every component is present, every net is connected). Run this **before
every fab order**.

Must-fix DRC errors:

| Error | Meaning |
|-------|---------|
| Unconnected items | A ratsnest line is still showing — route it |
| Clearance violation | Two pads/tracks/zones are too close |
| Hole near hole | Drills too close together |
| Track too close to board edge | Usually 0.2–0.3 mm minimum |
| Footprint outside board | Component is past Edge.Cuts |
| Courtyard overlap | Two components physically collide |

Warnings can be reviewed and waived (right-click → Exclude this
violation) with a justification.

---

## 9. The Symbol / Footprint / 3D-Model Triangle

A KiCad part is actually **three** files that have to agree:

```
Symbol         Footprint        3D Model
(.kicad_sym)   (.kicad_mod)     (.step / .wrl)
   │               │                │
   │ Footprint     │ 3D Model       │
   │ field         │ field          │
   └───►───────────┴────►───────────┘
```

- **Symbol** lives in a `.kicad_sym` library. Has electrical pins and a
  `Footprint` field pointing at the footprint (e.g. `MyLib:R_0603`).
- **Footprint** lives in a `.pretty` folder. Has pads, courtyard, silk,
  and a **3D model field** pointing at a `.step` or `.wrl` file.
- **3D model** lives anywhere `${KIPRJMOD}/libs/3dmodels/X.step` will
  resolve. Used by the 3D viewer and STEP export.

Breaking any link causes silent failures:

- Bad `Footprint` field → "no footprint" warning during PCB update, and
  the part doesn't show up on the PCB
- Bad 3D model path → 3D viewer shows the footprint flat with no 3D
  representation; STEP export omits the component

`electronics-kicad-symbols-footprints` covers the full workflow for
sourcing and wiring all three.

---

## 10. Path Variables — `${KIPRJMOD}` and friends

KiCad resolves library paths through variables. The two important ones:

| Variable | Resolves to | Use for |
|----------|-------------|---------|
| `${KIPRJMOD}` | The directory of the current `.kicad_pro` | All **project-local** libs |
| `${KICAD9_3DMODEL_DIR}` / `${KICAD10_3DMODEL_DIR}` | Installed 3D models | Official KiCad library 3D models |

**Rule:** if a library is supposed to travel with the project (custom
parts, vendor parts you sourced), register it in the **project-local**
`fp-lib-table` / `sym-lib-table` with a path starting `${KIPRJMOD}/libs/`.

If a library is supposed to be shared across all your KiCad projects,
register it in the **global** lib tables (Preferences → Manage Symbol
Libraries → Global tab). But beware: global libs do not move with the
project, so a fresh clone will show "missing library" warnings until the
new machine has them.

For reproducibility, **prefer project-local**.

---

## 11. Hierarchical Sheets

Once a design has more than ~50 components, break it into hierarchical
sheets:

- File → New → New Sheet creates a sub-sheet
- Add **Sheet Pins** on the parent and matching **Hierarchical Labels**
  on the child to wire signals across the boundary
- Sub-sheets can be reused: instantiate the same `.kicad_sch` file at
  two locations on the parent (e.g., for a dual-channel design)

Reused sheets create instance-specific annotations (`U1`, `U101`, etc.)
automatically, but their PCB footprints land at the same place — you have
to manually move the second instance after Update PCB.

---

## 12. Version Control Workflow

KiCad's text formats make git workable, but with two caveats:

1. **Don't open the same project from two branches simultaneously.**
   `.kicad_prl` and `fp-info-cache` thrash and you'll lose UI state.
   Close KiCad before `git checkout`.
2. **Always run ERC + DRC before committing.** Treat clean ERC/DRC as
   the "all tests green" gate. CI can run these headless with
   `kicad-cli`.

### Suggested commit conventions

| Type | Example |
|------|---------|
| `sch:` | `sch: add I2C pull-ups to U2` |
| `pcb:` | `pcb: route +12V rail with 1mm tracks` |
| `fp:` | `fp: add custom JST-XH 4-pin footprint` |
| `sym:` | `sym: import LM7805 from SnapEDA` |
| `drc:` | `drc: waive clearance violation between F1 and screw terminal (mechanical clearance OK)` |
| `fab:` | `fab: regenerate Gerber package for PCBWay rev A` |
| `decision:` | `decision: switch from 2-layer to 4-layer for ground plane` |

### What to attach to a PR

For non-trivial PCB changes, attach:

1. Schematic PDF (from `kicad-cli sch export pdf`)
2. PCB PDF or PNG of top + bottom (from `kicad-cli pcb export pdf --layers F.Cu,F.SilkS,Edge.Cuts ...`)
3. DRC report (`kicad-cli pcb drc --format report ...`)

This makes async review possible without the reviewer needing KiCad
installed.

---

## 13. CLI Phase Gates (cheat sheet)

The headless `kicad-cli` lets you verify every phase gate from a script.
See `electronics-kicad-pcb-fab-gerber` for the full fab-output recipes;
the phase-gate uses are:

```pwsh
# Phase 2 done? ERC clean
kicad-cli sch erc --severity-error --exit-code-violations my_board.kicad_sch

# Phase 5 done? DRC clean and PCB matches schematic
kicad-cli pcb drc --severity-error --schematic-parity --exit-code-violations my_board.kicad_pcb

# Phase 5 done? STEP exports for enclosure fit check
kicad-cli pcb export step --no-dnp -o fab/my_board.step my_board.kicad_pcb

# Quick visual diff: render board top side as PNG
kicad-cli pcb render --side top --quality high -o fab/my_board_top.png my_board.kicad_pcb
```

All four exit non-zero on failure, so they slot into pre-commit hooks or CI.

---

## Quick Reference — bug → fix

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| "Library not found" on fresh clone | Library registered in global table only | Re-register as project-local with `${KIPRJMOD}/libs/...` |
| "No footprint" warning in PCB update | Symbol `Footprint` field empty or wrong | Tools → Assign Footprints; set `Library:Footprint` |
| 3D viewer shows component flat | 3D model path doesn't resolve | Check footprint's 3D model field; use `${KIPRJMOD}/libs/3dmodels/...` |
| ERC: "Power input not driven" | No `PWR_FLAG` on the supply net | Add the `power:PWR_FLAG` symbol on the source net |
| DRC: "Unconnected items" | Ratsnest still showing | Route the missing track or add a zone fill |
| Fab rejected with "no edge cut" | Edge.Cuts layer not exported in Gerbers | Re-export with Edge.Cuts checked (see fab skill) |
| Same project on two branches gets weird | `.kicad_prl` / `fp-info-cache` collisions | Close KiCad before `git checkout`, gitignore those files |
| KiCad opens v8 project as v10 and v8 can't reopen it | Silent file format upgrade | Pin major version in README; warn before opening |

---

## See Also

- KiCad official docs: <https://docs.kicad.org/>
- `electronics-kicad-symbols-footprints` — where to get parts and how to
  attach symbol/footprint/3D-model triangles
- `electronics-kicad-pcb-fab-gerber` — generating the Gerber + drill +
  BOM + position-file package and uploading to PCBWay / JLCPCB / OSH Park
- `electronics-pcb-board-cad` — building a custom PCB *substrate* model
  parametrically in build123d (for cases where you want to design the
  enclosure first and let the board geometry follow)
