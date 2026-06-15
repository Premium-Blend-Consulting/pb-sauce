# PB Sauce — Org-Wide Rollout (Admins)

For Premium Blend Cowork admins who want to push PB Sauce to the whole team instead of having each person install it themselves. Requires a **Team or Enterprise** plan and org-admin access.

Reference: [Manage Claude Cowork plugins for your organization](https://support.claude.com/en/articles/13837433-manage-claude-cowork-plugins-for-your-organization)

---

## What this does

Connects the `Premium-Blend-Consulting/pb-sauce` GitHub repo to your org as a plugin source, then lets you set whether it's pushed automatically, offered for self-install, or required. No teammate ever has to touch a command or a file.

## Steps

1. Sign in as an org admin and open **Organization settings → Plugins**
2. Click **Add plugins → GitHub**
3. Enter the repo: `Premium-Blend-Consulting/pb-sauce`
4. Once it resolves, set the install preference for PB Sauce:

   | Setting | Effect |
   |---|---|
   | **Installed by default** | Pushed to every member automatically (they can remove it) — recommended for the rollout |
   | **Available for install** | Listed in the org plugin catalog for self-service |
   | **Required** | Mandatory and non-removable — use only if PB Sauce should be locked on |

5. Save. Changes apply on each member's next session or plugin refresh.

## Verify it worked

Ask a teammate (not you) to open a **new** Cowork chat and run `/pb-sauce:setup`. If the walkthrough fires, they have it. If not, have them check **Settings → Customize → Plugins** to confirm PB Sauce is listed, then refresh.

## Updating the plugin later

When you push changes to the `main` branch of the repo (new reference decks, SKILL.md tweaks, etc.), the org plugin syncs from GitHub. Members pick up the update on their next refresh — no re-distribution needed. Bump the `version` in `.claude-plugin/plugin.json` so the change is trackable.

## Notes & limits

- **Plan gating:** GitHub syncing and org-level plugin management are Team/Enterprise features. On Plus, members install individually (see [README](./README.md) / [COWORK-SETUP.md](./COWORK-SETUP.md)).
- **Org-level sync is still maturing.** As of early 2026 Anthropic notes some org distribution/sync behavior is still rolling out — if a setting doesn't behave as expected, check the support article above for the current state.
- **Claude Code users** are separate — they install via `/plugin marketplace add` + `/plugin install` and are not affected by org Cowork provisioning.
