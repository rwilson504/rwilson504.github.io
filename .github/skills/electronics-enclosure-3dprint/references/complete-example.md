# Complete Example: Controller Box Enclosure

## Complete Example: Controller Box

```python
from build123d import *

# ── Board specs ──
PCB_L, PCB_W = 158, 51  # Adafruit Perma-Proto Full-Sized
WALL = 2.5
PAD = 3                  # padding around PCB
STANDOFF_H = 5
BASE_H = 30
LID_H = 10
CORNER_R = 3

INT_L = PCB_L + 2 * PAD
INT_W = PCB_W + 2 * PAD
EXT_L = INT_L + 2 * WALL
EXT_W = INT_W + 2 * WALL

# ── Base ──
with BuildPart() as base:
    Box(EXT_L, EXT_W, BASE_H)
    fillet(base.edges().filter_by(Axis.Z), CORNER_R)
    top = base.faces().sort_by(Axis.Z)[-1]
    offset(amount=-WALL, openings=top)

    # PCB standoffs — IMPORTANT: [1] is inner floor after shelling, not [0]
    inner_floor = base.faces().sort_by(Axis.Z)[1]
    with BuildSketch(inner_floor) as std_sk:
        with Locations(
            (-PCB_L/2 + 12, 0),     # left mount
            (0, 0),                   # center mount
            (PCB_L/2 - 12, 0),       # right mount
        ):
            Circle(3)                # 6mm OD standoff
    extrude(amount=STANDOFF_H)
    # Screw holes — use sketch + subtract (reliable after shelling)
    for pos in [(-PCB_L/2 + 12, 0), (0, 0), (PCB_L/2 - 12, 0)]:
        with BuildSketch(inner_floor) as hole_sk:
            with Locations(pos):
                Circle(1.25)         # M2.5 self-tap hole
        extrude(amount=STANDOFF_H, mode=Mode.SUBTRACT)

    # Cable gland hole (right side)
    right = base.faces().sort_by(Axis.X)[-1]
    with BuildSketch(Plane(right)) as cable_sk:
        with Locations((0, 5)):
            Circle(6.25)             # PG7 cable gland
    extrude(amount=-WALL, mode=Mode.SUBTRACT)

export_stl(base.part, "controller_base.stl")

# ── Lid ──
with BuildPart() as lid:
    # Offset above base for preview visibility
    with Locations((0, 0, BASE_H + 5)):
        Box(EXT_L, EXT_W, LID_H)
    fillet(lid.edges().filter_by(Axis.Z), CORNER_R)

    # Lid recess — IMPORTANT: negative amount cuts INTO lid from bottom face
    lid_bottom = lid.faces().sort_by(Axis.Z)[0]
    with BuildSketch(lid_bottom) as recess_sk:
        Rectangle(INT_L + 0.3, INT_W + 0.3)  # +LIP_TOL
    extrude(amount=-1.5, mode=Mode.SUBTRACT)  # -LIP depth

    lid_top = lid.faces().sort_by(Axis.Z)[-1]

    # ARM switch hole (12mm)
    with BuildSketch(lid_top) as arm_sk:
        with Locations((-40, 0)):
            Circle(6.1)
    extrude(amount=-LID_H, mode=Mode.SUBTRACT)

    # FIRE button hole (16mm)
    with BuildSketch(lid_top) as fire_sk:
        with Locations((20, 0)):
            Circle(8.1)
    extrude(amount=-LID_H, mode=Mode.SUBTRACT)

    # LED holes (4.2mm for 4mm LEDs)
    with BuildSketch(lid_top) as led_sk:
        with Locations((-10, 15), (10, 15)):
            Circle(2.1)
    extrude(amount=-LID_H, mode=Mode.SUBTRACT)

    # Debossed label
    with BuildSketch(lid_top) as label_sk:
        Text("LAUNCH CTRL", font_size=6, align=(Align.CENTER, Align.MAX))
    extrude(amount=-0.4, mode=Mode.SUBTRACT)

export_stl(lid.part, "controller_lid.stl")
```

## MANDATORY: Regenerate STLs After Script Changes

**Every time you modify a Python script that exports STL files (via `export_stl()`), you MUST run the script immediately after saving to regenerate the STL outputs.** Do not wait for the user to ask — this is automatic.

Steps:
1. Edit the `.py` file
2. Run it: `python <script_name>.py`
3. Confirm the STL files were exported successfully (check for `Exported:` print output)
4. If `build123d` is not installed, install it first (`pip install build123d`) then re-run

This applies to any `*_enclosure.py` or any Python script containing `export_stl()` calls.
