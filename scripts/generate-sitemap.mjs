import fs from 'fs';
import { sellPages } from './sellPagesData.mjs';

const BASE_URL = 'https://privabuy.com';
const staticPages = ['', 'app', 'portal', 'dealer-signup'];

const urls = [
  ...staticPages.map(p => `${BASE_URL}/${p}`),
  ...sellPages.map(p => `${BASE_URL}/${p.slug}`),
];

const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(u => `  <url><loc>${u}</loc></url>`).join('\n')}
</urlset>`;

fs.writeFileSync('public/sitemap.xml', xml);
console.log(`sitemap.xml written with ${urls.length} URLs`);import fs from 'fs';
import { sellPages } from './sellPagesData.mjs';

const BASE_URL = 'https://privabuy.com';
const staticPages = ['', 'app', 'portal', 'dealer-signup'];

const urls = [
  ...staticPages.map(p => `${BASE_URL}/${p}`),
  ...sellPages.map(p => `${BASE_URL}/${p.slug}`),
];

const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(u => `  <url><loc>${u}</loc></url>`).join('\n')}
</urlset>`;

fs.writeFileSync('public/sitemap.xml', xml);
console.log(`sitemap.xml written with ${urls.length} URLs`);