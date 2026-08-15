---
title: "One Clone, Every Session: Sharing Copilot Agents and Skills Across VS Code and the CLI"
description: "How I develop custom Copilot agents, skills, and instructions in a single repo, and host them so every VS Code workspace and every Copilot CLI session on the machine reads the same files — with no copies in any project repo."
pubDate: 2026-08-15
category: dev-tools
tags:
  - github-copilot
  - copilot-cli
  - vs-code
  - ai
  - agents
  - skills
  - powershell
  - automation
draft: true
---

I write a lot of custom Copilot customizations: agents for CAD modeling, KiCad PCB work, 3D print operation, blog authoring, and a pile of skills that encode the things I keep re-learning. For a long time those files were copied into every repo that needed them, kept in sync by a script, guarded by a pre-push hook and a CI job whose only purpose was to detect drift.

That design failed in the way copy-based designs usually fail. Every repo carried ~90 files it did not write. The copies drifted. And eventually a **public** repo of mine republished the contents of a **private** customization repo, where it sat for two days before anyone noticed.

So I rebuilt it around a single rule: **one clone, no copies anywhere**. This post covers the authoring process first, because that is the part that actually keeps the content good, then the repo layout and the exact settings that make one clone serve both VS Code and the GitHub Copilot CLI.

## Bottom line

- **Edit exactly one place** — a `src/` folder in a single clone. Every other location is a directory link (junction/symlink) pointing back at it, so there is no build step and nothing that can go stale.
- **Each component gets exactly one host per surface.** Host something in two places and it loads twice — agents show up duplicated in the VS Code picker.
- **VS Code and the CLI read different locations**, and only partially overlap:

  | Component | VS Code reads | Copilot CLI reads |
  |---|---|---|
  | Skills | a plugin folder via `chat.pluginLocations` | `skillDirectories` in `~/.copilot/settings.json` |
  | Agents | `~/.copilot/agents` | `~/.copilot/agents` |
  | Instructions | `~/.copilot/instructions` | `~/.copilot/instructions` |

- **The CLI's parser is stricter than VS Code's**, and it fails silently. Quote any skill `description` containing `': '`, and keep it at or under 1024 characters.
- **Lint the rules you learn.** Every silent failure below became a check in a lint script, because none of them announce themselves.

Verified against VS Code 1.133.0, GitHub Copilot CLI 1.0.81-0, PowerShell 7.6.3, Windows 11.

## Part I — The process

The layout matters less than the loop that maintains it. Six practices do most of the work.

### 1. One source of truth, and links everywhere else

Everything is authored under `src/` in one clone:

```text
src/
├── agents/         <name>.agent.md
├── skills/         <name>/SKILL.md
└── instructions/   <name>.instructions.md
```

Nothing else is ever edited. Every consuming location is a *link* to one of those folders, not a copy. This is the whole design in one sentence, and it removes an entire category of problem: there is nothing to sync, so there is nothing to drift, and no project repo contains a skill so no project repo can leak one.

### 2. Codify the lesson, not just the fix

The rule I get the most value from: **when a fix took three or more back-and-forth attempts, or the root cause contradicted an earlier assumption, write it into the relevant skill before moving on.** Symptom, root cause, how to detect it, the fix, and a guardrail.

This is what turns a skill from a static how-to into something that compounds. A representative example, from a KiCad scripting skill:

> **The ratsnest lies — read live tracks first.** `board.GetRatsnest()` reflects the netlist, not what is actually routed. Dump `board.Tracks()` by net before concluding a connection is missing.

That is three hours of confusion compressed into two sentences that now load automatically whenever I touch that domain.

Critically, these lessons go into the **skill file**, not into agent memory. Memory is invisible to other sessions, other machines, and anyone else consuming the content. A skill file is reviewable, diffable, and shared.

### 3. Verify before asserting

A machine-level instruction file, applied to every workspace, contains this rule:

> Prefer a cheap empirical check over documented behaviour. When a claim can be tested with one command, test it rather than asserting it.

Almost everything in Part III came from testing rather than reading. Several documented-looking assumptions turned out to be wrong, and the failures were silent in both directions — which is precisely why guessing is expensive here.

### 4. Read `git status` before reviewing a file

This one cost me real work, so it earned its own rule.

