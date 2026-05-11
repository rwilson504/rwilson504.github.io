// Tiny one-off script: rasterize public/favicon.svg into the PNG/ICO assets we need.
import sharp from "sharp";
import { writeFile, readFile } from "node:fs/promises";
import { resolve } from "node:path";

const root = resolve(process.cwd(), "public");
const svg = await readFile(resolve(root, "favicon.svg"));

const PNG_SIZES = [16, 32, 48, 180, 192, 512];

for (const size of PNG_SIZES) {
  const name =
    size === 180 ? "apple-touch-icon.png" :
    size === 192 ? "icon-192.png" :
    size === 512 ? "icon-512.png" :
    `favicon-${size}.png`;
  const out = resolve(root, name);
  await sharp(svg, { density: 384 })
    .resize(size, size, { fit: "contain", background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png({ compressionLevel: 9 })
    .toFile(out);
  console.log(`wrote ${name}`);
}

// Build a multi-size .ico (16/32/48) by concatenating PNG buffers in ICO format.
async function buildIco(sizes, outPath) {
  const images = await Promise.all(
    sizes.map(async (s) =>
      sharp(svg, { density: 384 })
        .resize(s, s)
        .png({ compressionLevel: 9 })
        .toBuffer()
    )
  );

  const HEADER = 6;
  const DIR = 16;
  const n = images.length;
  let offset = HEADER + DIR * n;

  const dirEntries = images.map((buf, i) => {
    const s = sizes[i];
    const entry = Buffer.alloc(DIR);
    entry.writeUInt8(s === 256 ? 0 : s, 0); // width
    entry.writeUInt8(s === 256 ? 0 : s, 1); // height
    entry.writeUInt8(0, 2); // palette
    entry.writeUInt8(0, 3); // reserved
    entry.writeUInt16LE(1, 4); // color planes
    entry.writeUInt16LE(32, 6); // bits per pixel
    entry.writeUInt32LE(buf.length, 8); // size
    entry.writeUInt32LE(offset, 12); // offset
    offset += buf.length;
    return entry;
  });

  const header = Buffer.alloc(HEADER);
  header.writeUInt16LE(0, 0); // reserved
  header.writeUInt16LE(1, 2); // type=ICO
  header.writeUInt16LE(n, 4);

  const ico = Buffer.concat([header, ...dirEntries, ...images]);
  await writeFile(outPath, ico);
  console.log(`wrote ${outPath} (${ico.length} bytes)`);
}

await buildIco([16, 32, 48], resolve(root, "favicon.ico"));
