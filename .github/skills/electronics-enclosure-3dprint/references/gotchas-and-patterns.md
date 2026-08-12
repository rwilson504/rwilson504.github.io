# Common Gotchas & Advanced Patterns

## Common Gotchas (Verified)

These are real bugs encountered during enclosure generation. Always follow these rules:

| # | Gotcha | Wrong | Right |
|---|--------|-------|-------|
| 1 | **Inner floor after shelling** | `sort_by(Axis.Z)[0]` — this is the outer bottom face | `sort_by(Axis.Z)[1]` — the inner floor face |
| 2 | **Lid recess direction** | `extrude(amount=LIP, mode=SUBTRACT)` on bottom face — cuts downward into air | `extrude(amount=-LIP, mode=SUBTRACT)` — cuts upward into lid body |
| 3 | **Lip construction** | `offset(amount=-LIP)` on a sketch rectangle — fragile, can fail | Inner `Rectangle(..., mode=Mode.SUBTRACT)` to create hollow frame |
| 4 | **Screw holes after shelling** | Bare `Hole()` with `Locations()` — unreliable context after shell | `BuildSketch` + `Circle` + `extrude(SUBTRACT)` — explicit and reliable |
| 5 | **Dead edge selections** | Selecting edges but never calling `chamfer()` or `fillet()` | Always use selected edges immediately or remove the code |
| 6 | **Lid preview position** | Base and lid overlap at origin | Use `with Locations((0, 0, BASE_H + 5)):` before lid `Box()` |
| 7 | **Mounting hole coordinate axes** | Mixing `(width, length)` for some holes and `(length, width)` for others — causes standoffs to land in wrong places or punch through walls | **All** hole tuples must use the **same convention**: `(length_pos, width_pos)` where length = `PCB_L` axis and width = `PCB_W` axis. Verify no coordinate exceeds its board dimension. |
| 8 | **Side-wall holes after internal features** | `sort_by(Axis.X)[-1]` after adding divider walls, ridges, or standoffs — picks an internal face instead of the outer wall | Cut side-wall holes **immediately after shelling**, or use a world-space `Cylinder(mode=Mode.SUBTRACT)` with `rotation=(0, 90, 0)` positioned at the wall — avoids face selection and face-local coordinate issues entirely. |
| 9 | **Rectangular side-wall cutouts** | Using `BuildSketch(face)` with face-local coordinates — face-local XY doesn't map to world YZ intuitively, cutouts end up in wrong position or off the face entirely | Use world-space `Box(mode=Mode.SUBTRACT)` positioned with `Locations((wall_x, y, z))`. For +X wall: `Box(WALL*3, width, height)`. For +Y wall: `Box(width, WALL*3, height)`. Always verify Z positions are within wall bounds. |
| 10 | **Cutout Z position below floor** | Calculating Z offset from another feature (e.g. `display_z - 25`) without checking if the result is below `-BASE_H/2` | Always verify: `cutout_z > -BASE_H/2 + WALL` (above inner floor) and `cutout_z < BASE_H/2` (below top edge). Print `cutout_z` during development to catch this. |
| 11 | **Assuming vertical stacking from a photo** | Placing features vertically stacked (different Z) when the photo shows them side-by-side | **Rotate the reference photo** to match the installed orientation before interpreting spatial relationships. Side-by-side in the photo = offset in Y (not Z) on the wall. |
| 12 | **Lip overhangs or sits on outside** | Lip sized to `EXT_L × EXT_W` (extends outside wall) or `INT_L` with inner overhang into cavity — both cause print failures | Lip sits on inner portion of wall: outer = `EXT - 2*(WALL-LIP)`, inner = `INT`. Use `RectangleRounded` with radii `CORNER_R - (WALL-LIP)` and `CORNER_R - WALL` to match filleted box corners. Lid recess = `EXT - 2*(WALL-LIP) + TOL` with same rounded corners. |
| 13 | **Cable gland hole not centered on wall** | `gland_z = -BASE_H/2 + BASE_H * 0.45` or other arbitrary offset — leaves uneven margins above/below the hole | `gland_z = 0` — centers the hole exactly on the wall. The nut needs equal clearance on both sides to fit and spin freely. Always center unless there's a specific obstruction. |
| 14 | **Wall too short for cable gland nut** | Setting `BASE_H` just tall enough for the PCB + components, forgetting the gland nut protrudes inward and needs vertical clearance | Size `BASE_H` so the wall height (after subtracting floor thickness) leaves at least **gland diameter + 4mm** of clear wall around the hole. PG7 = 12.5mm hole → minimum ~17mm of internal wall height. Add 5mm margin when in doubt. |
| 15 | **Cavity depth uses `2 * WALL` for open-top shell** | `BOSS_H = BASE_H - 2 * WALL` — subtracts wall thickness for both floor AND top, but the top was removed by `openings=` | After `offset(amount=-WALL, openings=top_face)`, cavity depth = `BASE_H - WALL` (only the floor has thickness). To reach the lip top: `BOSS_H = BASE_H - WALL + LIP`. |
| 16 | **Bosses taller than wall shift the lip** | Building bosses (that extend above wall top) **before** the lip — `sort_by(Axis.Z)[-1]` picks a boss top face instead of the wall rim, shifting the lip's X/Y origin | **Always build the lip BEFORE bosses** when bosses extend above the wall. The lip needs the wall rim as the highest Z face. Bosses are built after since they use `inner_floor` which is stable. |
| 17 | **Multiple wall cutouts at different Z heights** | Placing each cutout at an independent `bat_mid_z` or arbitrary Z — results in a ragged, unprofessional look on the wall face | Define a shared `row_bottom_z` (e.g. the bottom edge of the most constrained cutout like USB-C), then position every cutout as `row_bottom_z + height/2`. This aligns all bottom edges in a clean horizontal row. |
| 18 | **Adjusting C-C distance merges adjacent cutouts** | Moving cutout A closer to cutout B by shifting only A's center — the edges overlap and the two holes merge into one opening in the STL | Always check **edge-to-edge clearance**, not just center-to-center distance. After changing any C-C offset, verify: `gap = abs(center_A - center_B) - (width_A/2 + width_B/2)`. If gap < 2mm (one wall thickness), shift the neighboring cutout(s) further away. |
| 19 | **Moving a captive button cutout without its parts** | Changing only the cutout position (e.g. `pwr_btn_x`) but forgetting the guide channel and separate button STL — leaves the channel on the old wall and the button dimensions mismatched | **Captive buttons are multi-part assemblies.** When moving a button cutout, you MUST also move: (1) the guide channel block+hollow on the wall interior, (2) update the separate `BuildPart` button plunger dimensions if the cutout size changed. Search the script for the button's position variable (e.g. `pwr_btn_x`, `pwr_btn_z`) and verify ALL references use it — cutout, guide block, guide hollow. Also update the button STL shaft dimensions to match the new cutout. |

