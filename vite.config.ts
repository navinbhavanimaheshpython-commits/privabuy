import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import sitemap from 'vite-plugin-sitemap'

export default defineConfig({
  plugins: [
    react(),
    sitemap({
      hostname: 'https://privabuy.com',
      routes: ['/'],
    }),
  ],
  esbuild: {
    logOverride: { 'this-is-undefined-in-esm': 'silent' }
  }
})