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

The blog skills (`blog-post-authoring`, `blog-hero-image-authoring`) are
published and live in the clone now. After **every** edit to a skill or
agent, commit and push **in the clone**, in the same response:

```powershell
cd <clone>
pwsh scripts/lint.ps1
git add -A
git commit -m "skill(<name>): ..."
git push origin main
```

The clone is usually not open in any window, so an uncommitted edit there
is invisible. **Always report the clone's `git status` when you finish
editing a skill or agent.**

Do NOT recreate `.github/skills/` or `.github/agents/` here. A workspace
copy shadows the plugin one and goes stale unnoticed - and because this
repo is **public**, a copy here republishes a private marketplace. That
has happened once already.

### Reusable prompts are skills

VS Code registers a plugin's `commands/` folder in the slash-command picker
but never injects the command body, so plugin commands are unusable as
prompts. Author reusable prompts as skills instead.
<!-- END: marketplace-sync -->
