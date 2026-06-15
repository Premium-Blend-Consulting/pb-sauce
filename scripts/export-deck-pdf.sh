#!/bin/bash
# ──────────────────────────────────────────────────────────
# export-deck-pdf.sh
# Pixel-perfect PDF export for any PB Sauce HTML deck.
#
# Usage:
#   bash export-deck-pdf.sh "path/to/deck.html"
#   bash export-deck-pdf.sh "path/to/deck.html" "output.pdf"
#
# If no output path is given, the PDF lands next to the HTML
# with the same name.
# ──────────────────────────────────────────────────────────

set -euo pipefail

# ── Args ──────────────────────────────────────────────────
if [ $# -lt 1 ]; then
  echo "Usage: bash export-deck-pdf.sh <deck.html> [output.pdf]"
  exit 1
fi

DECK="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
OUT="${2:-${DECK%.html}.pdf}"

if [ ! -f "$DECK" ]; then
  echo "❌ File not found: $DECK"
  exit 1
fi

echo "📄 Exporting: $(basename "$DECK")"

# ── Playwright setup (one-time) ──────────────────────────
WORKDIR="/tmp/deck-export"
if [ ! -d "$WORKDIR/node_modules/playwright" ]; then
  echo "   Installing Playwright (one-time)..."
  mkdir -p "$WORKDIR"
  (cd "$WORKDIR" && npm init -y --silent 2>/dev/null && npm install playwright --silent 2>/dev/null)
  (cd "$WORKDIR" && npx playwright install chromium --silent 2>/dev/null)
fi

# ── Capture script ────────────────────────────────────────
cat > "$WORKDIR/capture.js" << 'SCRIPT'
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

(async () => {
  const deckPath = process.argv[2];
  const outDir = path.join(require('os').tmpdir(), 'slide-pngs');
  if (fs.existsSync(outDir)) fs.rmSync(outDir, { recursive: true });
  fs.mkdirSync(outDir, { recursive: true });

  const browser = await chromium.launch();
  const page = await (await browser.newContext({
    viewport: { width: 1280, height: 720 },
    deviceScaleFactor: 2,
  })).newPage();

  await page.goto('file://' + deckPath, { waitUntil: 'networkidle' });
  await page.evaluate(() => document.fonts.ready);

  // Hide deck-tools nav bar and the floating "Save as PDF" button if present
  await page.evaluate(() => {
    document.querySelectorAll('.deck-tools-bar, .deck-nav, [data-deck-tools], #savePdf')
      .forEach(el => el.style.display = 'none');
  });

  await page.waitForTimeout(2000);

  // Try .slide first, fall back to .page
  let slides = await page.$$('.slide');
  if (slides.length === 0) slides = await page.$$('.page');
  if (slides.length === 0) {
    console.error('No .slide or .page elements found in the document.');
    process.exit(1);
  }

  const paths = [];
  for (let i = 0; i < slides.length; i++) {
    const p = path.join(outDir, `slide-${String(i + 1).padStart(2, '0')}.png`);
    await slides[i].screenshot({ path: p });
    paths.push(p);
    process.stderr.write(`   Captured slide ${i + 1}/${slides.length}\n`);
  }
  await browser.close();

  // Output JSON paths to stdout only
  console.log(JSON.stringify(paths));
})();
SCRIPT

# ── Run capture ───────────────────────────────────────────
echo "   Capturing slides..."
PATHS=$(cd "$WORKDIR" && node capture.js "$DECK" 2>&1 | tee /dev/stderr | tail -1)

# ── Assemble PDF with Pillow ──────────────────────────────
echo "   Assembling PDF..."
python3 << PYEOF
import json, sys, os
from PIL import Image

paths = json.loads('''$PATHS''')
images = [Image.open(p).convert('RGB') for p in paths]
out = '''$OUT'''
images[0].save(out, save_all=True, append_images=images[1:], resolution=144.0)
print(f'✅ PDF saved: {len(images)} slides → {os.path.basename(out)}')
print(f'   File size: {os.path.getsize(out) / 1024 / 1024:.1f} MB')

for p in paths:
    os.remove(p)
PYEOF

# ── Open (macOS) ──────────────────────────────────────────
open "$OUT" 2>/dev/null || true
echo "   Done."
