import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const CATEGORIES = ["power-apps", "ai", "electronics", "3d-printing", "misc"] as const;
export type Category = (typeof CATEGORIES)[number];

const blog = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/blog" }),
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      description: z.string(),
      pubDate: z.coerce.date(),
      updatedDate: z.coerce.date().optional(),
      category: z.enum(CATEGORIES),
      tags: z.array(z.string()).default([]),
      draft: z.boolean().default(false),
      // Hero image: external URL (most posts use Blogger/GitHub-hosted
      // images). We store it as a plain string instead of an Astro `image()`
      // because none of the migrated images are colocated yet.
      heroImage: z.string().url().optional(),
      heroImageAlt: z.string().optional(),
      // The original Blogger URL path (e.g. "/2026/03/some-post.html"), used
      // by the migration tooling to emit a redirect stub at the legacy URL.
      originalBloggerUrl: z.string().optional(),
    }),
});

export const collections = { blog };
export const categories = CATEGORIES;
