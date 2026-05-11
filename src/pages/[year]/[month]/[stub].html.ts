import type { APIRoute, GetStaticPaths } from "astro";
import { getCollection } from "astro:content";

/**
 * Emits one HTML stub per legacy Blogger URL (e.g. /2020/03/azure-maps-pcf-control.html)
 * that redirects to the new post URL via <meta http-equiv="refresh"> plus a
 * canonical link. Static-host friendly — works on GitHub Pages without
 * any server-side rewrite rules.
 *
 * Source field: `originalBloggerUrl` in each post's frontmatter, shaped like
 * `/2020/03/azure-maps-pcf-control.html`.
 */

const SITE = "https://www.richardawilson.com";

function parseLegacy(url: string): { year: string; month: string; stub: string } | null {
  // Accept `/YYYY/MM/<stub>.html` (with or without leading slash).
  const m = url.match(/^\/?(\d{4})\/(\d{2})\/([^/]+)\.html$/i);
  if (!m) return null;
  return { year: m[1], month: m[2], stub: m[3] };
}

export const getStaticPaths: GetStaticPaths = async () => {
  const posts = await getCollection("blog", ({ data }) => !data.draft);
  const paths: Array<{ params: { year: string; month: string; stub: string }; props: { slug: string; title: string } }> = [];
  for (const p of posts) {
    const legacy = p.data.originalBloggerUrl;
    if (!legacy) continue;
    const parsed = parseLegacy(legacy);
    if (!parsed) {
      // Log so we notice if any url shape drifts (e.g. older Blogger paths)
      // eslint-disable-next-line no-console
      console.warn(`[redirects] skipping ${p.id}: cannot parse "${legacy}"`);
      continue;
    }
    paths.push({
      params: parsed,
      props: { slug: p.id, title: p.data.title },
    });
  }
  return paths;
};

export const GET: APIRoute = ({ props }) => {
  const { slug, title } = props as { slug: string; title: string };
  const target = `/blog/${slug}/`;
  const html = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Redirecting&hellip; ${escapeHtml(title)}</title>
<link rel="canonical" href="${SITE}${target}">
<meta name="robots" content="noindex, follow">
<meta http-equiv="refresh" content="0; url=${target}">
<script>window.location.replace(${JSON.stringify(target)});</script>
<style>body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;max-width:40em;margin:4em auto;padding:0 1em;color:#1a1a1a}</style>
</head>
<body>
<h1>This page has moved.</h1>
<p>Redirecting to <a href="${target}">${escapeHtml(title)}</a>&hellip;</p>
</body>
</html>`;
  return new Response(html, {
    status: 200,
    headers: { "Content-Type": "text/html; charset=utf-8" },
  });
};

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}
