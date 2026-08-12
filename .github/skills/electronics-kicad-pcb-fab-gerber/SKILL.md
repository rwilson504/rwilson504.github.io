---
name: electronics-kicad-pcb-fab-gerber
description: 'Generate a fab-ready Gerber + Excellon drill + BOM + position file package from a KiCad PCB, and upload to PCBWay / JLCPCB / OSH Park / AISLER. Covers the kicad-cli headless commands, Plot dialog settings, vendor-specific quirks (PCBWay X2 ban, JLCPCB layer names, OSH Park accepts .kicad_pcb), DRC pre-flight, GerbView sanity check, and IPC-2581 / ODB++ alternatives. USE FOR: send PCB to fab, export Gerbers, generate fab files for PCBWay, JLCPCB, OSH Park, AISLER, kicad-cli pcb export gerbers, drill file, Excellon, pick-and-place, position file, BOM CSV, IPC-2581, ODB++, why did my fab order get rejected, GerbView, tracespace, zip up Gerbers.'
---

# KiCad Fab Output — Gerber, Drill, BOM, Position File

> **Prerequisite:** Load `electronics-kicad-general` first. This skill
> assumes you have a DRC-clean `.kicad_pcb`, a working ERC-clean
> schematic, and the project layout (`fab/` output folder) described
> there.

## Purpose

Turn a finished KiCad design into a ZIP file you can upload to PCBWay,
JLCPCB, OSH Park, AISLER, or any other PCB fab and get back manufactured
boards. Covers the full output set (Gerbers + drill + BOM + position file
+ optional STEP) and the per-vendor quirks that cause rejections.

The headless `kicad-cli` is the workhorse — every export is one command,
which makes "regenerate fab package on git commit" a one-line script.

---

## 1. Universal Truth: Gerber + Excellon is the Lowest Common Denominator

**Every PCB fab on earth accepts Gerber files + an Excellon drill file
as a ZIP.** Vendor-specific formats and plugins are conveniences on top.

| Format | When to use | Vendor support |
|--------|-------------|----------------|
| **Gerber RS-274X + Excellon** | Default. Use this unless you have a specific reason not to. | Universal |
| **Gerber X2** (extended attributes) | Modern; carries netlist + drill info | Most fabs accept; **PCBWay explicitly says don't use it for their parser** |
| **IPC-2581** | Single-file modern standard; replaces Gerber+drill+BOM in one XML | Growing support; PCBWay, JLCPCB, MacroFab accept |
| **ODB++** | Industry-standard; complete fabrication database | High-end fabs; rarely needed for hobby work |
| **Native `.kicad_pcb`** | Send the project file directly | OSH Park accepts; PCBWay/JLCPCB do not |

**Rule of thumb:** generate plain Gerber RS-274X with X2 OFF as the
canonical artifact. Add IPC-2581 or `.kicad_pcb` as a secondary upload
only if your chosen fab prefers them.

---

## 2. The Fab Output Set (2-Layer Hobby Board)

The minimum acceptable set:

| File | Layer / source | KiCad layer name | Common ext |
|------|----------------|------------------|------------|
| Top copper | Front conductor | `F.Cu` | `.gtl` (Protel) or `.gbr` |
| Bottom copper | Back conductor | `B.Cu` | `.gbl` or `.gbr` |
| Top solder mask | Front mask (negative) | `F.Mask` | `.gts` or `.gbr` |
| Bottom solder mask | Back mask (negative) | `B.Mask` | `.gbs` or `.gbr` |
| Top silkscreen | Front silk | `F.SilkS` | `.gto` or `.gbr` |
| Bottom silkscreen | Back silk | `B.SilkS` | `.gbo` or `.gbr` |
| Board outline | Edge cuts | `Edge.Cuts` | `.gm1` / `.gko` or `.gbr` |
| Drill file (PTH) | Plated through-holes | n/a (Excellon) | `.drl` |
| Drill file (NPTH) | Non-plated holes | n/a (Excellon) | `.drl` (separate file) |

**For assembly** (SMT pick-and-place service), add:

| File | Source | Format |
|------|--------|--------|
| Position file | Footprint placement | `.pos` (ASCII) or `.csv` |
| BOM | Schematic symbols + fields | `.csv` |
| Top paste | `F.Paste` | `.gtp` or `.gbr` (also for stencil order) |
| Bottom paste | `B.Paste` | `.gbp` or `.gbr` |