A working tree can be **older** than `HEAD`. If a stale editor buffer gets saved over a newer commit, the file silently reverts, and reviewing it produces confident, wrong conclusions about missing features. I once reported a "code gap" in a script that had already been fixed two commits earlier — I was reading a reverted working tree.

The tell is mechanical:

```powershell
# Several files sharing one mtime to the second, and:
git diff --stat <older-commit> -- <files>
```

If that diff is **empty**, the working tree is a bulk overwrite of an earlier state, not new work. Restore it with `git checkout -- <files>`. Committing it would erase every commit in between.

### 5. Lint every silent failure

Every rule discovered the hard way becomes a check. The lint script validates that frontmatter parses as strict YAML, that a skill's folder name matches its `name:` field, that descriptions are within the CLI's limit, and that generated output is in sync with source:

```text
Marketplace lint PASSED (7 agent(s), 48 skill(s), 7 plugin(s))
```

The frontmatter check earns its keep. VS Code's parser is lenient enough to load files the CLI rejects, so without it, a skill can work in the editor for months while being completely invisible to the CLI.

### 6. Make the clone's pending changes visible

The clone usually is not the window you have open, so an uncommitted skill edit there is invisible. Two things fix that.

A **multi-root workspace** puts the clone in Source Control alongside whatever you are actually working on:

```jsonc
{
  "folders": [
    { "name": "my-project", "path": "." },
    { "name": "agent-plugins", "path": "C:/code/agent-plugins" }
  ]
}
```

Open the `.code-workspace` file rather than the folder. Worth knowing: `git.scanRepositories` looks like the lighter answer and **does not work** for this — I tried the clone path directly, its parent, and `git.autoRepositoryDetection`, and the repository never appeared.

The second mechanism is a `SessionStart` hook that reports uncommitted changes in the clone and stays silent when it is clean. More on its surprisingly fiddly contract in Part IV.

## Part II — The repo

```text
agent-plugins/
├── plugins.yml            single source of truth for plugin composition
├── src/                   canonical source — edit here only
│   ├── agents/
│   ├── skills/
│   └── instructions/
├── local-plugin/          machine-level host plugin
│   ├── plugin.json
│   ├── scripts/report-clone-status.ps1
│   ├── skills  -> src/skills      link, gitignored
│   └── hooks.json                 generated, gitignored
├── plugins/               GENERATED build output — never edited by hand
├── scripts/
│   ├── setup-machine.ps1  create links + register both surfaces
│   ├── build-plugins.ps1  regenerate plugins/ from src/
│   └── lint.ps1
└── .github/plugin/marketplace.json   GENERATED
```

Two distribution channels come out of the same source:

1. **Machine-level hosting** — the links described below. This is what I actually use day to day.
2. **Copilot CLI plugins** — `plugins/` plus a `marketplace.json`, built from `plugins.yml`, for sharing with other people.

`plugins.yml` maps source files into installable plugins:

```yaml
plugins:
  my-cad:
    description: CAD authoring with build123d — parametric modeling, render/print workflows.
    version: 0.1.0
    keywords: [cad, build123d, parametric]
    agents:
      - cad-builder
    skills:
      - cad-build123d-general
      - cad-render-images
```

A skill can appear in several plugins. Copilot CLI plugins have no dependency mechanism, so the build script duplicates shared skills into each plugin folder — the single source stays `src/skills/<name>/`.

One warning worth internalizing: a skill missing from `plugins.yml` **still works on your own machine**, because the whole `src/skills` tree is hosted. It just reaches nobody who installs a plugin. The only signal is a lint warning that is very easy to scroll past:

```text
WARN skill '<name>' is not included in any plugin
```

## Part III — Hosting one clone on both surfaces

Here is the shape. Everything on the left is authored once; everything in the middle is a link; both surfaces read from the middle.

```d2
direction: right

clone: "One clone\nsrc/skills · src/agents · src/instructions" {
  style: { stroke: "#0969da"; stroke-width: 2 }
}

plugin: "local-plugin/skills\n(link)" {
  style: { stroke: "#9a6700" }
}
agents: "~/.copilot/agents\n(link)" {
  style: { stroke: "#9a6700"; stroke-width: 2 }
}
instr: "~/.copilot/instructions\n(link)" {
  style: { stroke: "#9a6700"; stroke-width: 2 }
}

vscode: "VS Code" {
  style: { stroke: "#1a7f37"; stroke-width: 2 }
}
cli: "Copilot CLI" {
  style: { stroke: "#bf3989"; stroke-width: 2 }
}

clone -> plugin
clone -> agents
clone -> instr
clone -> cli: "skillDirectories"

plugin -> vscode: "chat.pluginLocations"
agents -> vscode
agents -> cli
instr -> vscode
instr -> cli
```

