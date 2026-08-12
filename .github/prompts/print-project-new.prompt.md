---
description: 'Scaffold a new 3D print project folder under printing/<slug>/ with README, decisions/, SESSION_LOG.md, and an opening session-log row. Use at the start of any new print project.'
argument-hint: '<project-slug> + brief description (what the print is for)'
---

# Scaffold a new 3D print project

You are creating a new project folder for a 3D-printed item. Follow this
checklist exactly. Do not skip the `decisions/` folder — it is required by
the **3D Print Operator** agent.

## Inputs to confirm

Before creating files, confirm with the user:

1. **Project slug** — lowercase, hyphenated, no spaces (e.g.
   `desk-organizer`, `battery-holder-aa8`). Reject anything else.
2. **One-line purpose** — what is this print and who/what is it for?
3. **Source model** — does it already exist (path or link), is CAD Builder
   making it, or is it a third-party download (MakerWorld / Printables)?
4. **Initial material guess** — PLA / PETG / ABS / TPU / other. Just a
   starting point; the first decision file will lock it in.

If any answer is missing, ask for it before proceeding.

## Files to create

Create all of the following under `printing/<project-slug>/`:

### 1. `README.md`

```markdown
# <Project Title>

**Slug:** `<project-slug>`
**Status:** in-progress
**Started:** YYYY-MM-DD
**Agent:** 3D Print Operator

## Purpose
<one-line description from input #2>

## Source Model
<link / path to STL/STEP/.3mf, or note if CAD Builder is producing it>

## Target Print Settings (initial — see decisions/ for final)
- **Material:** <initial guess from input #4>
- **Printer:** Bambu Lab P2S
- **Slicer:** Bambu Studio

## Decisions
See [`decisions/`](decisions/) for the chronological record of every
non-trivial choice made on this project.

## Session Log
See [`SESSION_LOG.md`](SESSION_LOG.md) for time tracking per repo
convention.

## Files
- `*.stl` / `*.step` — source models
- `*.3mf` — Bambu Studio project files
- `profiles/` — exported slicer profiles (optional)
- `photos/` — build-plate photos, failure photos, finished prints
```

### 2. `decisions/0001-material-and-orientation.md`

This is the **first decision** for every print project. Pre-fill it as a
template that the user fills in during the first real conversation:

```markdown
# 0001. Material and Print Orientation

- **Date:** YYYY-MM-DD
- **Status:** proposed
- **Project:** <project-slug>

## Context
What's the part for? What loads will it see? What environment (indoor,
outdoor, hot, wet, UV)? What aesthetic matters?

## Options Considered
1. **<material A>** — pros / cons for this part
2. **<material B>** — pros / cons for this part
3. **<material C>** — pros / cons for this part

For orientation, consider:
- Layer line direction vs. load direction (layers are weakest in Z)
- Which face is cosmetic and should be top/visible
- Which features need supports and where supports leave scars
- Bridge spans and overhang angles

## Decision
**Material:** <chosen>
**Orientation:** <described or with sketch reference>
**Why:** <one paragraph>

## Consequences
- Print time estimate: <>
- Material cost estimate: <>
- Trade-offs accepted: <>

## Lessons (filled in after first print)
<empty until the print runs>
```

### 3. `SESSION_LOG.md`

Use the format defined in [`AGENTS.md` § Session log convention](../../../AGENTS.md#session-log-convention):

```markdown
# Session Log — <Project Title>

| # | Date       | Start (local) | End (local) | Prompts | Typing (s) | Active (HH:MM) | Agent | Notes |
|---|------------|---------------|-------------|---------|------------|----------------|-------|-------|
| 1 | YYYY-MM-DD | HH:MM         | _open_      | _open_  | _open_     | _open_         | 3D Print Operator | Project scaffolded |

**Totals:** Active time across all sessions = `00:00`
First session: `YYYY-MM-DD`  ·  Last session: `YYYY-MM-DD`
```

Use **today's date** and **current local time** for the start. Leave the
"_open_" placeholders — they get filled in when the session ends.

## After creating files

1. Commit immediately so the open session row is recorded:
   ```
   git add printing/<project-slug>/
   git commit -m "scaffold: new print project <project-slug>"
   ```
2. Ask the user the first real question (usually about the part's purpose,
   loads, or environment) so you can help them fill in `0001-material-and-orientation.md`.
3. Hand control back to the **3D Print Operator** agent for the actual
   slicing / printing work.

## Reminders

- **Never skip `decisions/`.** Even if the user says "it's just a quick
  print", create the folder and the 0001 file. They can leave it as
  "default profile, no decisions to record" — but the structure exists
  for when something IS worth recording.
- **Slug must be lowercase-hyphenated.** Reject `MyProject`, `my project`,
  `My_Project`. Accept `my-project`.
- **Don't pre-fill the decision** with your guesses. Lay out the options,
  let the user choose. The whole point of a decision file is the human
  made the call deliberately.
