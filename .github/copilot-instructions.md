# Repo-wide instructions for AI agents

These instructions apply to every agent and chat session that touches this repository.

---

<!-- BEGIN: marketplace-sync (managed by agent-plugins-personal bootstrap) -->
## MANDATORY: Mirror agent / skill / prompt edits to the marketplace

`.github/agents/`, `.github/skills/`, and `.github/prompts/` are mirrored
from the [agent-plugins-personal](https://github.com/rwilson504/agent-plugins-personal)
marketplace. **The marketplace is the source of truth.** A local commit
that is not mirrored is a regression — it breaks every other consumer
repo and every Copilot CLI install.

### The rule (non-negotiable)

After **every** commit that touches a file under
`.github/agents/`, `.github/skills/`, or `.github/prompts/`, the active
agent MUST run the marketplace push **in the same response, before
moving on to anything else**:

```
pwsh .github/scripts/sync-agents.ps1 -Push -Message "<same commit message>"
```

This applies to **every** agent, **every** session, **every** edit
(learning-loop updates, refactors, typos, version bumps — all of it).
There are no exceptions for "small" changes.

### Detection and enforcement

Four layers reinforce the rule:

1. **This instruction** (you are reading it).
2. **`-Check` mode** — `pwsh .github/scripts/sync-agents.ps1 -Check`
   exits 1 with a diff list if local files have drifted from the
   marketplace.
3. **Pre-push git hook** — installed via
   `pwsh .github/scripts/install-hooks.ps1`. When a `git push` includes
   commits that touch agents/skills/prompts, the hook runs `-Check` and
   **blocks the push** if the marketplace is out of sync. Bypass only
   with `git push --no-verify` and only when you've already pushed the
   marketplace from a different machine.
4. **GitHub Actions workflow** — `.github/workflows/marketplace-sync-check.yml`
   runs `-Check` on every push and PR to `main`. This is the CI backstop
   that catches drift even when the local hook was bypassed. PRs cannot
   be merged while this check is failing (configure as a required check
   in branch protection).

If the hook or workflow ever blocks you, the answer is always: run the
`-Push` command above first, then re-push.

### Other useful sync commands

- Pull marketplace changes into this repo (e.g. an edit you made
  elsewhere):
  ```
  pwsh .github/scripts/sync-agents.ps1 -Pull
  ```
- Verify local matches marketplace:
  ```
  pwsh .github/scripts/sync-agents.ps1 -Check
  ```
- One-time per clone — install the pre-push hook:
  ```
  pwsh .github/scripts/install-hooks.ps1
  ```

The local `.marketplace-cache/` clone is gitignored.

### Continuous Learning Loop applies here too

When a fix is "learning-worthy" (3+ back-and-forth prompts, or contradicts
an earlier assumption):

1. Update the most specific `.github/skills/<skill>/SKILL.md` with the
   bug pattern, diagnostic signal, and fix pattern.
2. Commit immediately with `skill(<name>): ...`
3. **Push to the marketplace immediately** (per the rule above) so other
   repos and CLI installs benefit.

Do NOT record lessons only in `/memories/` — those are invisible to
other contributors, sessions, and consumers of the marketplace.
<!-- END: marketplace-sync -->