The two `~/.copilot` links each feed **both** surfaces, which is the point: agents and instructions are configured once and work in the editor and the terminal. Skills are the exception — they take a different route to each surface, and that asymmetry is deliberate.

### Skills: a plugin for VS Code, a setting for the CLI

VS Code loads skills from a plugin folder registered by absolute path:

```jsonc
// VS Code USER settings.json
"chat.pluginLocations": {
  "C:/code/agent-plugins/local-plugin": true
}
```

The CLI ignores that setting entirely and uses its own:

```powershell
copilot skill add C:\code\agent-plugins\src\skills
```

That writes `skillDirectories` into `~/.copilot/settings.json`. Let the CLI write it rather than editing the file yourself — that file is **JSONC**, and hand-rewriting it strips every comment. I made exactly that mistake, assuming it was plain JSON.

Because each surface reads a different location, neither one sees the skills twice. That is why skills can stay in the plugin while agents cannot.

### Agents and instructions: one shared location

Both live under `~/.copilot`, which VS Code and the CLI both read natively — no setting on either side:

```text
~/.copilot/agents        ->  <clone>/src/agents
~/.copilot/instructions  ->  <clone>/src/instructions
```

On Windows those are junctions:

```powershell
New-Item -ItemType Junction -Path "$HOME\.copilot\agents" -Target "C:\code\agent-plugins\src\agents"
```

**Do not also declare agents in the plugin manifest.** I did, and every agent appeared *twice* in the VS Code picker, because the plugin and `~/.copilot/agents` are two hosts for one component. The host plugin now declares `skills` only.

An instruction file with `applyTo: "**"` in that folder applies in every workspace on the machine, live, with no per-repo copy:

```markdown
---
applyTo: "**"
description: Universal rules that apply in every workspace on this machine.
---
```

You can confirm the CLI sees it:

```text
$ copilot plugins list --kind instruction
Instructions:
  User:
    ✓ .copilot/instructions
```

### What each surface actually reads

Tested rather than assumed. **Bold** marks the rows this layout uses.

| Source | VS Code | Copilot CLI |
|---|---|---|
| **Skills** | | |
| `.github/skills/` (workspace) | yes | yes |
| `chat.agentSkillsLocations` setting | yes (`~/` paths only) | no |
| **CLI `skillDirectories`** | **no** | **yes** |
| **Plugin `skills/` folder** | **yes** | only with `--plugin-dir` |
| **Agents** | | |
| `.github/agents/` (workspace) | yes | yes |
| **`~/.copilot/agents`** | **yes** | **yes** |
| Plugin `agents/` folder | yes | only with `--plugin-dir`, namespaced |
| **Instructions** | | |
| `.github/copilot-instructions.md`, `AGENTS.md` | yes | yes |
| **`~/.copilot/instructions/`** | **yes** | **yes** |
| `~/.copilot/copilot-instructions.md` | yes | yes |
| `~/.copilot/AGENTS.md` | no | **no** |

Three traps in that table:

- `copilot skill add <dir>` works perfectly for the CLI and **VS Code ignores it entirely**.
- `chat.agentSkillsLocations` rejects absolute paths and backslashes — "Paths must be relative or start with `~/`". `chat.pluginLocations` has no such limit, which is why the plugin route needs no home-directory junction.
- `~/.copilot/AGENTS.md` is **not** read by either surface, even though a repo-level `AGENTS.md` is. Use `~/.copilot/instructions/`.

### Why not just install the plugin into the CLI?

I tried. There is **no `pluginDirectories` setting** — `--plugin-dir` is per-invocation only, and `copilot plugin install` accepts a marketplace, `owner/repo`, or a git URL, not a local folder.

A local directory *can* be registered as a marketplace, either with `copilot plugin marketplace add <path>` or an `extraKnownMarketplaces` entry using `source: "directory"`. Both **install** the plugin into `~/.copilot/installed-plugins/` — real copies, requiring a rebuild and reinstall after every edit. That is the staleness this whole layout exists to remove, so I skipped it.

