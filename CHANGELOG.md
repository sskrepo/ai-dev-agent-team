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

## [0.1.5] — 2026-05-04

### Added — backend-dev, frontend-dev + new shared protocol
- New shared protocol: [`shared/autonomous-dev-protocol.md`](shared/autonomous-dev-protocol.md). Defines fully autonomous mode for dev-execution agents (read/write any project file, make routine engineering choices inline, document in commit messages — no permission asks for tool calls or routine decisions). Pause only for: (a) approval gates per phase-deliverables-protocol, (b) decisions needing user input — file DECISION-NNN, (c) new pending items the user must deliver — add to pending-decisions/PHASE-N.md.
- Backend Dev + Frontend Dev: now read autonomous-dev-protocol at session start. New "Autonomy" section in each agent prompt formalizes the rule and the three pause exceptions.
- Orchestrator pattern: spawn prompts for dev-execution agents must include the autonomy clause explicitly so each spawned run inherits the rule.
  - **Why:** User feedback during AAUClubManager Phase 0 Wave 2 execution: "pls go fully autonomous during dev .. except for the approval gates that we discussed earlier.. don't ask permissions to read or write files." Prior implicit autonomy was being violated in pieces — agents asking "should I create this file?" or pausing between unblocked steps. This protocol makes the rule explicit.
  - **Source:** AAUClubManager Phase 0 Wave 2, 2026-05-04

---

## [0.1.4] — 2026-05-03

### Added — tpm + new shared protocol + template
- New shared protocol: [`shared/pending-decisions-protocol.md`](shared/pending-decisions-protocol.md). Defines a **single user-facing surface for "what's waiting on me?"** organized as one file per phase under `pmo/pending-decisions/`. Sections per file: 🚨 blocking, 🟡 mid-phase, 📝 open product questions, 🔮 future-phase pre-knowns, ✅ done. TPM-owned but updatable by any agent when user delivers items in chat. Reconciles with `dashboard.md` awaiting-user surface and `current-status.md`. File states: `active` (current phase), `preview` (future with pre-knowns), `placeholder` (future, no items yet), `done` (phase exited).
- TPM: now reads `pmo/pending-decisions/PHASE-{current}.md` at session start (item #7). Now writes/owns the directory. Phase-transition workflow includes marking prior phase file `status: done` and activating next phase file (promote 🔮 pre-knowns to appropriate severity buckets). Weekly lint includes pending-decisions consistency checks.
- Status update protocol: now lists pending-decisions as the third live tracking surface (alongside dashboard and current-status). Any agent that learns of a user delivery moves the row to ✅ Done in the same change as dashboard reconciliation — not just TPM.
- Template: `templates/pmo/pending-decisions/README.md` — bootstrap skeleton for new projects.
  - **Why:** User feedback during AAUClubManager Phase 0 execution: "Can you pls create a directory pending decisions, and create md files per phase in it, so that I have one place to see what is waiting on me always, and also keep it updated when I completed my tasks." Then: "I think my previous instruction on 'pending decisions' should be going into TPM agent, so that for future projects I can benefit." Pattern initially built locally in AAUClubManager, then promoted to canonical here.
  - **Source:** AAUClubManager Phase 0 execution session, 2026-05-03

---

## [0.1.3] — 2026-05-03

### Added — pm, ux-designer, architect, dev-manager, tpm + new shared protocol
- New shared protocol: [`shared/phase-deliverables-protocol.md`](shared/phase-deliverables-protocol.md). Defines two **mandatory approval gates per phase**:
  - **Gate 1:** PM's Product Definition Document (PDD) + UX's UI Mocks → user reviews + approves
  - **Gate 2:** Architect's OpenAPI spec changes → user reviews + approves
  - Dev Manager cannot break stories into engineering tasks until both gates pass.
- PM: now produces `docs/wiki/pdd/PDD-PHASE-{N}.md` per phase covering all user flows BEFORE writing detailed stories. Stories are written only after Gate 2 passes.
- UX Designer: now produces `docs/wiki/ux/mocks/phase-{N}/{flow-name}.md` per phase for flows that need visual spec. Companion to PDD in Gate 1.
- Architect: now produces `docs/wiki/api-changes/phase-{N}.md` per phase summarizing OpenAPI changes for explicit user approval (Gate 2). May draft in parallel with PDD review for efficiency, but Gate 2 submission must be against approved PDD.
- Dev Manager: enforces gates — verifies PDD + mocks + OpenAPI changes all `status: approved` before picking up engineering work. Cannot break stories into tasks otherwise.
- TPM: tracks gate status, surfaces gates in dashboard with reply syntax, transitions artifacts from `in-review` → `approved` on user approval.
  - **Why:** User feedback during AAUClubManager DECISION-001 review: "I want product manager agent to always write Product definition documents, reviewed and approved by me, for every phase, covering all customer or user flows.. before its picked up by architect agent or Dev manager agent for execution .. and whereever appropriate, I want UI mocks to be generated by UX agent along with product definition.. and Architect to generate open API spec for my approval .. before Dev manager agent pickups for execution"
  - **Source:** AAUClubManager bootstrap session, 2026-05-03
- All affected agents: read `phase-deliverables-protocol.md` at session start.

---

## [0.1.2] — 2026-05-03

### Added — tpm, architect, product-manager + new shared protocol
- New shared protocol: [`shared/phase-kickoff-brief.md`](shared/phase-kickoff-brief.md). Defines the **Phase Kickoff Brief** — a mandatory document filed at the start of every phase that surfaces external dependencies (accounts, API keys, approvals, DNS) the user must handle. Bucketed by urgency (🚨 critical path / 🟡 mid-phase / 🟢 nice-to-have) with step-by-step instructions, lead times, and "deliver to agents" handoff details.
- TPM: now owns filing + maintaining the Phase Kickoff Brief at every phase transition. Reads phase-kickoff-brief protocol at session start. Updates phase-transition workflow to file the next brief before phase begins.
- Architect: now produces an **External Dependencies Roster** (technical) per phase and hands to TPM. Includes long-lead items like WhatsApp Business API approval, Stripe KYC, etc.
- Product Manager: now produces external dependency identification for **product/legal** items (ToS, business entity, compliance posture, content seeding) per phase, hands to TPM.
  - **Why:** User feedback during AAUClubManager DECISION-001 discussion: "I need Development manager agent or TPM agent to highlight all external dependencies that I need to take care of (create a account with Whatsapp / Twilio, register and get me the Clerk API Key kind of stuff), basically anything agents or you cant do, clearly highlighted to me at the start of every phase .. so that while agents code, I go figure those things out."
  - **Source:** AAUClubManager bootstrap session, 2026-05-03

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
