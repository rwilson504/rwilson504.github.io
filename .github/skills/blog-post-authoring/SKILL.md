---
name: blog-post-authoring
description: "Create, draft, edit, or review blog posts for rwilson504.github.io, including when invoked from another repo. Use when: writing a blog post, creating an article from repo context, converting notes into a post, choosing blog tags/categories, matching Richard Wilson's blog tone, Astro blog frontmatter, D2 diagrams/process flows, finding the rwilson504.github.io clone, hero image handoff, or technical article structure."
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
- Diagram support: D2 diagrams in `.mdx` posts using fenced `d2` code blocks rendered by `astro-d2`
- Schema file: `src/content.config.ts`
- Build command: `npm run build`
- Scheduled publishing: posts render only when `draft: false` and `pubDate` is not in the future; the GitHub Pages workflow rebuilds daily.
- External link checker: [check-post-links.ps1](./scripts/check-post-links.ps1)
- Image accessibility checker: [check-post-image-alt.ps1](./scripts/check-post-image-alt.ps1)

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
4. Create or update the final post under `src/content/blog/<slug>.md` or `.mdx` in the blog repo. Use `.mdx` when the article includes D2 diagrams or imported Astro components.
5. Copy any article screenshots into `public/images/<slug>/` in the blog repo and update Markdown paths to `/images/<slug>/...`.
6. Review the article inside the blog repo against [blog-style-guide.md](./references/blog-style-guide.md), existing related posts, and the Astro schema.
7. After the article is written, use the **blog-hero-image-authoring** skill in the blog repo to review existing hero images and generate/wire a matching `heroImage` and `heroImageAlt`.
8. Check body image alt text for 508/WCAG non-text content coverage with [check-post-image-alt.ps1](./scripts/check-post-image-alt.ps1).
9. Check external internet links from the blog repo with [check-post-links.ps1](./scripts/check-post-links.ps1) before publishing.
10. Validate in the blog repo with `npm run build` before finishing.

## Workflow

1. Gather the topic, audience, source notes, screenshots, code snippets, and whether this is a new article or an update to an existing post.
2. If working from another repo, first mine that repo for the concrete implementation details, then switch to the `rwilson504/rwilson504.github.io` clone for final placement and validation.
3. Review nearby or related posts in `src/content/blog` before drafting. Prefer recent posts for tone and structure, and older posts for migrated troubleshooting-note compatibility.
4. Choose the content shape:
   - Troubleshooting fix: symptom, observed behavior, trigger/root cause, confirmation steps, fix, checklist, wrap-up.
   - How-to guide: introduction/context, prerequisites, numbered setup sections, validation, references.
   - Pattern or best-practice article: problem, pattern, why it works, implementation steps, tradeoffs, conclusion.
   - Product/tool announcement: what it is, why it matters, concrete usage scenarios, links, conclusion.
5. Put the most valuable information up front: start with a clear problem statement, then a short `## Bottom line` / BLUF section with the fix, command, setting, or decision before the deep dive.
6. Create the post file in `src/content/blog` using a lowercase kebab-case slug that matches the final title closely. Use `.mdx` instead of `.md` when the post includes D2 diagrams or Astro components.
7. Use the frontmatter schema and style guidance in [blog-style-guide.md](./references/blog-style-guide.md).
8. Start from [blog-post-template.md](./assets/blog-post-template.md) when creating a fresh article.
9. After the article draft is stable, use the blog repo's hero image workflow to create or select a matching image. Place the public path in `heroImage` and write specific `heroImageAlt` text. If no hero exists yet, leave both fields out until the hero image is ready.
10. Use Markdown headings, lists, callouts, screenshots, tables, diagrams, and fenced code blocks in the same practical style as existing posts.
11. Check body image alt text for Section 508/WCAG accessibility before publishing:

```powershell
.\.github\skills\blog-post-authoring\scripts\check-post-image-alt.ps1 -Path .\src\content\blog\<slug>.md
```

For every missing or weak body image alt, inspect the image file and read the surrounding paragraph/list/heading before writing alt text. Describe the information the reader needs from the image in that article context, not every visual detail.

12. Check all external `http` and `https` links before publishing:

```powershell
.\.github\skills\blog-post-authoring\scripts\check-post-links.ps1 -Path .\src\content\blog\<slug>.md
```

13. Validate with `npm run build` after creating or editing content. Fix Astro schema, Markdown, or content errors before finishing.

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

Scheduled publishing rule:

- Use `draft: true` for incomplete/private work that should never publish.
- Use `draft: false` with a future `pubDate` to schedule a finished article. The site filters future dates out of pages, RSS, tags, categories, search index, and legacy redirects until a scheduled rebuild runs after the date arrives.
- The GitHub Pages workflow rebuilds daily at 06:00 UTC, so a future-dated post normally appears on the next scheduled build after its `pubDate` is due.

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