## Part IV — The silent failures

Every one of these produces no error message anywhere. They look exactly like nothing being configured.

### The CLI skips skills VS Code happily loads

Three of my skills were invisible to the CLI for weeks. `copilot skill list` prints the reason at the *end* of its output:

```text
• …\electronics-kicad-python-scripting\SKILL.md: Skill description must be at most 1024 characters
• …\marketplace-publish\SKILL.md: failed to parse YAML frontmatter: mapping values are not
  allowed in this context at line 2 column 176
```

Two separate rules:

1. **Quote any description containing `': '`.** Unquoted, YAML reads the colon-space as a nested mapping and the whole file fails to parse. Since most skill descriptions include a `USE FOR:` section, this affects nearly all of them.
2. **Keep descriptions at or under 1024 characters.** The CLI enforces a hard limit; VS Code does not.

```yaml
# Fails in the CLI, loads fine in VS Code
description: Publish local agents and skills. USE FOR: onboarding a repo.

# Correct
description: 'Publish local agents and skills. USE FOR: onboarding a repo.'
```

Also worth knowing, because it inverts between surfaces: **VS Code requires the folder name to match the `name:` frontmatter** and skips the skill silently otherwise, while the **CLI uses the frontmatter name and ignores the folder** — so a mismatch shows up as a differently-named skill rather than a missing one.

### The two surfaces need opposite hook contracts

The clone-status hook has to be registered twice, because neither surface reads the other's registration. That part is tedious but obvious. The part that is not obvious:

| | VS Code | Copilot CLI |
|---|---|---|
| Channel | stderr | stdout `{"additionalContext": "..."}` |
| Exit code | **must be non-zero** — output discarded on 0 | **must be 0** — stdout only parsed on 0 |

Those are mutually exclusive. I switched the script to the CLI contract, confirmed the CLI worked, and silently broke VS Code with the same edit. There is no clever single behavior — emitting to both channels does not help, because the exit code alone decides whether VS Code renders anything. The script now takes an `-Emit Stderr|Json` switch and each registration passes what its surface needs.

Two more findings on the CLI hook file:

- **`"version": 1` is required.** Without it the file is rejected with no message at all — not even in the debug log.
- **Exit `2` is not a workaround.** It surfaces stderr, but only on the interactive timeline; nothing appears under `copilot -p`.

`additionalContext` is the durable choice because it reaches the *model*, not just the screen, so it survives non-interactive runs.

### Reusable prompts have to be skills

Neither channel can deliver a prompt body. The CLI plugin spec has no prompt component type, and while VS Code lists a plugin's `commands/` folder in the slash-command picker, it **never injects the command body** — the model receives only the name.

Skills do not have this problem: they load on demand and also appear under `/`. So every reusable prompt is authored as a skill.

### Removing a junction can delete the target

A Windows-specific one worth flagging, because the failure is destructive rather than silent:

```powershell
# DANGEROUS — can traverse into the target and delete the real files
Remove-Item $link -Recurse

# Correct — removes only the reparse point
[System.IO.Directory]::Delete($link, $false)
```

Always verify the source survived.

### Pin the versions you tested

The CLI updates itself by default. It moved from 1.0.72-1 to 1.0.81-0 *during the session in which I wrote this*, so the version I started testing against was not the one I finished on. Given that every failure above is silent, recording the tested versions is not bookkeeping — it is the only way to notice that behavior changed.

## Wrap-up

The copy-based design failed because it made drift possible and then tried to detect it. Linking makes drift impossible, which turns out to be much less work: no sync script, no pre-push hook, no CI drift job, and no repo carrying files it did not write.

If you want to try this, the order that worked for me:

1. Put everything under `src/` in one clone.
2. Link `~/.copilot/agents` and `~/.copilot/instructions` at it. Both surfaces pick those up with no settings at all.
3. Add one `chat.pluginLocations` entry for VS Code skills, and run `copilot skill add` for CLI skills.
4. Write a lint script, and add a check every time something fails silently.
5. Record the versions you verified against.

Then check the result rather than trusting it — `copilot skill list` for load errors, `copilot plugins list --kind instruction` for instruction discovery, and the agent picker in both surfaces to confirm nothing appears twice.

## References

- [GitHub Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [Creating and using custom agents for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)
- [Finding and installing plugins for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing)
- [GitHub Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)