### Pattern 9: Captive Button Plunger

A free-floating button that slides through a wall cutout but can't fall out.
Three components that must stay synchronized:

1. **Wall cutout** — `Box(mode=Mode.SUBTRACT)` punching through the wall
2. **Guide channel** — solid block + hollow on the wall interior, holds the flange
3. **Button plunger** — separate `BuildPart` exported as its own STL

**Naming convention:** Use a shared position variable (e.g. `pwr_btn_x`, `pwr_btn_z`) for ALL three components so moving the button = changing one variable.

```python
# ── Captive button cutout + guide channel ──
BTN_CUT_W = 9.0      # cutout width
BTN_CUT_H = 3.5      # cutout height
btn_x = some_ref_x   # shared X position — change here to move everything
btn_z = some_ref_z   # shared Z position

# 1. Wall cutout
with Locations((btn_x, wall_y, btn_z)):
    Box(BTN_CUT_W, WALL * 3, BTN_CUT_H, mode=Mode.SUBTRACT)

# 2. Guide channel (flange pocket)
FLANGE_W = BTN_CUT_W + 2.0   # wider than cutout
FLANGE_H = BTN_CUT_H + 2.0   # taller than cutout
FLANGE_D = 1.5                # flange thickness
GUIDE_WALL = 1.5              # channel wall thickness
GUIDE_TOL = 0.3               # clearance
GUIDE_DEPTH = FLANGE_D + 1.0  # travel room

guide_y = wall_y - WALL - GUIDE_DEPTH / 2
g_outer_w = FLANGE_W + 2 * GUIDE_WALL + 2 * GUIDE_TOL
g_outer_h = FLANGE_H + 2 * GUIDE_WALL + 2 * GUIDE_TOL
g_inner_w = FLANGE_W + 2 * GUIDE_TOL
g_inner_h = FLANGE_H + 2 * GUIDE_TOL

with Locations((btn_x, guide_y, btn_z)):
    Box(g_outer_w, GUIDE_DEPTH, g_outer_h)
with Locations((btn_x, guide_y, btn_z)):
    Box(g_inner_w, GUIDE_DEPTH + 1, g_inner_h, mode=Mode.SUBTRACT)

# 3. Button plunger (separate BuildPart + STL)
BTN_TOL = 0.2
SHAFT_W = BTN_CUT_W - 2 * BTN_TOL
SHAFT_H = BTN_CUT_H - 2 * BTN_TOL
SHAFT_L = WALL

with BuildPart() as button:
    Box(SHAFT_W, SHAFT_L, SHAFT_H)
    with Locations((0, -(SHAFT_L / 2 + FLANGE_D / 2), 0)):
        Box(FLANGE_W, FLANGE_D, FLANGE_H)
export_stl(button.part, "button.stl")
```

