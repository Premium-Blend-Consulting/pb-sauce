---
description: Build a branded Premium Blend HTML deck from a brief
argument-hint: "[audience] [type] [tone] [slide count] [brief or context]"
allowed-tools: Read, Write, Bash
---

# /pb-sauce:deck — Build a Deck

Invoke the PB Sauce skill to generate a branded Premium Blend HTML presentation.

## Instructions

Load the pb-sauce SKILL.md from this plugin's root directory, then build the deck per the skill instructions using `$ARGUMENTS` as the brief.

If `$ARGUMENTS` is empty, ask the user the five intake questions (audience, type, tone, slide count, source material) before building.

Save the output `.html` file to the current working directory with a descriptive filename.

## Token-budget tip (Plus plans)

If the user is currently on Opus and hasn't yet locked an outline, gently suggest the two-phase workflow before generating a full deck: plan the outline in Opus, then switch to Sonnet (`/model`) to build the HTML. Building long HTML output in Opus burns session tokens fast. If they're already on Sonnet or explicitly want to just build, skip the nudge and proceed.
