---
name: blog-hero-image-authoring
description: "Create, prompt, review, or wire blog header and hero images for rwilson504.github.io. Use when: blog hero image, header image, article banner, OpenGraph image, heroImage frontmatter, heroImageAlt text, /public/heroes assets, image-generation prompt, or matching existing blog header visual style."
argument-hint: "Blog title, slug, article summary, category, key products, and preferred visual metaphor"
---

# Blog Hero Image Authoring

Use this skill when creating or reviewing blog header images for posts in `src/content/blog`.

## Workflow

1. Read the target post or draft title, description, category, and tags.
2. Review related hero images in `public/heroes` and nearby posts in `src/content/blog`.
3. Choose the visual mode from [hero-image-style-guide.md](./references/hero-image-style-guide.md): clean technical diagram, cinematic technical metaphor, product/workspace scene, or legacy screenshot/GIF only when appropriate.
4. Generate or request a wide banner image, usually PNG, with a target aspect ratio near `16:9` or `3:2`.
5. Use [hero-image-prompt-template.md](./assets/hero-image-prompt-template.md) to produce a consistent image-generation prompt.
6. Save the asset as `public/heroes/<post-slug>.png` unless the source is intentionally JPG or GIF.
7. Add frontmatter to the post:

```yaml
heroImage: "/heroes/<post-slug>.png"
```

The site renders hero image alt text from the article title, so a separate `heroImageAlt` field is usually unnecessary.

8. Validate the post with `npm run build` when the article frontmatter changes.

## Default Hero Pattern

For new posts, prefer a **wide, clean, technical banner** with one clear concept:

- A concrete central visual metaphor for the post's technical problem or outcome.
- Two to four recognizable product or system elements, simplified as icons, panels, devices, cards, locks, arrows, data tables, pipelines, clouds, or terminals.
- A restrained background that supports the concept: dark technical grid, blue Microsoft-style gradient, glowing data path, office/workbench scene, or abstract cloud/security environment.
- Clear space around important subjects so the image still works when cropped for cards or OpenGraph previews.

## Text In Images

Existing headers include text, but new images should use text sparingly because generated text often has artifacts.

Prefer:

- No embedded title text when the article page already renders the title.
- Short, large labels only when they clarify a diagram, such as `Azure DevOps`, `Managed Identity`, `GCC High Storage`, `OAuth`, or `Dataverse`.
- One or two words per label, never paragraph text.

Avoid:

- Tiny UI text, fake error text, full article titles, dense tables, or code snippets in the hero.
- Real tenant names, tokens, subscription IDs, emails, secrets, hostnames, or customer data.

## Alt Text Pattern

For hero images, the rendered alt text is the article title. This matches the current blog convention because hero images are usually title/header art and the article title is also the clearest accessible label for cards and article headers.

Do not spend time writing separate `heroImageAlt` frontmatter for routine blog hero images. Use the article title as the source of truth.

If a future hero image carries meaning that is not represented by the title, reconsider the design first. Prefer moving that explanatory content into body text or a body image with meaningful alt text.

For body images and screenshots, write alt text as a description of the useful information in the image, not a duplicate of the title.

Good pattern:

```text
Illustrated technical banner showing <main subject> with <key product/system symbols> connected by <arrows/data path/security boundary> to represent <article concept>.
```

For strongly illustrative scenes:

```text
Wide digital illustration of <scene>, featuring <main subject> and <supporting objects>, representing <technical workflow or outcome>.
```

## Done Criteria

- The image is stored under `public/heroes` with a slug-matching filename.
- The post frontmatter points to `/heroes/<slug>.png`; rendered hero alt text comes from the article title.
- The hero has one readable concept at card size.
- It avoids sensitive data and unreadable generated UI text.
- `npm run build` passes after frontmatter updates.