**Assembly:** Push from outside → flange passes through cutout → sits in guide channel → can't fall out or twist. Internal component (e.g. battery) presses against flange to actuate.

### Pattern 7: Lid Screw Bosses (Corner Mounting)

Screw bosses in base corners + through-holes in lid for secure screw-down closure.
Merge bosses into walls for strength (not freestanding cylinders).
**Build order: lip FIRST, then bosses** — if bosses extend above the wall (e.g. flush with lip top), they must be built after the lip to avoid corrupting `sort_by(Axis.Z)[-1]` face selection for the lip sketch.

```python
# Inside base BuildPart, after standoffs — BUILD LIP FIRST, THEN BOSSES:
LID_SCREW_OD = 7.0    # boss outer diameter
LID_SCREW_ID = 2.5    # M3 self-tap hole
# Cavity depth = BASE_H - WALL (only floor has thickness; top is open)
# Add LIP to reach flush with lip top
BOSS_H = BASE_H - WALL + LIP

# Boss centers overlap 1.5mm into each wall for structural strength
BOSS_INSET = LID_SCREW_OD / 2 - 1.5

boss_positions = [
    (-INT_L/2 + BOSS_INSET, -INT_W/2 + BOSS_INSET),
    ( INT_L/2 - BOSS_INSET, -INT_W/2 + BOSS_INSET),
    (-INT_L/2 + BOSS_INSET,  INT_W/2 - BOSS_INSET),
    ( INT_L/2 - BOSS_INSET,  INT_W/2 - BOSS_INSET),
]

# Build boss cylinders
with BuildSketch(inner_floor) as boss_sk:
    for pos in boss_positions:
        with Locations(pos):
            Circle(LID_SCREW_OD / 2)
extrude(amount=BOSS_H)

# Self-tap holes in bosses
for pos in boss_positions:
    with BuildSketch(inner_floor) as boss_hole_sk:
        with Locations(pos):
            Circle(LID_SCREW_ID / 2)
    extrude(amount=BOSS_H, mode=Mode.SUBTRACT)

# --- In the lid: matching through-holes ---
LID_SCREW_CLEARANCE = 3.4  # M3 clearance
lid_top = lid.faces().sort_by(Axis.Z)[-1]
with BuildSketch(lid_top) as screw_sk:
    for pos in boss_positions:  # same positions
        with Locations(pos):
            Circle(LID_SCREW_CLEARANCE / 2)
extrude(amount=-LID_H, mode=Mode.SUBTRACT)
```

### Pattern 8: Rounded Alignment Lip + Lid Recess

Lip with rounded corners matching the filleted box. Sits on inner portion of wall.

```python
# Lip dimensions — sits on wall, not overhanging
LIP_OUTER_L = EXT_L - 2 * (WALL - LIP)
LIP_OUTER_W = EXT_W - 2 * (WALL - LIP)
LIP_INNER_L = INT_L
LIP_INNER_W = INT_W

# Corner radii follow the box fillet inward
LIP_OUTER_R = max(CORNER_R - (WALL - LIP), 0.5)
LIP_INNER_R = max(CORNER_R - WALL, 0.5)

rim_top = base.faces().sort_by(Axis.Z)[-1]
with BuildSketch(rim_top) as lip_sk:
    RectangleRounded(LIP_OUTER_L, LIP_OUTER_W, LIP_OUTER_R)
    RectangleRounded(LIP_INNER_L, LIP_INNER_W, LIP_INNER_R, mode=Mode.SUBTRACT)
extrude(amount=LIP)

# Lid recess matches lip outer edge
LID_RECESS_R = max(CORNER_R - (WALL - LIP), 0.5)
lid_bottom = lid.faces().sort_by(Axis.Z)[0]
with BuildSketch(lid_bottom) as recess_sk:
    RectangleRounded(
        LIP_OUTER_L + LIP_TOL,
        LIP_OUTER_W + LIP_TOL,
        LID_RECESS_R,
    )
extrude(amount=-LIP, mode=Mode.SUBTRACT)  # negative = into lid body
```

## Recommended Build Order Inside `BuildPart`

After repeated debugging, this order avoids face-selection and coordinate issues:

```
1. Box()                          # outer shape
2. fillet()                       # round corners
3. offset(openings=top)           # shell
4. ALL side-wall holes            # Cylinder/Box SUBTRACT — immediately after shell!
5. inner_floor = ...sort_by(Z)[1] # grab inner floor reference
6. PCB standoffs + screw holes    # on inner_floor
7. Lid screw bosses               # on inner_floor, merged into walls
8. Internal features              # dividers, ridges, shelves
9. Alignment lip (rounded)        # extrude on rim_top — LAST before export
```
