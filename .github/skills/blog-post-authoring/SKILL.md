---
name: blog-post-authoring
description: "Create, draft, edit, or review blog posts for rwilson504.github.io, including when invoked from another repo. Use when: writing a blog post, creating an article from repo context, converting notes into a post, choosing blog tags/categories, matching Richard Wilson's blog tone, Astro blog frontmatter, finding the rwilson504.github.io clone, hero image handoff, or technical article structure."
argument-hint: "Topic, notes, target audience, category, and any screenshots/code snippets"
---

# Blog Post Authoring

Use this skill to create or revise posts for the **rwilson504.github.io** blog so they match its Astro content schema, article structure, tagging style, and practical technical voice.

## Home Repository

This skill's publishing target is always the blog repository:

- Repository: `rwilson504/rwilson504.github.io`
- Expected clone folder name: `rwilson504.github.io`
- Blog post folder: `src/content/blog`
- Hero image folder: `public/heroes`
- Body image folder: `public/images/<post-slug>`
- Schema file: `src/content.config.ts`
- Build command: `npm run build`

If this skill is invoked from another repository, treat that repository as the **source-context repo**, not the publishing destination. Draft from the local source context there, but move the final article into a clone of `rwilson504/rwilson504.github.io` for review, validation, and hero-image work.

To find the blog clone on Windows, search common code roots for the folder or remote:

```powershell
Get-ChildItem D:\Code,C:\Code,$HOME -Directory -Recurse -Filter rwilson504.github.io -ErrorAction SilentlyContinue
```

If folder names are not enough, identify the repo by markers: `astro.config.mjs`, `src/content.config.ts`, `src/content/blog`, `.github/skills/blog-post-authoring/SKILL.md`, and a Git remote containing `rwilson504/rwilson504.github.io`.

## Cross-Repo Authoring Pattern

Use this pattern when the topic context lives in another repo:

1. In the source-context repo, inspect the relevant code, README files, screenshots, issues, scripts, or implementation notes.
2. Draft the article from that evidence using the tone and structure in this skill. Keep secrets, private URLs, tenant IDs, customer names, and unreleased details out of the post.
3. Locate and open the `rwilson504/rwilson504.github.io` clone.
4. Create or update the final post under `src/content/blog/<slug>.md` or `.mdx` in the blog repo.
5. Copy any article screenshots into `public/images/<slug>/` in the blog repo and update Markdown paths to `/images/<slug>/...`.
6. Review the article inside the blog repo against [blog-style-guide.md](./references/blog-style-guide.md), existing related posts, and the Astro schema.
7. After the article is written, use the **blog-hero-image-authoring** skill in the blog repo to review existing hero images and generate/wire a matching `heroImage` and `heroImageAlt`.
8. Validate in the blog repo with `npm run build` before finishing.

## Workflow

1. Gather the topic, audience, source notes, screenshots, code snippets, and whether this is a new article or an update to an existing post.
2. If working from another repo, first mine that repo for the concrete implementation details, then switch to the `rwilson504/rwilson504.github.io` clone for final placement and validation.
3. Review nearby or related posts in `src/content/blog` before drafting. Prefer recent posts for tone and structure, and older posts for migrated troubleshooting-note compatibility.
4. Choose the content shape:
   - Troubleshooting fix: symptom, observed behavior, trigger/root cause, confirmation steps, fix, checklist, wrap-up.
   - How-to guide: introduction/context, prerequisites, numbered setup sections, validation, references.
   - Pattern or best-practice article: problem, pattern, why it works, implementation steps, tradeoffs, conclusion.
   - Product/tool announcement: what it is, why it matters, concrete usage scenarios, links, conclusion.
5. Create the post file in `src/content/blog` using a lowercase kebab-case slug that matches the final title closely.
6. Use the frontmatter schema and style guidance in [blog-style-guide.md](./references/blog-style-guide.md).
7. Start from [blog-post-template.md](./assets/blog-post-template.md) when creating a fresh article.
8. After the article draft is stable, use the blog repo's hero image workflow to create or select a matching image. Place the public path in `heroImage` and write specific `heroImageAlt` text. If no hero exists yet, leave both fields out until the hero image is ready.
9. Use Markdown headings, lists, callouts, screenshots, tables, and fenced code blocks in the same practical style as existing posts.
10. Validate with `npm run build` after creating or editing content. Fix Astro schema, Markdown, or content errors before finishing.

## Frontmatter Rules

Every post must include:

```yaml
---
title: "Clear Article Title"
description: "One or two sentence summary used for SEO and previews."
pubDate: 2026-07-15
category: power-apps
tags:
  - "power-platform"
  - "dataverse"
draft: false
---
```

Allowed categories are `power-apps`, `ai`, `electronics`, `3d-printing`, `windows`, `dev-tools`, `personal`, and `misc`.

Optional fields:

```yaml
updatedDate: 2026-07-15
heroImage: "/heroes/example-slug.png"
heroImageAlt: "Specific description of the hero image."
originalBloggerUrl: /2026/07/example-slug.html
```

Use `originalBloggerUrl` only for migrated Blogger posts or when intentionally preserving a legacy URL.

## Voice

Write like an experienced practitioner documenting what actually worked. Be direct, specific, and useful. Prefer first-person context when it helps explain why the solution exists: "I ran into this while...", "In my testing...", "The confusing part was...".

Avoid marketing fluff. The post should quickly give readers enough context to recognize their problem and enough concrete detail to try the fix or pattern themselves.

## Done Criteria

- The post has valid frontmatter and an appropriate category.
- Tags are lowercase, practical, and consistent with existing vocabulary.
- The first screen establishes the problem, scenario, or value without a generic preamble.
- Code blocks are fenced and command examples are copyable.
- Screenshots use paths under `/images/<slug>/...` and meaningful alt text where possible.
- Cross-repo drafts have been moved into the `rwilson504/rwilson504.github.io` clone before final validation.
- Hero image review/generation has been handled from the blog repo using the blog hero image skill when a new hero is needed.
- External references are included when the article depends on docs, tools, or upstream behavior.
- `npm run build` completes successfully.