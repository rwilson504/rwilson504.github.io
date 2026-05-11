// Rasterize public/og-default.svg into a PNG for OpenGraph / Twitter cards.
import sharp from "sharp";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

const root = resolve(process.cwd(), "public");
const svg = await readFile(resolve(root, "og-default.svg"));

// OG spec: 1200x630, < 5MB. PNG keeps the sharp gradient + crisp text edges.
await sharp(svg, { density: 144 })
  .resize(1200, 630)
  .png({ compressionLevel: 9 })
  .toFile(resolve(root, "og-default.png"));

console.log("wrote og-default.png");
