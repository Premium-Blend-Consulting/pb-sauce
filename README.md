# PB Sauce — Deck Builder

Turn a brief into a branded Premium Blend HTML deck. Outputs at 1280×720 per slide, uses PB fonts and colors, mirrors the layout DNA of real decks, and ships with a PDF exporter.

**Works in both Claude Code and Cowork.** Both produce identical output.

---

## Install (two commands)

PB Sauce ships as a plugin. Installing is two steps — add the marketplace, then install the plugin:

```
/plugin marketplace add Premium-Blend-Consulting/pb-sauce
/plugin install pb-sauce@pb-sauce
```

Then run the setup walkthrough:

```
/pb-sauce:setup
```

Claude will confirm the install, explain what it can do, walk you through the Plus-plan model strategy, and offer to build a test deck.

> Prefer clicking? Run `/plugin` with no arguments to open the plugin browser, then add the marketplace and install from the menu.
>
> First time in Cowork? Make sure you have [Claude Desktop](https://claude.ai/download) with Cowork enabled.

---

## What it does

Ask Claude something like:

> Build a QBR deck for Walgreens. 12 slides, focus on Q1 content performance and FY plan. Here's the brief: [paste].

…and it produces a self-contained HTML file styled to match PB's reference decks. No PowerPoint. No templates. Editable in-browser.

## Requirements

- [Claude Code](https://docs.claude.com/en/docs/claude-code) or Claude Desktop (Cowork)
- macOS or Linux (the PDF exporter assumes bash)
- For PDF export: Node + Python 3 on your PATH (Playwright is auto-installed on first run)

## Use it

Invoke explicitly with `/pb-sauce:deck`, or just describe the deck in plain language:

```
/pb-sauce:deck build an ops roadmap deck for internal leadership, 15 slides, punchy tone
```

or

```
Create a Premium Blend capabilities deck for a new client prospect — 10 slides.
```

Claude will:
1. Pick the right reference deck as a visual anchor
2. Generate a full HTML file with PB fonts, colors, and layout patterns
3. Save it to your current working directory

## Convert to PDF

After the deck is built, just ask Claude to "export to PDF" — it runs the bundled `scripts/export-deck-pdf.sh` against your deck. The script opens each slide in Playwright, screenshots at 2x for retina fidelity, and stitches PNGs into a PDF at 144 DPI. First run auto-installs Playwright (~30s).

## What's in the package

```
pb-sauce/
├── SKILL.md                    The system prompt + design system + rules
├── README.md                   This file
├── references/                 9 real PB decks — Claude reads these for layout DNA
│   ├── flagship-ops-deck.html
│   ├── thrivent-deck.html
│   ├── walgreens-enterprise-transformation.html
│   └── (6 more)
└── scripts/
    └── export-deck-pdf.sh      HTML → pixel-perfect PDF
```

All fonts, bean illustrations, and the deck-tools JS bundle are served from `pbsauce-6o98.vercel.app` — no local assets required.

## Customizing

- **New reference deck:** drop an HTML file into `references/` and add a row to the routing table in `SKILL.md`
- **New color or brand tweak:** edit the `:root` block in the design system section of `SKILL.md`
- **Different tone or voice:** rewrite the "Voice" section of `SKILL.md`

## Troubleshooting

**Skill doesn't show up after install:** restart Claude Code fully. The skills directory is read on startup.

**Fonts look wrong in the browser:** check your internet — fonts load from Vercel. Offline decks fall back to system-ui.

**PDF export fails on first run:** the script installs Playwright into `/tmp/deck-export`. If `/tmp` is write-locked, edit `WORKDIR` in the script.

**Bean illustrations don't load:** confirm the URLs in `SKILL.md` are current. They live under `pbsauce-6o98.vercel.app/assets/illustrations/`.

## Authors

Built by Joe Scott at Premium Blend. Questions, bugs, or feature requests — ping Joe.
