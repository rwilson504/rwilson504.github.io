# Repo-wide instructions for AI agents

These instructions apply to every agent and chat session that touches this repository.

---

<!-- BEGIN: marketplace-sync (managed by agent-plugins-personal bootstrap) -->
## MANDATORY: Agents and skills are edited in the marketplace clone

This repo contains **no** `.github/agents/`, `.github/skills/`, or
`.github/prompts/`. All of it lives in the
[agent-plugins-personal](https://github.com/rwilson504/agent-plugins-personal)
clone, registered once per machine as a local agent plugin:

```jsonc
// VS Code USER settings
"chat.pluginLocations": {
  "<clone>/local-plugin": true
}
```

`local-plugin/skills` and `local-plugin/agents` are directory links into
`<clone>/src/`, so an edit in the clone is live in every workspace with no
build and no sync. Run `pwsh <clone>/scripts/setup-machine.ps1` on a new
machine.

### The rule (non-negotiable)

After **every** edit to a skill or agent, commit and push **in the clone**,
in the same response, before moving on:

```powershell
cd <clone>
pwsh scripts/build-plugins.ps1   # only if plugins.yml changed
pwsh scripts/lint.ps1
git add -A
git commit -m "skill(<name>): ..."   # or "agent: ..."
git push origin main
```

An uncommitted edit in the clone is invisible - the clone is usually not
open in any window, so nothing surfaces the change. **Always report the
clone's `git status` when you finish editing a skill or agent.**

Do NOT recreate `.github/skills/` or `.github/agents/` here. A workspace
copy shadows the plugin one (workspace wins for skills; agents list twice),
which reintroduces the drift this layout removed. If this repo is public,
a copy also republishes a private marketplace - that has happened once.

### Reusable prompts are skills

VS Code registers a plugin's `commands/` folder in the slash-command picker
but **never injects the command body**, so plugin commands are unusable as
prompts. Author reusable prompts as skills instead - skills load their body
on demand and also appear under `/`.

A genuinely repo-specific prompt can still live in this repo's
`.github/prompts/`, but nothing reusable belongs there.

### New skills must be added to a plugin

A skill missing from `<clone>/plugins.yml` still works on your own machine
(the whole `src/skills` tree is hosted) but reaches nobody who installs a
plugin. The lint warning is easy to skim past:

```
WARN skill '<name>' is not included in any plugin
```
<!-- END: marketplace-sync -->
