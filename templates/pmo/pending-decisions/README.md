# Pending Decisions

User-facing index of "what's waiting on me?" — one file per phase. TPM-owned.

See canonical protocol: [`dev-agent-team/shared/pending-decisions-protocol.md`](../../../shared/pending-decisions-protocol.md).

## Bootstrap

For a new project:
1. Copy this directory as `pmo/pending-decisions/` in the project root
2. Create one `PHASE-N.md` per phase in `pmo/phases.md` (all initially `status: placeholder`)
3. Create `index.md` with the all-phases counts table
4. Activate the first phase (`status: active`) when its kickoff brief is filed

## File template

See `dev-agent-team/shared/pending-decisions-protocol.md` for the per-phase file template, section semantics, and update rules.

## Sections

Each `PHASE-N.md` contains:
- 🚨 Blocking — gates active dev work
- 🟡 Mid-phase — needed before phase exits
- 📝 Open product questions — non-blocking
- 🔮 Future-phase pre-knowns — heads-up only
- ✅ Done — completed, kept for audit
