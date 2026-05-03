# Changelog

All behavior changes to the dev agent team. Newest at top.

Format:
```
## [VERSION] — YYYY-MM-DD
### Changed/Added/Removed — agent-name
- What changed
  - **Why:** reason or user feedback that triggered the change
  - **Source:** session/project where this came from
```

---

## [0.1.1] — 2026-05-03

### Added — product-manager
- Market research as a first-class PM responsibility (competitor scans, feature comparison, pricing landscape, sentiment analysis, positioning).
- New `docs/wiki/market-research/` directory pattern with `{topic}.md` page format.
- WebSearch tool added to PM toolset (alongside existing WebFetch).
- Workflow updated: PM now conducts initial market research as part of raw-requirements ingest, and per-module research before detailed story design.
  - **Why:** User feedback during AAUClubManager bootstrap — "Also I want you to do market research as well, may be thats a task Product manager agent can do?"
  - **Source:** AAUClubManager bootstrap session, 2026-05-03

---

## [0.1.0] — 2026-05-03

### Added — initial release
- 8 agents: product-manager, architect, ux-designer, tpm, dev-manager, backend-dev, frontend-dev, qa-engineer
- 6 shared protocols: wiki, decision, handoff, status-update, feedback, escalation
- Templates for new project bootstrap
- `init-project.sh` and `sync-agents.sh` scripts
- Wiki-first knowledge pattern (Karpathy LLM Wiki) baked into every agent
- Conversation logging hooks (UserPromptSubmit + Stop) writing to Google Drive
- **Source:** AAUClubManager bootstrap session, 2026-05-03
