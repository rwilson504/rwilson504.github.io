# Repo-wide instructions for AI agents

Rules about where skills and agents live, the continuous learning loop, and
verify-before-asserting come from `marketplace.instructions.md` in the
agent-plugins-personal clone, loaded via `chat.instructionsFilesLocations`.
They are not repeated here.

This repo stores no skills, agents or prompts. The blog skills
(`blog-post-authoring`, `blog-hero-image-authoring`) live in that clone -
edit them there, and commit and push in the clone.

Open `blog.code-workspace` rather than the folder so the clone's pending
changes appear in Source Control.

This repo is **public**. Never create `.github/skills/` or `.github/agents/`
here: a copy shadows the plugin one and republishes a private marketplace.
That has happened once.

For the same reason this repo keeps **no `SESSION_LOG.md`**, overriding the
machine-level default. Working notes about the blog belong in the
agent-plugins-personal clone's session log, not published here. Durable
decisions may still be recorded in `decisions/`.
