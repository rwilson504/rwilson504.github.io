---
name: domain-topic-qualifier
description: 'One sentence describing what this skill does and when to use it. Start with what it generates/renders/configures, then list trigger phrases prefixed with "USE FOR:" so agents can match user requests against it. Keep under ~300 chars.'
---

# Skill Title (Human-Readable)

> **Prerequisite:** (Optional.) Load `<other-skill>` first if this skill builds
> on another. Delete this block if the skill is standalone.

## Purpose
One paragraph: what this skill produces or guides, who consumes it, and where
its outputs end up (HTML pages, Python scripts, config files, etc.).

## Source of Truth (Optional)

If this skill is the canonical reference for a set of values (dimensions,
coordinates, API surface, command list), say so explicitly. List which other
skills consume these values so cross-references are obvious.

> Example: This skill is the source of truth for board dimensions and mounting
> hole positions. `cad-enclosure-3dprint` and `electronics-pcb-components`
> reference these values.

## Core Concepts / API / Reference

The actual content of the skill. Common section types:

- **Idioms** — the right way to do common operations
- **Gotchas** — what goes wrong and how to fix it
- **Reference tables** — values, mappings, dimensions
- **Patterns** — copy-pasteable code or markup snippets

Use ## for top-level sections, ### for subsections. Use tables liberally for
reference material. Use fenced code blocks with language hints.

## Quick Reference (Optional)

A bug→fix table or cheat sheet that an agent can scan in one pass.

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| ... | ... | ... |

## See Also

- Official docs: <https://...>
- Related skill: `<other-skill>` (what it covers that this doesn't)

---

## How to use this template

1. Copy this folder to a new location: `.github/skills/<your-skill-name>/`
2. Rename `SKILL.md` stays as `SKILL.md`
3. Update `name:` in frontmatter to **match the folder name exactly**
4. Pick a name that follows `<domain>-<topic>[-<qualifier>]` — see
   [skills README](../README.md)
5. Replace this "How to use this template" section with real content
6. Run the lint script: `pwsh .github/scripts/lint-skills.ps1`
7. Add the skill to any agent that should load it (skill list + dependency
   chain in the agent's `.agent.md` file)
8. If the skill captures a meaningful design decision, add a decision record
9. Commit per the auto-commit rule
10. Push the new skill to the marketplace per the MANDATORY rule:
    `pwsh .github/scripts/sync-agents.ps1 -Push -Message "skill(<name>): initial"`