**For mechanical / enclosure work:**

| File | Source | Format |
|------|--------|--------|
| 3D STEP model | Board + components | `.step` |
| Board outline DXF | `Edge.Cuts` only | `.dxf` |

---

## 3. The Plot Dialog — UI Way

KiCad 10 PCB Editor → File → Plot. For a standard 2-layer order:

1. **Plot format:** `Gerber`
2. **Output directory:** `./fab/gerbers/`
3. **Plot on all layers:** check
   - `F.Cu`, `B.Cu`, `F.Paste`, `B.Paste`, `F.SilkS`, `B.SilkS`,
     `F.Mask`, `B.Mask`, `Edge.Cuts`
   - For 4+ layers: also `In1.Cu`, `In2.Cu`, etc.
4. **Plot border and title block:** UNCHECK (fab doesn't need it)
5. **Plot footprint values / references:** check (on F.SilkS)
6. **Force plotting of invisible refs/values:** uncheck
7. **Exclude footprints with `DNP`:** check (don't plot DNP parts)
8. **Subtract solder mask from silkscreen:** check (silk under mask is
   removed — this is what fabs expect)
9. **Plot mode:** `Filled`
10. **Use extended X2 format attributes:** **UNCHECK for PCBWay** (their
    parser rejects X2). For most other fabs you can leave it on.
11. **Include netlist attributes:** uncheck (only relevant for X2)
12. **Subtract solder mask from silk:** check
13. **Use Protel file extensions:** check (gives `.gtl` / `.gbl` etc.;
    safer for older fab tools — though `.gbr` is fine for modern fabs).
    **KiCad 10 note:** Protel extensions are the **default** in the GUI
    too; the checkbox is on out of the box. Uncheck only if a specific
    vendor asks for `.gbr`.
14. Click **Plot**
15. Click **Generate Drill Files…**
    - **Drill File Format:** Excellon
    - **Drill Origin:** Absolute
    - **Drill Units:** Millimeters
    - **Zeros Format:** Decimal format (PCBWay-safe); JLCPCB also accepts
      this
    - **Map File Format:** PDF (for human review)
    - **Drill Marks:** Actual size
    - Check **Generate separate files for PTH and NPTH** if your fab
      asks for it (PCBWay accepts both forms)

Files appear in `fab/gerbers/`. **Always sanity-check in GerbView** (see
§7) before zipping.

---

## 4. The Headless Way — `kicad-cli`

The Plot dialog is convenient once. For a project that gets re-fabbed,
script it.

### Generate Gerbers

```pwsh
$BOARD = "my_board.kicad_pcb"
$OUT   = "fab/gerbers"

kicad-cli pcb export gerbers `
  --output $OUT `
  --layers "F.Cu,B.Cu,F.Paste,B.Paste,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts" `
  --no-x2 `
  --subtract-soldermask `
  $BOARD
```

Key flags:

| Flag | Why |
|------|-----|
| `--no-x2` | Strips X2 extended attributes. Mandatory for PCBWay |
| `--subtract-soldermask` | Removes silk under mask — what fabs expect |
| `--exclude-refdes` | (optional) Omit reference designators on silk |
| `--exclude-value` | (optional) Omit value text on silk |
| `--no-protel-ext` | Use `.gbr` extensions instead of `.gtl`/`.gbl` (Protel is the default in KiCad 10 — pass this only if a fab wants `.gbr`) |
| `--use-drill-file-origin` | Use the drill/place origin instead of absolute |
| `--variant <name>` | Generate a board variant (DNP set differs) |

#### KiCad 10 compat note — `--use-protel-extensions` was removed

In KiCad 9 the inverse flag `--use-protel-extensions` enabled Protel
file extensions (`.gtl`, `.gbl`, `.gto`, …). In **KiCad 10 that flag was
removed** and Protel extensions became the **default**. The new flag is
`--no-protel-ext` and it turns Protel extensions OFF (giving `.gbr`).

Symptoms when upgrading:

```text
kicad-cli: error: unrecognized arguments: --use-protel-extensions
```

Fix: just drop the flag. For PCBWay / JLCPCB (which want Protel
extensions), no extra flag is needed — the KiCad 10 default already
emits `.gtl`/`.gbl`/etc.

The build_fab pattern for vendor-specific switching becomes very small:

```pwsh
switch ($Vendor) {
    "pcbway" { $gerberArgs += "--no-x2" }   # Protel is default — no extra flag
    "jlcpcb" { $gerberArgs += "--no-x2" }   # same
    "aisler" { $gerberArgs += "--no-x2" }
    "oshpark" { }                            # accepts .kicad_pcb anyway
}
```

### Generate the drill file

```pwsh
kicad-cli pcb export drill `
  --output $OUT `
  --format excellon `
  --drill-origin absolute `
  --excellon-units mm `
  --excellon-zeros-format decimal `
  --excellon-separate-th `
  --generate-map `
  --map-format pdf `
  $BOARD
```

Key flags:

| Flag | Why |
|------|-----|
| `--excellon-separate-th` | Generates separate `*PTH.drl` and `*NPTH.drl`. Most fabs accept either combined or separate; separate is safer |
| `--excellon-zeros-format decimal` | Modern format; some legacy tools want `suppressleading` — check the fab's spec |
| `--generate-map` | Drill map PDF for visual verification |

### Generate the BOM (for assembly orders)

```pwsh
kicad-cli sch export bom `
  --output fab/bom/my_board-bom.csv `
  --fields "Reference,Value,Footprint,QUANTITY,Manufacturer,MPN,DNP" `
  --labels "Refs,Value,Footprint,Qty,Manufacturer,MPN,DNP" `
  --group-by "Value,Footprint,MPN" `
  --exclude-dnp `
  my_board.kicad_sch
```

For JLCPCB SMT assembly, their BOM template expects specific column
names — see JLCPCB's docs and rename the columns to match. JLCPCB also
needs the `LCSC` part number per component (custom schematic field).

### Generate the position file (pick-and-place)

```pwsh
kicad-cli pcb export pos `
  --output fab/pos/my_board-pos.csv `
  --side both `
  --format csv `
  --units mm `
  --use-drill-file-origin `
  --exclude-dnp `
  $BOARD
```

For JLCPCB, position files need column headers exactly:
`Designator,Val,Package,Mid X,Mid Y,Rotation,Layer`. You may need to
post-process the CSV with PowerShell or Python; KiCad's defaults are close
but not identical.

### Run DRC headless first (gate)

```pwsh
kicad-cli pcb drc `
  --severity-error `
  --schematic-parity `
  --exit-code-violations `
  --output fab/drc.rpt `
  $BOARD
```

Exit code 5 = DRC violations. Wire this into a pre-fab script so you
can't generate a Gerber package from a dirty board.

### Run ERC headless first (gate)

```pwsh
kicad-cli sch erc `
  --severity-error `
  --exit-code-violations `
  --output fab/erc.rpt `
  my_board.kicad_sch
```

### Export STEP for enclosure fit check

```pwsh
kicad-cli pcb export step `
  --output fab/my_board.step `
  --no-dnp `
  --subst-models `
  --force `
  $BOARD
```

Then drop into `build123d` per `electronics-pcb-board-cad` for enclosure
collision checks.

### Render a 3D preview for the README

```pwsh
kicad-cli pcb render `
  --output fab/my_board-3d.png `
  --side top `
  --quality high `
  --rotate "-30,0,45" `
  --background transparent `
  --width 1600 --height 900 `
  $BOARD
```

`--rotate "-30,0,45"` is a pleasant isometric view; tweak to taste.

### Render 2D layout-review images (for AI agents and humans)

The 3D render is pretty but the 2D top-down view is dramatically more
useful for **design review** — for catching placement mistakes, verifying
connector orientation, and confirming clearance to mounting holes. An AI
agent looking at a layout PNG can independently verify "does J1's wire
entry actually face the left edge?" instead of relying on DRC numbers
alone (DRC won't catch a connector rotated 180° from your intent if
clearance is still fine).

Two complementary outputs:

```pwsh
# 1. Top-down SVG — fully zoomable in any browser/VS Code preview; the
# resulting file contains real <text> elements for every footprint
# reference designator (grep / programmatic search is possible).
kicad-cli pcb export svg `
  --output fab/my_board-layout-top.svg `
  --layers "F.Cu,F.SilkS,F.Mask,F.Fab,Edge.Cuts" `
  --page-size-mode 2 `
  --exclude-drawing-sheet `
  --mode-single `
  $BOARD

# 2. Top-down PNG — flat orthographic render, photographic colors;
# bitmap so it's directly viewable in agent vision tools.
kicad-cli pcb render `
  --output fab/my_board-layout-top.png `
  --side top --quality high --background opaque `
  --width 2000 --height 1200 `
  $BOARD
```

**Layer composition rationale** for the SVG:

| Layer       | Why include |
|-------------|-------------|
| `F.Cu`      | Top-side copper — shows where traces (once routed) and pads land |
| `F.SilkS`   | Silkscreen — component values, polarity marks |
| `F.Mask`    | Solder mask openings — every pad and via |
| `F.Fab`     | Fabrication layer — reference designators (BAT/J1/H6/etc.) |
| `Edge.Cuts` | Board outline — frame for orientation |

**Why both formats?** SVG is the right format for *layout* (vector, exact
geometry, text-searchable). The render PNG is the right format for
*visual review with photographic component bodies* (you can see "ah,
J3 looks like a green Phoenix terminal block here," not just an outline).
Cost: ~300 KB SVG + ~270 KB PNG per project.

**For routed boards**, swap `F.Cu` for `F.Cu,B.Cu` and produce a second
SVG with `B.Cu,B.SilkS,B.Mask,B.Fab,Edge.Cuts` + `--mirror` to inspect
the bottom side. Or use `--mode-multi` to get one SVG per layer.

---

## 5. The One-Script Fab Package

Tie it all together. Put this in `<project>/build_fab.ps1`:

```pwsh
# build_fab.ps1 — generate a fab-ready package for the current project
[CmdletBinding()]
param(
    [string]$Vendor = "pcbway"   # "pcbway", "jlcpcb", "oshpark", "aisler"
)
$ErrorActionPreference = "Stop"

$PROJ  = "my_board"
$BOARD = "$PROJ.kicad_pcb"
$SCH   = "$PROJ.kicad_sch"
$ROOT  = "fab"
$OUT_G = "$ROOT/gerbers"

# Clean & prep
if (Test-Path $ROOT) { Remove-Item $ROOT -Recurse -Force }
New-Item -ItemType Directory -Path $OUT_G, "$ROOT/bom", "$ROOT/pos" | Out-Null

# Gate 1: ERC must be clean
Write-Host "[gate] ERC..." -ForegroundColor Cyan
kicad-cli sch erc --severity-error --exit-code-violations `
  --output "$ROOT/erc.rpt" $SCH
if ($LASTEXITCODE -ne 0) { throw "ERC violations — see $ROOT/erc.rpt" }

# Gate 2: DRC + schematic parity must be clean
Write-Host "[gate] DRC..." -ForegroundColor Cyan
kicad-cli pcb drc --severity-error --schematic-parity --exit-code-violations `
  --output "$ROOT/drc.rpt" $BOARD
if ($LASTEXITCODE -ne 0) { throw "DRC violations — see $ROOT/drc.rpt" }

# Per-vendor flags
$gerberFlags = @("--subtract-soldermask")
switch ($Vendor) {
    "pcbway"  { $gerberFlags += "--no-x2" }
    "jlcpcb"  { $gerberFlags += "--no-x2" }   # safe default
    "oshpark" { }   # OSH Park is fine with X2
    "aisler"  { $gerberFlags += "--no-x2" }
}

# Gerbers
Write-Host "[build] Gerbers..." -ForegroundColor Cyan
kicad-cli pcb export gerbers `
  --output $OUT_G `
  --layers "F.Cu,B.Cu,F.Paste,B.Paste,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts" `
  @gerberFlags $BOARD

# Drill (Excellon, mm, decimal, separate PTH/NPTH)
Write-Host "[build] Drill..." -ForegroundColor Cyan
kicad-cli pcb export drill `
  --output $OUT_G `
  --format excellon `
  --drill-origin absolute `
  --excellon-units mm `
  --excellon-zeros-format decimal `
  --excellon-separate-th `
  --generate-map --map-format pdf `
  $BOARD

# BOM
Write-Host "[build] BOM..." -ForegroundColor Cyan
kicad-cli sch export bom `
  --output "$ROOT/bom/$PROJ-bom.csv" `
  --fields "Reference,Value,Footprint,QUANTITY,Manufacturer,MPN,DNP" `
  --group-by "Value,Footprint,MPN" --exclude-dnp $SCH

# Position file
Write-Host "[build] Position..." -ForegroundColor Cyan
kicad-cli pcb export pos `
  --output "$ROOT/pos/$PROJ-pos.csv" `
  --side both --format csv --units mm --exclude-dnp $BOARD

# STEP for enclosure work
Write-Host "[build] STEP..." -ForegroundColor Cyan
kicad-cli pcb export step --output "$ROOT/$PROJ.step" --no-dnp --subst-models --force $BOARD

# 3D render for README
Write-Host "[build] 3D render..." -ForegroundColor Cyan
kicad-cli pcb render --output "$ROOT/$PROJ-3d.png" `
  --side top --quality high --rotate "-30,0,45" --background transparent `
  --width 1600 --height 900 $BOARD

# 2D layout review images (SVG = searchable vector, PNG = flat top-down)
Write-Host "[build] 2D layout review (SVG + PNG)..." -ForegroundColor Cyan
kicad-cli pcb export svg --output "$ROOT/$PROJ-layout-top.svg" `
  --layers "F.Cu,F.SilkS,F.Mask,F.Fab,Edge.Cuts" `
  --page-size-mode 2 --exclude-drawing-sheet --mode-single $BOARD
kicad-cli pcb render --output "$ROOT/$PROJ-layout-top.png" `
  --side top --quality high --background opaque `
  --width 2000 --height 1200 $BOARD

# Zip the fab package
$Zip = "$ROOT/$PROJ-fab-$Vendor.zip"
Write-Host "[pack] $Zip" -ForegroundColor Cyan
Compress-Archive -Path "$OUT_G/*" -DestinationPath $Zip -Force

Write-Host ""
Write-Host "Fab package ready: $Zip" -ForegroundColor Green
Write-Host "BOM:              $ROOT/bom/$PROJ-bom.csv"
Write-Host "Position file:    $ROOT/pos/$PROJ-pos.csv"
Write-Host "STEP:             $ROOT/$PROJ.step"
Write-Host "3D render:        $ROOT/$PROJ-3d.png"
Write-Host "Layout SVG:       $ROOT/$PROJ-layout-top.svg"
Write-Host "Layout PNG:       $ROOT/$PROJ-layout-top.png"
Write-Host ""
Write-Host "Verify in GerbView before uploading: kicad-cli gerber info $OUT_G\*.gbr" -ForegroundColor Yellow
```

Run with:

```pwsh
pwsh ./build_fab.ps1 -Vendor pcbway
```

Add `fab/` to `.gitignore`; commit the script.

---

## 6. Per-Vendor Quirks

### PCBWay

- **X2 attributes:** OFF. Use `--no-x2`. Their parser rejects X2.
- **File extensions:** Protel (`.gtl`, `.gbl`) historically preferred;
  modern PCBWay accepts `.gbr` too.
- **Drill:** Excellon, mm, decimal zeros, "Suppress leading zeros" also
  accepted. Separate PTH/NPTH OK.
- **Edge.Cuts:** must be present in the upload. Their auto-quote uses
  it for board dimensions.
- **Upload:** ZIP everything in `fab/gerbers/` together (Gerbers + drill).
  Don't nest folders — PCBWay's quoting tool reads flat ZIPs.
- **Plugin:** PCBWay has an official KiCad plugin
  (<https://www.pcbway.com/blog/News/PCBWay_Plug_In_for_KiCad_3ea6219c.html>)
  that uploads directly. Convenience, not requirement.
- **Min track/clearance:** 6/6 mil (≈0.152 mm) standard tier; 3/3 mil
  available at higher cost.
- **Min hole:** 0.3 mm standard.

### JLCPCB

- **X2:** OFF. Use `--no-x2`. JLCPCB's parser also rejects X2 sometimes.
- **File extensions:** Protel preferred.
- **Drill:** Excellon, mm, decimal zeros. JLCPCB historically wanted
  combined PTH+NPTH; modern tier accepts separate.
- **Assembly (SMT):** JLCPCB requires:
  - BOM in their specific column order (`Comment,Designator,Footprint,LCSC Part #`)
  - Position file with specific headers (`Designator,Val,Package,Mid X,Mid Y,Rotation,Layer`)
  - LCSC part numbers in the schematic (add a custom field `LCSC`)
- **Min track/clearance:** 5/5 mil standard.
- **Min hole:** 0.3 mm.

### OSH Park

- **Accepts `.kicad_pcb` directly.** No Gerber generation needed; their
  Eagle/KiCad backend handles plotting.
- **Purple boards, 2 oz copper, gold-plated traces** by default.
- More expensive per square inch than PCBWay/JLCPCB but smaller minimum
  order; great for tiny prototypes.

### AISLER

- **Accepts `.kicad_pcb` directly** OR Gerbers.
- EU-based; faster shipping in Europe.
- **X2:** OFF for Gerber uploads.

---

## 7. GerbView Sanity Check — Never Skip This

Before zipping and uploading, **open the Gerbers in GerbView** (a
companion app installed with KiCad) and visually inspect every layer.

1. KiCad → GerbView (from the main launcher) or `gerbview` from the CLI
2. File → Open Gerber Files → select all `fab/gerbers/*.gbr` (and Protel
   extensions if you used those)
3. File → Open Excellon Drill File → select the `.drl` files
4. Toggle layers in the right panel; verify each looks right:
   - F.Cu has all your traces and pads
   - B.Cu likewise on the back
   - F.Mask / B.Mask are NEGATIVE images — black where copper is exposed
   - F.SilkS shows reference designators positioned reasonably
   - Edge.Cuts shows the board outline as a continuous closed shape
   - Drill file dots align with through-holes and mounting holes

Common gotchas this catches:

| Visible in GerbView | Means |
|---------------------|-------|
| Silk text inside a pad | You forgot `--subtract-soldermask`, or silk overlaps unintentionally |
| Outline doesn't close | Edge.Cuts has a gap — fab will reject as "no board outline" |
| Outline has multiple disconnected pieces | You meant one board but the fab might think it's a panel |
| Drill hits don't align with pads | Drill origin mismatch |
| Tiny isolated copper islands | Unconnected leftover; route or fill |
| Missing layer | Forgot to include in `--layers` |

**Alternative:** <https://tracespace.io> — drag-drop the Gerber ZIP in
your browser to render the board. Same purpose, no install.

```pwsh
# Quick info dump on each Gerber file (text)
Get-ChildItem fab/gerbers/*.gbr | ForEach-Object {
    Write-Host "== $($_.Name) =="
    kicad-cli gerber info --units mm $_.FullName
}
```

---

## 8. Common Rejection Reasons

| Fab rejection | Cause | Fix |
|---------------|-------|-----|
| "No board outline" | Edge.Cuts missing or not closed | Re-export with Edge.Cuts in `--layers`; check for gaps in GerbView |
| "Can't parse Gerber" (PCBWay) | X2 attributes on | Re-export with `--no-x2` |
| "Drill file not found" | Forgot `kicad-cli pcb export drill` step | Add it to your script |
| "Boards overlap" | Edge.Cuts has multiple closed shapes | Pick one; if you wanted a panel, set up proper panelization |
| "Unsupported layer name" | Used a custom layer KiCad named oddly | Rename to canonical KiCad names (F.Cu, B.Cu, etc.) before plotting |
| "Drill outside board" | Mounting hole outside Edge.Cuts boundary | Move the hole inside the board outline |
| "Min hole / track too small" | Below the fab's tier minimum | Tighten the design or upgrade to a higher-spec tier |
| Assembly BOM rejected | Column order or names wrong for the assembler | Match the assembler's exact template |

---

## 9. IPC-2581 — The Modern Alternative

IPC-2581 is a single XML file that contains the entire fab package
(Gerbers + drill + netlist + BOM + stackup). PCBWay, JLCPCB, MacroFab,
and a growing list of fabs accept it.

```pwsh
kicad-cli pcb export ipc2581 `
  --output fab/$PROJ.xml `
  --compress `
  --version C `
  --units mm `
  --bom-col-mfg "Manufacturer" `
  --bom-col-mfg-pn "MPN" `
  $BOARD
```

`--compress` produces a ZIP file (`.zip` extension despite the `.xml`
arg). Pros: one file, no missing layers, BOM travels with the geometry.
Cons: not universal, and some fabs' parsers are still rough.

**Use Gerber as the canonical artifact; offer IPC-2581 as a secondary
upload if the fab supports it.**

---

## 10. ODB++

ODB++ is the industrial standard, but rarely needed for hobby work.

```pwsh
kicad-cli pcb export odb `
  --output fab/$PROJ-odb.zip `
  --compression zip `
  --units mm `
  $BOARD
```

If a vendor specifically asks for ODB++, generate it. Otherwise stick
with Gerber.

---

## 11. Stencils (for SMT Assembly)

If you're hand-soldering SMT, you'll want a stainless steel solder paste
stencil. Order it alongside the PCB:

- Generate the paste-layer Gerbers: `--layers F.Paste,B.Paste` in
  `kicad-cli pcb export gerbers`
- Most fabs offer a stencil add-on at order time; upload the paste
  Gerbers separately
- For sub-$50 stencils, OSH Stencils (USA), JLCPCB, and PCBWay all do
  cheap mylar or stainless steel stencils

---

## 12. Pre-Fab Checklist

Run through this before placing every order:

- [ ] ERC clean (`kicad-cli sch erc --severity-error --exit-code-violations`)
- [ ] DRC clean (`kicad-cli pcb drc --severity-error --schematic-parity`)
- [ ] Schematic PDF reviewed (`kicad-cli sch export pdf`)
- [ ] PCB top + bottom PNG/PDF reviewed (`kicad-cli pcb export pdf`)
- [ ] **2D layout review SVG/PNG generated and visually inspected**
      (`kicad-cli pcb export svg` + `kicad-cli pcb render --side top`).
      For an AI agent: this is your primary self-verification path — open
      the PNG to confirm connector orientation, mounting-hole clearance,
      and that no two footprints are visually colliding.
- [ ] 3D viewer shows every component (none missing/flat)
- [ ] Mounting holes are inside Edge.Cuts and not overlapping copper
- [ ] All silkscreen text inside the board outline and not under pads
- [ ] Net classes assigned (power tracks wide enough for current)
- [ ] BOM exported and every component has a value / MPN
- [ ] Gerbers visually inspected in GerbView or tracespace.io
- [ ] Drill map PDF reviewed — drills align with pads
- [ ] Vendor-specific quirks applied (X2 off for PCBWay, BOM columns for
      JLCPCB assembly)
- [ ] Fab spec is within vendor capability (min track/clearance/hole)
- [ ] One last look at the rendered 3D board (`kicad-cli pcb render`)

If all green, ZIP and upload.

---

## Quick Reference — bug → fix

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| PCBWay rejects the upload | X2 attributes left on | Add `--no-x2` and re-export |
| "No board outline" error | Edge.Cuts missing from `--layers` list | Include `Edge.Cuts` |
| Silkscreen text printed under pads | Forgot `--subtract-soldermask` | Re-export with the flag |
| Drill file not generated | Used `pcb export gerbers` only; drill is a separate command | Add `pcb export drill` step |
| GerbView shows misaligned drills | Drill origin set to "plot" but Gerbers use absolute | Set both to the same origin (default: absolute) |
| JLCPCB assembly BOM rejected | Wrong column names | Match JLCPCB's template exactly; rename columns post-export |
| `.kicad_pcb` upload to PCBWay fails | They don't accept native KiCad files | Generate Gerbers |
| STEP export takes minutes | Default fuse-shapes is on | Try without `--fuse-shapes` (faster but pads are separate faces) |
| Render shows wrong colors | Quality preset uses default theme | Add `--use-board-stackup-colors` |
| "Boards overlap" rejection | Two closed Edge.Cuts shapes | Delete the spurious one or panelize properly |

---

## See Also

- KiCad CLI reference: <https://docs.kicad.org/master/en/cli/cli.html>
- PCBWay KiCad guide: <https://www.pcbway.com/blog/help_center/Generate_Gerber_file_from_Kicad.html>
- PCBWay KiCad plugin: <https://www.pcbway.com/blog/News/PCBWay_Plug_In_for_KiCad_3ea6219c.html>
- JLCPCB documentation: <https://jlcpcb.com/help/article/Generating-Gerber-Files-from-KiCad>
- OSH Park KiCad: <https://docs.oshpark.com/design-tools/kicad/>
- Tracespace browser Gerber viewer: <https://tracespace.io>
- `electronics-kicad-general` — project layout, DRC/ERC, design phases
- `electronics-kicad-symbols-footprints` — getting parts before you can
  generate fab files
- `electronics-pcb-board-cad` — taking the exported STEP into build123d
  for enclosure fit checks
