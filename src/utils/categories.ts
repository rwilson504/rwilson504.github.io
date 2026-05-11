// Title-case category slugs with special handling for known acronyms.
// e.g. "ai" -> "AI", "3d-printing" -> "3D Printing", "power-apps" -> "Power Apps"
const ACRONYMS = new Set([
  "ai",
  "ml",
  "ui",
  "ux",
  "api",
  "url",
  "sql",
  "html",
  "css",
  "js",
  "io",
  "3d",
]);

export function categoryLabel(slug: string): string {
  return slug
    .split("-")
    .map((w) => {
      const lower = w.toLowerCase();
      if (ACRONYMS.has(lower)) return lower.toUpperCase();
      return (w[0]?.toUpperCase() ?? "") + w.slice(1);
    })
    .join(" ");
}
