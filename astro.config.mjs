// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import mdx from "@astrojs/mdx";
import rehypeExternalLinks from "rehype-external-links";

// https://astro.build/config
export default defineConfig({
  site: "https://www.richardawilson.com",
  integrations: [mdx(), sitemap()],
  markdown: {
    shikiConfig: {
      theme: "github-dark-dimmed",
      wrap: true,
    },
    rehypePlugins: [
      [
        rehypeExternalLinks,
        {
          // Any href that isn't same-origin (relative or matching the site)
          // opens in a new tab. Adds rel=noopener,noreferrer for security.
          target: "_blank",
          rel: ["noopener", "noreferrer"],
          // Treat protocol-less / root-relative URLs as internal
          // (everything starting with `http(s)://` not matching our host is external)
          protocols: ["http", "https"],
        },
      ],
    ],
  },
  build: {
    format: "directory",
  },
  vite: {
    build: {
      rollupOptions: {
        // Pagefind assets are emitted into dist/pagefind/ by `pagefind --site dist`
        // *after* astro build, so Vite must not try to resolve them at build time.
        external: [/^\/pagefind\//],
      },
    },
  },
});
