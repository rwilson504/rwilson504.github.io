---
name: blog-post-authoring
description: "Create, draft, edit, or review blog posts for rwilson504.github.io. Use when: writing a blog post, creating an article, converting notes into a post, choosing blog tags/categories, matching Richard Wilson's blog tone, Astro blog frontmatter, hero image guidance, or technical article structure."
argument-hint: "Topic, notes, target audience, category, and any screenshots/code snippets"
---

# Blog Post Authoring

Use this skill to create or revise posts in `src/content/blog` so they match this site's Astro content schema, article structure, tagging style, and practical technical voice.

## Workflow

1. Gather the topic, audience, source notes, screenshots, code snippets, and whether this is a new article or an update to an existing post.
2. Review nearby or related posts in `src/content/blog` before drafting. Prefer recent posts for tone and structure, and older posts for migrated troubleshooting-note compatibility.
3. Choose the content shape:
   - Troubleshooting fix: symptom, observed behavior, trigger/root cause, confirmation steps, fix, checklist, wrap-up.
   - How-to guide: introduction/context, prerequisites, numbered setup sections, validation, references.
   - Pattern or best-practice article: problem, pattern, why it works, implementation steps, tradeoffs, conclusion.
   - Product/tool announcement: what it is, why it matters, concrete usage scenarios, links, conclusion.
4. Create the post file in `src/content/blog` using a lowercase kebab-case slug that matches the final title closely.
5. Use the frontmatter schema and style guidance in [blog-style-guide.md](./references/blog-style-guide.md).
6. Start from [blog-post-template.md](./assets/blog-post-template.md) when creating a fresh article.
7. If hero art is requested or already exists, place the public path in `heroImage` and write specific `heroImageAlt` text. If no hero exists, omit both fields unless the user asks to create one.
8. Use Markdown headings, lists, callouts, screenshots, tables, and fenced code blocks in the same practical style as existing posts.
9. Validate with `npm run build` after creating or editing content. Fix Astro schema, Markdown, or content errors before finishing.

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
- External references are included when the article depends on docs, tools, or upstream behavior.
- `npm run build` completes successfully.