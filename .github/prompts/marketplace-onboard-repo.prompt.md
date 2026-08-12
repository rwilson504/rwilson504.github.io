---
description: 'Onboard an existing repo to the agent-plugins-personal marketplace: install the sync tooling, then migrate that repo''s existing agents/skills/prompts up into the marketplace without clobbering content owned by other repos. Use once per new consumer repo.'
argument-hint: '<path to the repo> (e.g. D:\Code\my-blog) + which skills to publish'
---

# Onboard a repo to the agent marketplace

You are connecting an **existing** repo (one that already has its own
agents/skills/prompts) to the shared marketplace at
`https://github.com/rwilson504/agent-plugins-personal`, so its
customizations can be published and consumed like this repo's are.

`bootstrap.ps1` in the marketplace handles the *consuming* direction. The
work this prompt adds is the *publishing* direction: getting content that
already exists locally safely into the marketplace.

## Before you touch anything: the destructive-push check

**This is the step that can destroy other repos' work.** Do it first.

`sync-agents.ps1 -Push` copies local content into the marketplace. Older
copies of that script **also deleted** anything in the marketplace not
present locally. A repo with three blog skills would wipe every CAD,
electronics and printing skill on its first push.

```powershell
Select-String -Path <repo>/.github/scripts/sync-agents.ps1 -Pattern 'NoDelete' -Quiet
```

- `True` → the script is additive; safe to continue.
- `False` → **stop.** Re-run `bootstrap.ps1` to pick up the current version,
  then re-check. Do not push until this returns `True`.

Also confirm `-Check` treats marketplace-only items as informational rather
than drift; otherwise the pre-push hook will block every push in the new
repo over content it doesn't own.

## Steps

### 1. Inventory what the repo already has

List `.github/agents/`, `.github/skills/`, `.github/prompts/` in the target
repo. For each item, ask the user explicitly:

- **Publish it** — genuinely reusable across repos.
- **Keep it local** — repo-specific and not worth sharing.

Do not assume everything should be published. A skill encoding one blog's
folder layout helps nobody else and adds noise to every consumer.

### 2. Check for name collisions

Compare against the marketplace's `src/skills/`, `src/agents/`,
`src/prompts/`. A local skill sharing a name with a marketplace skill will
**overwrite it** on push.

If a name collides, resolve it before pushing — usually by renaming the
local one to follow `<domain>-<topic>[-<qualifier>]`. Skills from a blog
repo will typically want a `blog-` or `writing-` prefix.

### 3. Run the bootstrap

```powershell
pwsh <marketplace>/bootstrap.ps1 -RepoRoot <repo>
```

This installs `sync-agents.ps1`, `install-hooks.ps1`, the pre-push hook and
the CI workflow, gitignores `.marketplace-cache/`, appends the
marketplace-sync section to `copilot-instructions.md`, and pulls current
marketplace content down.

> **`-Pull` is a true mirror and will delete local agents/skills/prompts
> that the marketplace doesn't have.** If the repo's own skills are not yet
> published, run with `-SkipPull` first, publish them (step 4), and only
> then pull. Otherwise the pull erases exactly the work you are trying to
> onboard. Commit the repo's existing customizations to git beforehand
> regardless.

### 4. Publish the repo's own content

```powershell
pwsh .github/scripts/sync-agents.ps1 -Check          # review the diff first
pwsh .github/scripts/sync-agents.ps1 -Push -Message "skill(<name>): publish from <repo>"
```

Expect `-Check` to list everything already in the marketplace as
"not present locally" — that is normal and not drift.

### 5. Add published skills to a plugin

**The push does not do this, and the lint warning is easy to miss.**
A skill that isn't in a plugin ships to the marketplace but reaches no CLI
install. Watch for:

```
WARN skill '<name>' is not included in any plugin
```

Fix it in the marketplace repo's `plugins.yml` — either add the skill to an
existing plugin or create a new one for this domain — then:

```powershell
cd .marketplace-cache
pwsh scripts/build-plugins.ps1
pwsh scripts/lint.ps1
git add -A ; git commit -m "plugins: add <name> to <plugin>" ; git push
```

### 6. Verify both directions

```powershell
pwsh .github/scripts/sync-agents.ps1 -Check   # expect: In sync with marketplace
```

Then confirm from this repo (or any other consumer) that a `-Pull` brings
the newly published skills down, and that nothing previously in the
marketplace disappeared. Compare the marketplace's skill count before and
after — it should have **grown**, never shrunk.

### 7. Update the repo's index

If the target repo has an `AGENTS.md` or equivalent index, add the newly
published items to it, and note that `.github/` is now mirrored from the
marketplace and that the mandatory push rule applies there too.

## Report back

- Which items were published, and which were deliberately kept local
- Any renames made to avoid collisions
- Which plugin each published skill landed in
- Marketplace skill count before → after (must not shrink)
