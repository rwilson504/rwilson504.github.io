# Hero Image Style Guide

This guide captures the repeatable visual pattern for blog header images in `public/heroes`.

## Current Asset Pattern

The hero set contains about 120 files. Most are PNG, with some JPG and GIF assets from older posts or animated component demos.

Common observations:

- Newer technical images are wide banners, commonly close to `16:9`, `1.75:1`, or `3:2`.
- Many Power Platform and Azure articles use diagram-like compositions with icons, arrows, clouds, locks, databases, identity cards, UI cards, or pipelines.
- Some newer AI/homelab articles use cinematic illustrations with a central subject and product/service symbols around it.
- Older migrated posts may use screenshots or GIFs. Do not use those as the preferred pattern for new generated hero art.

## Recommended Format

For new generated images:

- File type: PNG.
- Location: `public/heroes/<post-slug>.png`.
- Frontmatter path: `/heroes/<post-slug>.png`.
- Aspect ratio: use `16:9` by default. `3:2` is acceptable for richer illustrative scenes.
- Minimum useful size: 1200 px wide. Prefer 1600x900, 1600x1067, or larger source art that can be compressed later.
- Composition: leave safe margins at the top and sides because the image appears in article headers, cards, RSS/OpenGraph previews, and social crops.

## Visual Modes

### Clean Technical Diagram

Best for Azure, Power Platform, security, integration, and setup posts.

Characteristics:

- Flat or lightly dimensional icons.
- Product concepts represented by simplified symbols rather than exact logos.
- Arrows, dotted lines, data paths, security boundaries, locks, identity cards, containers, tables, terminals, or cloud shapes.
- Blue, teal, white, and occasional accent colors.
- Optional short labels if they are large and legible.

Use this for posts like secure pipelines, Logic Apps OAuth, Dataverse MCP, managed identity, API pagination, and connector setup.

### Cinematic Technical Metaphor

Best for troubleshooting, surprising behavior, performance, or data-shaping posts.

Characteristics:

- A single metaphor that makes the problem memorable: a frozen data path, split pipeline, locked gate, diverging road, shield, warning/fix contrast, or stable flow.
- Dark technical background, glow accents, depth, and motion lines.
- Minimal text or no text.
- The metaphor should be technically meaningful, not decorative.

Use this for posts like PAC CLI errors, Power Query drift, debugging, and operational gotchas.

### Product Or Workspace Scene

Best for connectors, smart home, maker projects, hardware, or demos where the article connects technology to a real environment.

Characteristics:

- A workbench, desktop, dashboard, home office, lab bench, or device scene.
- The product appears through symbolic UI panels, devices, lights, sensors, dashboards, or automation flow nodes.
- Warmer lighting is acceptable when the subject is home, maker, or hardware oriented.
- Keep the scene clean enough to read at small sizes.

Use this for posts like Govee automation, 3D printing, electronics, Synology/OpenClaw, and Raspberry Pi topics.

### Legacy Screenshot Or GIF

Use only when the hero needs to show the actual UI/component behavior or when preserving a migrated article.

Guidelines:

- Prefer body screenshots for step details; the hero should usually be conceptual.
- GIFs are acceptable for controls or visual components when motion is the point.
- Avoid creating new screenshot-only heroes for broad technical articles.

## Composition Rules

- One primary idea per image.
- Use two to four supporting objects at most.
- Keep the focal point centered or slightly off-center, with enough quiet space for responsive crops.
- Avoid cluttered dashboards, dense screenshots, and tiny controls.
- If using title text, place it in a large, high-contrast block and keep it short.
- Avoid exact brand logo misuse when a symbolic icon communicates the same concept.
- Do not include secrets, tenant names, real IDs, real emails, production URLs, or customer-specific data.

## Color And Mood

The strongest existing patterns use:

- Microsoft-adjacent blues and teals for Power Platform, Azure, identity, and security topics.
- Dark navy technical grids for troubleshooting, CLI, data, and infrastructure topics.
- White/blue flat diagrams for step-by-step architecture guidance.
- Warm, realistic lighting for home automation, maker, or personal technology posts.

Avoid one-note generic purple gradients and generic stock-photo business scenes.

## Text Guidance

Generated text often breaks. For new images, prefer no title text. If text is needed:

- Keep labels to one to three words.
- Use large sans-serif lettering.
- Put labels on simple blocks, tabs, or callout chips.
- Ask for crisp, correctly spelled labels.
- Verify the output manually before using it.

Good labels:

- `Dataverse`
- `Managed Identity`
- `OAuth`
- `GCC High`
- `Power Query`
- `Table.Buffer`

Bad labels:

- Full error text.
- Full article title.
- Code snippets.
- Long menu paths.

## Frontmatter And Alt Text

Use:

```yaml
heroImage: "/heroes/<slug>.png"
heroImageAlt: "Illustrated technical banner showing <subject> with <key symbols> representing <concept>."
```

Alt text should describe the visual. It can include the title only when the image itself is essentially title art.

Examples:

- `Illustrated technical banner showing an Azure DevOps pipeline connected through managed identity to secured GCC High storage.`
- `Wide digital illustration of a stable glowing data path representing Power Query rows frozen before a merge with Table.Buffer.`
- `Diagram-style banner showing a Logic App workflow protected by OAuth, managed identity, and a locked endpoint.`

## Prompt Checklist

Before generating, identify:

- Article title and slug.
- Core technical subject.
- Reader problem or outcome.
- Products/services involved.
- Visual metaphor.
- Whether text labels are allowed.
- Any sensitive details to exclude.
- Target aspect ratio and file name.

After generating, check:

- The idea is clear at small size.
- Labels, if any, are spelled correctly.
- No fake credentials, IDs, or customer data appear.
- The image does not look like a generic stock illustration.
- The filename and frontmatter path match the post slug.