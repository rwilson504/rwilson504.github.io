// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import mdx from "@astrojs/mdx";
import rehypeExternalLinks from "rehype-external-links";
import astroD2 from "astro-d2";

// https://astro.build/config
export default defineConfig({
  site: "https://www.richardawilson.com",
  integrations: [
    mdx(),
    sitemap(),
    astroD2({
      // Render diagrams at build time so produced SVGs ship as static assets.
      // D2 themes are numeric strings, see https://d2lang.com/tour/themes
      //   '0'   = Neutral default (light)
      //   '200' = Dark Mauve (dark)
      theme: {
        default: "0",
        dark: "200",
      },
      layout: "elk",
      sketch: false,
      pad: 20,
      experimental: {
        // Use the bundled WASM build of D2 instead of requiring a system binary.
        // Lets the GitHub Pages build succeed without installing D2 via apt or curl.
        useD2js: true,
      },
    }),
  ],
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
