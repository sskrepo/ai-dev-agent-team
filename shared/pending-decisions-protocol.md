---
title: Pending Decisions Protocol
source: dev-agent-team v0.1.4
created: 2026-05-03
owner: team
tags: [protocol, mandatory, tpm, user]
status: current
---

# Pending Decisions Protocol

A single, user-facing surface for "what's waiting on me?" — organized per phase, kept current as items are delivered. TPM-owned.

## Why this exists

Across the project, there are several places where a user owes the team something:
- `pmo/phase-briefs/PHASE-N-kickoff.md` — external dependencies (accounts, API keys, DNS)
- `pmo/dashboard.md` — formal `🔴 Decisions awaiting your review` rows
- `pmo/decisions/DECISION-NNN-*.md` — open formal decisions
- PDDs and design docs — open product questions surfaced during writing

The user wants **one place** to scan all of it, organized by phase, with what's blocking, what's mid-phase, what's "answer when ready", and what's already done.

This protocol defines that surface.

## Directory layout (mandatory in every project)

```
pmo/pending-decisions/
├── README.md           # Directory overview and how-to
├── index.md            # All-phases counts table
├── PHASE-0.md          # Active phase
├── PHASE-1.md          # Preview / pre-knowns
├── PHASE-2.md          # Placeholder until activated
├── ...                 # One file per phase in the project plan
```

## File template — `PHASE-N.md`

```markdown
---
title: Phase N — Pending User Items
phase: N
owner: tpm
updated: YYYY-MM-DD by {agent}
status: active | preview | placeholder | done
tags: [pending, user, phase:N]
---

# Phase N — Pending User Items

**Phase status:** {one-line status}
**Open count:** 🚨 X blocking · 🟡 Y mid-phase · 📝 Z open Qs · ✅ W done
**What's gated:** {what active dev work waits on these}

Canonical setup: [PHASE-N-kickoff.md](../phase-briefs/PHASE-N-kickoff.md).

## 🚨 Blocking

| # | Item | Why it matters | Where to get it | Env vars / inputs |

## 🟡 Mid-phase

| # | Item | Why it matters | Notes |

## 📝 Open product questions

| # | Question | Default placeholder if no answer |

## 🔮 Future-phase pre-knowns

| Phase | Item | When |

## ✅ Done

| When | Item | Notes |

## How to mark items done

(Standard text — see canonical README for the two-option flow.)
```

## File states

| State | Meaning | When |
|-------|---------|------|
| `active` | Current phase; populated with concrete items | Phase is in execution |
| `preview` | Future phase with known pre-requisites surfaced ahead | Pre-knowns identified during a prior phase |
| `placeholder` | Future phase, no pre-knowns yet | Skeleton only |
| `done` | Phase has exited; file kept for audit trail | After phase retrospective |

## Section semantics

- **🚨 Blocking** — gates active dev work. Agents are stalled or working around these. **Specific to active phase only** — preview phases should not have 🚨 items.
- **🟡 Mid-phase** — needed before phase exits, not urgent today. Often hosting/infrastructure choices.
- **📝 Open product questions** — non-blocking. Brand, naming, UX preferences. Should be answered before downstream work that depends on them (e.g., before Phase 1 mocks if related to UI).
- **🔮 Future-phase pre-knowns** — heads-up items for upcoming phases. **Don't act yet**. Surfaces here so the user can plan, especially items with long lead times.
- **✅ Done** — completed items with date. Keep for audit trail. Don't delete; new items append.

## Update rules (mandatory)

### When the user delivers an item

Any agent that learns of a delivery (credentials in chat, decision answered, account confirmed) MUST:
1. Move the row from its current section → `✅ Done` with today's date
2. Reconcile `pmo/dashboard.md` — remove from awaiting-user surface, add to recent decisions if applicable
3. Reconcile `docs/wiki/current-status.md` — note the delivery if it shifts phase status
4. Append to `docs/wiki/log.md`: `## [YYYY-MM-DD] {agent} | {item} delivered; updated pending-decisions/PHASE-N.md and trackers.`
5. Surface what just unblocked in the response to the user

### When a new pending item is identified

If an agent surfaces something new the user must do (a credential we didn't realize we needed, a product question that came up during design):
1. Add the row to the appropriate phase file (`pmo/pending-decisions/PHASE-N.md`) under the right severity bucket
2. Add the same item to `pmo/dashboard.md` awaiting-user surface
3. Mention it in the agent's session-end report so TPM is aware
4. TPM reconciles on next session if not already consistent

### When phases transition

When a phase exits, TPM:
1. Marks `PHASE-N.md` as `status: done` with the closing date
2. Activates `PHASE-(N+1).md` (preview → active), populates with concrete items pulled from the new phase's kickoff brief
3. Promotes any 🔮 future-phase pre-knowns into 🚨/🟡/📝 buckets in the now-active phase

## Ownership

- **TPM owns** the directory and the consistency between pending-decisions/ and other trackers (dashboard, current-status, log)
- **Any agent** can update pending-decisions/PHASE-N.md when user delivers items in chat (must reconcile other trackers in the same change — see [status-update-protocol.md](status-update-protocol.md) Completion → TPM rule)
- **The user** can edit any file directly; agents reconcile on next session

## Relationship to other surfaces

| File | Authoritative for | Audience |
|------|-------------------|----------|
| `pending-decisions/PHASE-N.md` | "What you owe right now" — UX layer | **User** |
| `pmo/phase-briefs/PHASE-N-kickoff.md` | The "how-to" for each external dep — instruction layer | User (deep dive) |
| `pmo/decisions/DECISION-NNN-*.md` | Formal decision records — durable audit trail | User + agents (long-term) |
| `pmo/dashboard.md` | Live program view — work + blockers + decisions | User + agents (daily) |
| `docs/wiki/current-status.md` | Narrative status snapshot — read at session start | Agents |

The pending-decisions files **link to** the canonical sources rather than duplicating them. If pending-decisions and another tracker disagree, the canonical source wins; pending-decisions gets reconciled.

## Session-start reading

Every agent reads `pmo/pending-decisions/PHASE-N.md` for the active phase as part of the mandatory startup file list. Knowing what the user owes informs what to spawn, what to defer, and what to flag.

## Lint checks

TPM weekly lint should verify:
- Active phase file is `status: active`; all others are `preview`, `placeholder`, or `done`
- Counts in `index.md` match counts in each phase file
- `🚨 Blocking` items also appear in `dashboard.md` awaiting-user surface
- `✅ Done` items match what's in `pmo/decisions/` (status: decided) and recent log entries
- No orphan items: every row links to either a kickoff brief, a decision doc, or a known external service URL

## Bootstrap (new project)

When initializing a new project, copy the skeleton from `dev-agent-team/templates/pmo/pending-decisions/`. Create one `PHASE-N.md` per phase in `pmo/phases.md`, all initially `status: placeholder`. The active phase is promoted to `status: active` when its kickoff brief is filed.
