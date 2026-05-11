import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const CATEGORIES = ["power-apps", "ai", "electronics", "3d-printing", "windows", "dev-tools", "personal", "misc"] as const;
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
      // Hero image: either an absolute external URL (e.g. blogger.googleusercontent.com)
      // or a site-absolute path under /heroes/ that we copied into public/heroes.
      heroImage: z
        .string()
        .refine(
          (v) => /^https?:\/\//.test(v) || v.startsWith("/"),
          { message: "heroImage must be an http(s) URL or a site-absolute path" },
        )
        .optional(),
      heroImageAlt: z.string().optional(),
      // The original Blogger URL path (e.g. "/2026/03/some-post.html"), used
      // by the migration tooling to emit a redirect stub at the legacy URL.
      originalBloggerUrl: z.string().optional(),
    }),
});

export const collections = { blog };
export const categories = CATEGORIES;
