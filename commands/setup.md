---
description: First-time setup walkthrough for PB Sauce — confirms install, shows what it can do, and builds a sample slide
allowed-tools: Read, Write, Bash
---

# PB Sauce — Setup & Walkthrough

Welcome to PB Sauce, Premium Blend's internal deck builder. This is a one-time orientation — takes about two minutes.

## What you'll do

Walk the user through five quick steps:

---

## Step 1: Confirm the skill is loaded

Tell the user:

> ✅ **PB Sauce is installed and ready.**
>
> You can build a fully branded Premium Blend HTML deck from a plain-language brief. No PowerPoint. No templates. Just describe the deck and Claude builds it.

---

## Step 2: Explain the core workflow

Show this in a clean, readable format:

> **How it works:**
>
> 1. Describe your deck — audience, type, tone, slide count, any source material
> 2. Claude picks the right reference layout and mirrors the visual DNA
> 3. You get a single `.html` file — open in Chrome, edit text in-browser
> 4. Say "export to PDF" when you're ready to share

> **Trigger it anytime with:**
> ```
> /pb-sauce:deck
> ```
> Or just say "build a PB deck for…" in plain language — Claude will pick it up.

---

## Step 3: Model strategy (important for token budgets)

This step matters most for anyone on a **Claude Plus** plan — you have a smaller per-session token budget than Max, and a full deck build can eat into it fast. The fix is to split the work across two models:

> **⚡ Plan in Opus, build in Sonnet.**
>
> Building a deck has two phases, and they want different models:
>
> | Phase | Model | Why |
> |---|---|---|
> | **1. Plan the outline** — structure, slide-by-slide content, key messages, data points | **Opus** | Opus is the strategist. Use it to nail *what* goes on each slide. This is the thinking-heavy part and it's cheap on tokens — it's just text. |
> | **2. Build the HTML** — generate the actual styled deck | **Sonnet** | Sonnet executes the layout fast and burns far fewer tokens producing the long HTML output. Switch here once the outline is locked. |
>
> **The move:** Start in Opus, say *"plan me a deck outline for…"*, refine it until the content is right, then switch to Sonnet (`/model`) and say *"now build this in PB Sauce."*
>
> *Not sure how to switch? In Claude Code type `/model`; in Cowork/Desktop use the model dropdown near the message box.*
>
> Doing the whole thing in Opus works, but you'll burn through your session budget much faster. Planning is where Opus earns its keep; execution is where Sonnet saves you.

---

## Step 4: Show what it knows

Tell the user about the nine reference layouts available:

> **Reference layouts baked in:**
>
> | Use case | Layout |
> |---|---|
> | QBR, account review | Walgreens or Starbucks deck |
> | Strategy pitch | Thrivent deck |
> | Capabilities, intro | PB Sauce exec deck |
> | Ops, roadmap, planning | Flagship ops deck |
> | Data-heavy analysis | Nissan or Progressive deck |
> | Product, trust | Trust Score or AI Ops deck |

---

## Step 5: Offer a test build

Ask the user:

> Want to test it right now? I can build a quick 3-slide sample deck — just tell me:
> - Who's it for? (e.g. "a new client prospect", "internal leadership", "a QBR")
> - Any specific topic or leave it open and I'll pick something generic

If they say yes or give any input, immediately invoke the pb-sauce skill and build a 3-slide demo deck. Save it to the current working directory as `pb-sauce-demo.html` and confirm where it landed.

If they say no or skip, close with:

> You're all set. Next time you need a deck, just say the word.
> Full docs: `COWORK-SETUP.md` in this package or the README on GitHub.
