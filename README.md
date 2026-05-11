# richardawilson.com

The source for [richardawilson.com](https://www.richardawilson.com) — a custom
Astro static site, hosted on GitHub Pages, replacing a fifteen-year-old
Blogger site.

## Stack

- [Astro](https://astro.build) v5
- TypeScript (strict)
- Markdown + MDX content via `astro:content`
- `@astrojs/sitemap`, `@astrojs/rss`, `astro-seo`
- [Pagefind](https://pagefind.app) for static-site search (wired in later)
- GitHub Pages deploy via GitHub Actions
- Custom theme — no framework, ~150 lines of CSS

## Run locally

```bash
npm install
npm run dev      # http://localhost:4321
npm run build    # builds to ./dist and generates pagefind index
npm run preview  # preview the production build
```

## Content

Posts live in `src/content/blog/*.md` (or `.mdx`). Frontmatter schema is in
`src/content.config.ts`:

| Field | Type | Required | Notes |
| ----- | ---- | -------- | ----- |
| `title` | string | yes | |
| `description` | string | yes | Used for OG + meta description |
| `pubDate` | date | yes | ISO-8601, e.g. `2026-05-11` |
| `updatedDate` | date | no | |
| `category` | enum | yes | one of `power-apps`, `ai`, `electronics`, `misc` |
| `tags` | string[] | no | free-form |
| `draft` | boolean | no | default `false` |
| `heroImage` | image | no | |
| `originalBloggerUrl` | string | no | legacy URL — used to emit a redirect stub |

Slug = filename (sans extension). So `src/content/blog/foo-bar.md` →
`/blog/foo-bar/`.

## Adding a post

1. Create `src/content/blog/<slug>.md`.
2. Fill in frontmatter (all required fields).
3. Run `npm run build` locally to verify.
4. Commit + push to `main`. GitHub Actions deploys to Pages.

## Deploy

Any push to `main` triggers `.github/workflows/deploy.yml`, which builds and
publishes to GitHub Pages. The site is served at `www.richardawilson.com`
via the `public/CNAME` file.

## Project layout

```
.
├── .github/workflows/deploy.yml
├── astro.config.mjs
├── public/
│   └── CNAME
├── src/
│   ├── components/
│   ├── content/
│   │   └── blog/
│   ├── content.config.ts
│   ├── layouts/
│   ├── pages/
│   └── styles/
└── package.json
```
