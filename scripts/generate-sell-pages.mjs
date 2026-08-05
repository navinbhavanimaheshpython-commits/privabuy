// scripts/generate-sell-pages.mjs
//
// Run locally whenever you add/edit entries in sellPagesData.mjs:
//   node scripts/generate-sell-pages.mjs
//
// Writes public/sell-my-{slug}.html for every entry — plain, dependency-free
// static HTML matching the homepage's visual language (Barlow + Instrument
// Serif, cream/purple palette). No React, no build step needed for these
// pages themselves; vercel.json already copies public/sell-my-*.html into
// dist/ automatically on every deploy.
//
// Then: commit the generated .html files + review, git push.

import { writeFileSync, existsSync, mkdirSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import { sellPages } from "./sellPagesData.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const PUBLIC_DIR = join(__dirname, "..", "public");
const SITE_URL = "https://privabuy.com";
const META_PIXEL_ID = "1958235388393786";
const GOOGLE_TAG_ID = "AW-18160958792";

function pageHtml(page, allPages) {
  const siblings = page.siblingSlugs
    .map((s) => allPages.find((p) => p.slug === s))
    .filter(Boolean);

  const title = `Sell Your ${page.yearRange} ${page.make} ${page.model} — Get Dealer Offers in Minutes | PrivaBuy`;
  const description = `Get competing offers from local franchised dealers for your ${page.make} ${page.model}. No haggling, no listing hassle — submit your VIN and see what dealers will pay.`;
  const canonical = `${SITE_URL}/${page.slug}`;

  const valueRows = page.valueRanges
    .map(
      (v) => `
        <div class="value-row">
          <strong>${v.band}</strong>
          <span>${v.note}</span>
        </div>`
    )
    .join("");

  const faqItems = page.faqs
    .map(
      (f) => `
      <details class="faq-item">
        <summary>${f.q}</summary>
        <p>${f.a}</p>
      </details>`
    )
    .join("");

  const siblingLinks = siblings
    .map((s) => `<li><a href="/${s.slug}">Sell my ${s.make} ${s.model}</a></li>`)
    .join("\n            ");

  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${title}</title>
<meta name="description" content="${description}" />
<link rel="canonical" href="${canonical}" />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@300;400;500;600&family=Instrument+Serif:ital@0;1&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; }
  :root {
    --bg: #f5f3ef; --fg: #1a1814; --muted: rgba(26,24,20,0.72);
    --border: rgba(26,24,20,0.14); --accent: #7c5cbf;
  }
  body { margin:0; font-family:'Barlow',sans-serif; font-weight:300; background:var(--bg); color:var(--fg); }
  .serif-italic { font-family:'Instrument Serif',serif; font-style:italic; }
  a { color: var(--accent); }
  .nav { display:flex; align-items:center; justify-content:space-between; padding:1.25rem clamp(1.5rem,6vw,5rem); }
  .logo { font-family:'Instrument Serif',serif; font-style:italic; font-size:1.25rem; text-decoration:none; color:var(--fg); }
  .logo span { color: var(--accent); }
  main { max-width: 46rem; margin: 0 auto; padding: 2rem clamp(1.5rem,6vw,5rem) 6rem; }
  .eyebrow { display:inline-block; font-size:0.72rem; font-weight:500; text-transform:uppercase; letter-spacing:0.06em;
    border:1px solid var(--border); border-radius:9999px; padding:0.25rem 0.875rem; margin-bottom:1.1rem; }
  h1 { font-family:'Instrument Serif',serif; font-style:italic; font-weight:400; font-size:clamp(2rem,5vw,3rem);
    line-height:1.05; letter-spacing:-0.03em; margin:0 0 1.25rem; }
  h2 { font-family:'Instrument Serif',serif; font-style:italic; font-weight:400; font-size:clamp(1.4rem,3vw,1.9rem);
    letter-spacing:-0.02em; margin: 2.5rem 0 1rem; }
  .intro { font-size:1rem; line-height:1.7; color:var(--muted); margin-bottom:1.75rem; }
  .cta { display:inline-flex; align-items:center; gap:0.4rem; background:#1a1814; color:#f5f3ef;
    border:none; border-radius:9999px; padding:0.9rem 2rem; font-size:1rem; font-weight:500;
    text-decoration:none; font-family:'Barlow',sans-serif; cursor:pointer; }
  .dealer-note { font-size:0.9rem; color:var(--muted); margin-bottom:1rem; }
  .value-row { display:flex; justify-content:space-between; gap:1rem; padding:0.9rem 1rem;
    border:1px solid var(--border); border-radius:0.875rem; margin-bottom:0.6rem; font-size:0.88rem; }
  .value-row strong { flex-shrink:0; }
  .value-row span { color:var(--muted); text-align:right; }
  .disclaimer { font-size:0.75rem; color:var(--muted); margin-top:0.75rem; }
  ol { padding-left: 1.25rem; line-height:1.9; color:var(--muted); }
  .faq-item { border:1px solid var(--border); border-radius:0.875rem; padding:1rem 1.25rem; margin-bottom:0.6rem; }
  .faq-item summary { cursor:pointer; font-weight:400; color:var(--fg); }
  .faq-item p { color:var(--muted); font-size:0.88rem; line-height:1.65; margin:0.75rem 0 0; }
  .sibling-links ul { list-style:none; padding:0; display:flex; flex-direction:column; gap:0.5rem; }
  .sibling-links a { font-size:0.9rem; text-decoration:none; }
  .sticky-cta { position:fixed; bottom:1.25rem; left:50%; transform:translateX(-50%); z-index:50; }
  footer { text-align:center; padding:2rem; font-size:0.72rem; color:var(--muted); }
</style>
</head>
<body>

<nav class="nav">
  <a class="logo" href="/">Priva<span>Buy</span></a>
  <a class="cta" href="/portal?role=seller" onclick="trackLead('seller_sellpage_nav')" style="padding:0.5rem 1.1rem; font-size:0.85rem;">See Dealer Offers ↗</a>
</nav>

<main>
  <p class="eyebrow">${page.make} ${page.model} · ${page.yearRange}</p>
  <h1>Sell Your ${page.make} ${page.model} to a Local Dealer — No Haggling, No Listing Hassle</h1>
  <p class="intro">${page.intro}</p>
  <a class="cta" href="/portal?role=seller" onclick="trackLead('seller_sellpage_hero')">See What Dealers Will Pay ↗</a>

  <h2>What dealers are paying for a ${page.model} right now</h2>
  <p class="dealer-note">${page.dealerWantsNote}</p>
  ${valueRows}
  <p class="disclaimer">Ranges are directional and based on current market data — your actual offer depends on condition, history, and local dealer demand.</p>

  <h2>How it works</h2>
  <ol>
    <li>Submit your VIN and a few photos — takes about two minutes.</li>
    <li>Local franchised dealers review your ${page.model} and bid competitively.</li>
    <li>Accept the best offer and get paid — no listing, no showings.</li>
  </ol>

  <h2>${page.make} ${page.model} selling FAQ</h2>
  ${faqItems}

  <div class="sibling-links">
    <h2>Selling something else?</h2>
    <ul>
            ${siblingLinks}
      <li><a href="/#for-sellers">See how PrivaBuy works →</a></li>
    </ul>
  </div>
</main>

<a class="cta sticky-cta" href="/portal?role=seller" onclick="trackLead('seller_sellpage_sticky')">See What Dealers Will Pay ↗</a>

<footer>© 2026 PrivaBuy LLC. All rights reserved.</footer>

<script>
  // Same Meta Pixel + Google Tag as the homepage, so conversions from this
  // page roll into the same reporting.
  !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
  n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
  n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
  t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
  document,'script','https://connect.facebook.net/en_US/fbevents.js');
  fbq('init', '${META_PIXEL_ID}');
  fbq('track', 'PageView');

  (function(){
    var s1 = document.createElement('script');
    s1.async = true;
    s1.src = 'https://www.googletagmanager.com/gtag/js?id=${GOOGLE_TAG_ID}';
    document.head.appendChild(s1);
    window.dataLayer = window.dataLayer || [];
    window.gtag = function(){ window.dataLayer.push(arguments); };
    gtag('js', new Date());
    gtag('config', '${GOOGLE_TAG_ID}');
  })();

  function trackLead(type) {
    if (typeof fbq !== 'undefined') {
      fbq('track', 'Lead', { content_name: type, value: 350.00, currency: 'USD' });
    }
    if (typeof gtag !== 'undefined') {
      gtag('event', 'conversion', { send_to: '${GOOGLE_TAG_ID}/Lead', value: 1.0, currency: 'USD' });
      gtag('event', 'sell_page_cta_click', { model: '${page.model}' });
    }
  }
</script>

</body>
</html>
`;
}

if (!existsSync(PUBLIC_DIR)) mkdirSync(PUBLIC_DIR, { recursive: true });

sellPages.forEach((page) => {
  const outPath = join(PUBLIC_DIR, `${page.slug}.html`);
  writeFileSync(outPath, pageHtml(page, sellPages));
  console.log(`✓ wrote public/${page.slug}.html`);
});

console.log(`\nDone — ${sellPages.length} pages generated. Review, then:`);
console.log("  git add public/sell-my-*.html vercel.json scripts/");
console.log("  git commit -m 'Add sell-my-car SEO landing pages'");
console.log("  git push");
