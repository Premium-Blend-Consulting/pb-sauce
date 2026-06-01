#!/bin/bash
# Export Starbucks deck to pixel-perfect PDF
# Usage: just double-click this file, or run: bash export-deck-pdf.sh

DECK="$(dirname "$0")/Content Excellence Audit _ Starbucks Asia-Pacific _ Premium Blend v2.html"
OUT="$(dirname "$0")/Starbucks-AP-Content-Audit-PremiumBlend.pdf"
WORKDIR="/tmp/deck-export"

echo "📄 Exporting deck to PDF..."

# Ensure playwright is installed
if [ ! -d "$WORKDIR/node_modules/playwright" ]; then
  echo "   Installing Playwright (one-time)..."
  mkdir -p "$WORKDIR"
  cd "$WORKDIR" && npm init -y --silent 2>/dev/null && npm install playwright --silent 2>/dev/null
  npx playwright install chromium --silent 2>/dev/null
fi

# Write the capture script
cat > "$WORKDIR/capture.js" << 'SCRIPT'
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

(async () => {
  const deckPath = process.argv[2];
  const outDir = path.join(require('os').tmpdir(), 'slide-pngs');
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const page = await (await browser.newContext({
    viewport: { width: 1280, height: 720 },
    deviceScaleFactor: 2,
  })).newPage();

  await page.goto('file://' + deckPath, { waitUntil: 'networkidle' });
  await page.evaluate(() => document.fonts.ready);
  await page.evaluate(() => {
    document.querySelectorAll('.deck-tools-bar').forEach(el => el.style.display = 'none');
  });
  await page.waitForTimeout(2000);

  const slides = await page.$$('.slide');
  const paths = [];
  for (let i = 0; i < slides.length; i++) {
    const p = path.join(outDir, `slide-${String(i+1).padStart(2,'0')}.png`);
    await slides[i].screenshot({ path: p });
    paths.push(p);
    process.stdout.write(`   Captured slide ${i+1}/${slides.length}\r`);
  }
  await browser.close();

  // Output paths as JSON for the python step
  console.log('\n' + JSON.stringify(paths));
})();
SCRIPT

# Run capture
PATHS=$(cd "$WORKDIR" && node capture.js "$DECK" 2>/dev/null | tail -1)

# Assemble PDF
python3 -c "
import json, sys, os
from PIL import Image

paths = json.loads('$PATHS')
images = [Image.open(p).convert('RGB') for p in paths]
out = '$OUT'
images[0].save(out, save_all=True, append_images=images[1:], resolution=144.0)
print(f'✅ PDF saved: {len(images)} slides → {out}')
print(f'   File size: {os.path.getsize(out) / 1024 / 1024:.1f} MB')

# Clean up PNGs
for p in paths:
    os.remove(p)
"

# Open the PDF
open "$OUT" 2>/dev/null
