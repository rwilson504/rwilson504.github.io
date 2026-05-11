import { getCollection } from "astro:content";

let cached: Set<string> | null = null;

/**
 * Returns the set of tags that have their own listing page.
 * We only emit a tag page when a tag is used by 2+ posts; this helper lets
 * components decide whether to render a tag as a clickable link or a plain
 * badge.
 */
export async function getLinkableTags(): Promise<Set<string>> {
  if (cached) return cached;
  const posts = await getCollection("blog", ({ data }) => !data.draft);
  const counts = new Map<string, number>();
  for (const p of posts) {
    for (const t of p.data.tags) counts.set(t, (counts.get(t) ?? 0) + 1);
  }
  cached = new Set([...counts.entries()].filter(([, n]) => n >= 2).map(([t]) => t));
  return cached;
}
