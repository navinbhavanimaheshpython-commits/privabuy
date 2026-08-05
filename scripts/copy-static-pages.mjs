// scripts/copy-static-pages.mjs
// Copies app/portal/dealer-signup/reset-password + all sell-my-*.html
// files from public/ into dist/ after the vite build.
// Called from vercel.json's buildCommand (kept short to stay under
// Vercel's 256-character limit).

import fs from "fs";

["app", "portal", "dealer-signup", "reset-password"].forEach((f) => {
  try {
    fs.copyFileSync(`public/${f}.html`, `dist/${f}.html`);
  } catch (e) {
    // fine if one of these doesn't exist
  }
});

fs.readdirSync("public")
  .filter((f) => f.startsWith("sell-my-") && f.endsWith(".html"))
  .forEach((f) => fs.copyFileSync(`public/${f}`, `dist/${f}`));

console.log("Static pages copied to dist/");