## Up-Front Value / BLUF

Most posts should be useful as a future reference, so put the payoff near the top. After the opening problem statement, add a short `## Bottom line` section before the detailed explanation.

Use this pattern for troubleshooting, setup, and fix posts:

1. Opening paragraph: what broke, where, and why the reader should recognize the scenario.
2. `## Bottom line`: the fix or answer in one to three bullets, commands, settings, or a short code/config snippet.
3. Deep dive: observations, why it happens, screenshots, diagrams, implementation details, and validation.

The bottom line should be specific enough that a returning reader can solve the issue without rereading the full post. Avoid vague summaries like "check your configuration." Prefer concrete fixes like `Build FullPath as container/folder/file with forward slashes`.

## Link Checking

Before publishing or flipping `draft` to `false`, verify every external internet link in the post. Local image paths are covered by content review and the site build, but external docs, GitHub, product pages, and reference links need an explicit check.

Run:

```powershell
.\.github\skills\blog-post-authoring\scripts\check-post-links.ps1 -Path .\src\content\blog\<slug>.md
```

Treat broken links as publish blockers. Fix the URL, replace it with a current source, or remove the reference. If a valid site blocks automated checks but opens manually, mention that in the final response and include the exact URL that needed manual verification.

## 508 Image Accessibility

Before publishing or flipping `draft` to `false`, check body image alt text. Hero images render their alt text from the article title, so this check focuses on Markdown body images and screenshots.

Run:

```powershell
.\.github\skills\blog-post-authoring\scripts\check-post-image-alt.ps1 -Path .\src\content\blog\<slug>.md
```

Treat missing or weak body image alt text as a publish blocker. Weak alt text includes empty text, `image`, `screenshot`, `test`, timestamp/file-name style text, and `enter image description here`.

When a body image needs alt text:

1. Open or view the actual image from `public/images/<slug>/...`.
2. Read the heading, paragraph, list item, or step immediately around the image.
3. Write alt text that captures the image's purpose in context. For screenshots, identify the UI/page/dialog and the relevant state or setting.
4. Avoid starting with "image of" or "screenshot of" unless the medium itself matters.
5. Keep it concise, usually one sentence.

Examples:

- `Azure DevOps service connection wizard with Workload Identity Federation selected.`
- `SSIS data flow path showing the Data Viewer indicator icon between two components.`
- `KingswaySoft Azure Blob Destination editor showing the Blob Name field set to a folder path instead of a file path.`

## Diagrams And Process Flows

The blog supports D2 diagrams through `astro-d2`. Use D2 when a concept is clearer as a process flow, architecture map, routing model, state transition, or relationship diagram than as prose or a screenshot.

Use `.mdx` for posts that include diagrams. Add fenced D2 blocks directly in the article:

````markdown
```d2
direction: right

source: "Source system"
transform: "Transform"
viewer: "Data Viewer"
destination: "Destination"

source -> transform: "rows"
transform -> viewer: "inspect runtime values"
viewer -> destination: "continue package"
```
````

Guidelines:

- Keep diagrams small and purposeful: 4 to 8 nodes is usually enough.
- Prefer clear labels over clever shapes.
- Put the main takeaway in nearby prose before or after the diagram. This helps accessibility because generated SVG diagrams may not fully communicate structure to assistive technologies.
- Do not encode secrets, tenant IDs, customer names, private hostnames, or production URLs in diagrams.
- Validate with `npm run build`; D2 syntax errors surface at build time.
- Existing examples live in `src/content/blog/synology-chat-multi-user-openclaw.mdx`.

## Done Criteria

- The post has valid frontmatter and an appropriate category.
- Tags are lowercase, practical, and consistent with existing vocabulary.
- The first screen establishes the problem, scenario, or value without a generic preamble.
- Troubleshooting/reference posts include a `## Bottom line` or equivalent BLUF section near the top with the fix or answer before the deep dive.
- Code blocks are fenced and command examples are copyable.
- Screenshots use paths under `/images/<slug>/...` and meaningful alt text where possible.
- D2 diagrams are used when a process flow or architecture view would clarify the article, and the surrounding prose explains the diagram's key takeaway.
- Body image alt text has been checked with [check-post-image-alt.ps1](./scripts/check-post-image-alt.ps1), and each missing or weak alt was replaced after evaluating the image and surrounding article context.
- Cross-repo drafts have been moved into the `rwilson504/rwilson504.github.io` clone before final validation.
- Hero image review/generation has been handled from the blog repo using the blog hero image skill when a new hero is needed.
- External references are included when the article depends on docs, tools, or upstream behavior.
- External internet links have been checked with [check-post-links.ps1](./scripts/check-post-links.ps1), and any failures were fixed or explicitly called out.
- `npm run build` completes successfully.