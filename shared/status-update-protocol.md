---
title: Status Update Protocol
source: dev-agent-team v0.1.0
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory]
status: current
---

# Status Update Protocol

How agents keep `pmo/dashboard.md` and `docs/wiki/current-status.md` accurate.

## Two Status Surfaces

### `pmo/dashboard.md` — TPM-owned, the user's main view

Updated by the TPM after every meaningful event. Other agents update only their own rows.

Structure:

```markdown
# Project Dashboard

**Current phase:** Phase 1 — Core (Weeks 1-3)
**Updated:** 2026-05-03 14:30 by tpm

## 🔴 Decisions awaiting your review (N)
- [DECISION-007 — Notification provider](decisions/DECISION-007-notification-provider.md)

## 🟡 In-flight work
| Story | Module | Status | Owner | Blocked by |
|-------|--------|--------|-------|-----------|
| STORY-001 | Auth | 🔨 Coding | backend-dev | — |
| STORY-002 | Onboarding | 🎨 Design | ux-designer | — |

## 📋 In-flight handoffs
- [HANDOFF-005 — pm → architect — payment data model](handoffs/HANDOFF-005-pm-to-architect-payment-data-model.md)

## ✅ Done this phase (N)
- STORY-000 — Project scaffold
- ...

## 🚧 Blocked
| Story | Blocked by | Action needed |
|-------|-----------|---------------|
| (none) | | |

## ⚠️ Risks / contradictions
- (TPM lint findings)
```

### `docs/wiki/current-status.md` — narrative version

Single-page narrative for context-loading. Agents read this at session start.

```markdown
---
title: Current Status
source: derived from pmo/dashboard.md
compiled_at: 2026-05-03T14:30:00Z
created: 2026-04-01
owner: tpm
tags: [meta]
status: current
---

# Current Status

## Where we are
1-2 paragraphs: current phase, what was done last session, what's about to happen.

## Active stories
- STORY-001 (Auth) — backend implementing Clerk integration
- STORY-002 (Onboarding) — UX wireframing

## Awaiting user decision
- DECISION-007 — Notification provider (Twilio vs. Vonage for WhatsApp)

## Recent decisions (last 7 days)
- DECISION-006 — Knex chosen for DB layer (RDBMS-agnostic)

## Next milestones
- End of Phase 1: working onboarding flow + auth
- Phase 2 starts: practice scheduling
```

## Status Symbols

Standard across the team:
- 📝 Drafting (PM, Architect)
- 🎨 Design (UX, Architect)
- 🔨 Coding (Backend, Frontend)
- 🧪 Testing (QA)
- 🔍 Review (anyone)
- 🚧 Blocked
- 🔴 Awaiting user decision
- ✅ Done
- ⏸️ Paused / deferred
- ❌ Cancelled

## Update Rules

- **Every agent**: when you start a task, update its row to your current symbol + your name
- **Every agent**: when you finish or hand off, update accordingly
- **TPM only**: phase transitions, lint findings, risks, top-level summaries
- **Never** silently change status without an entry in `docs/wiki/log.md`

## Completion → TPM (mandatory)

Every agent finishing any unit of work — a wiki page, a story, a design, a code change, a test run — MUST close the loop with the TPM. No silent work. The TPM is the single source of truth for "where are we?" — if the dashboard doesn't show it, it didn't happen.

What "closing the loop" means:

1. **Append a session log entry** in `docs/wiki/log.md` — `## [YYYY-MM-DD] {agent} | {what changed}`. One line, terse, links to the artifact.
2. **Update your row** in `pmo/dashboard.md` to the new status symbol (✅ done, ➡️ handed off, 🚧 blocked, etc.).
3. **If status shifted at the phase/program level** (gate passed, blocker cleared, decision filed), update `docs/wiki/current-status.md` too, or flag the TPM to do it.
4. **If handing off to another agent**, file the `pmo/handoffs/HANDOFF-NNN-...md` record per [handoff-protocol.md](handoff-protocol.md).
5. **Surface anything the TPM should escalate** — new blockers, surprises, scope creep, decisions needing user input — at the top of your final report so the TPM can pull it into the dashboard's 🔴/🚧/⚠️ rows.

Orchestration agents (and the user's primary chat) should reinforce this by:
- Including "report back so TPM can update dashboard, log, and current-status" in every spawn prompt
- Running TPM after any agent completion to reconcile the trackers

This rule applies to **every phase including Phase 0**, and **every agent type** including TPM itself (which logs its own bookkeeping changes).

## Frequency

Real-time. The dashboard is a live reflection of the project state, not a weekly report.
