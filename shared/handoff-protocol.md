---
title: Handoff Protocol
source: dev-agent-team v0.1.0
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory]
status: current
---

# Handoff Protocol

How agents pass work between phases. The TPM is responsible for ensuring handoffs are clean.

## Handoff Triggers

Standard pipeline:

```
PM (story written)
   → Architect (design API contract + data model)
      → UX Designer (wireframe + flow)
         → Dev Manager (break into tasks)
            → Backend Dev + Frontend Dev (implement in parallel)
               → QA Engineer (test)
                  → TPM (mark done in dashboard)
```

A handoff happens whenever an agent completes their part and the next agent needs to act.

## Handoff Record

Filename: `pmo/handoffs/HANDOFF-{NNN}-{from}-to-{to}-{topic}.md`

```yaml
---
title: HANDOFF-NNN — {from-agent} → {to-agent} — {topic}
created: 2026-05-03
from: pm
to: architect
story: STORY-007
status: open | acknowledged | done
---
```

Body:

```markdown
## What I'm handing over
- Brief summary
- Link to the story / decision / artifact

## What's done
- [x] Item
- [x] Item

## What you need to do
- [ ] Concrete task 1
- [ ] Concrete task 2

## Inputs you need
- Read: [story](../stories/STORY-007.md)
- Read: [arch decision](../decisions/DECISION-005-auth.md)
- Read: [wiki page](../../docs/wiki/module-tryouts.md)

## Constraints / non-goals
- Don't expand scope beyond Phase 1
- Auth must use Clerk (decided in DECISION-005)

## Acceptance criteria for handoff completion
- (when can the receiving agent mark this handoff "done"?)
```

## When to Skip Formal Handoff

Skip the file for:
- Quick clarifications (use a comment in the wiki page instead)
- Same-agent work (continuing your own task)
- Trivial fixes the next agent can pick up from the dashboard

Use the file for:
- Phase boundaries
- Cross-discipline handoffs (PM → Architect, UX → Frontend)
- Anything where context loss would slow the next agent down

## Acknowledgement

The receiving agent updates `status: acknowledged` when they pick up the work. Sets `status: done` when they hand off to the next agent (creating their own HANDOFF file).

## Surface to User

Open handoffs appear in `pmo/dashboard.md` under "📋 In-flight handoffs" so the user can see pipeline movement.
