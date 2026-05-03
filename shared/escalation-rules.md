---
title: Escalation Rules
source: dev-agent-team v0.1.0
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory]
status: current
---

# Escalation Rules

When to involve the user vs. proceed autonomously. **Default: proceed.** Bug the user only when listed below.

## The Principle

Treat the user like a busy executive. They hired a competent team. Most things should be decided by the team. Only escalate when:
- The decision has long-term impact and reasonable people would choose differently
- The choice involves money, time, or scope trade-offs
- A critical assumption is unverifiable from the wiki/code
- Two agents disagree and can't resolve internally

## ALWAYS Escalate (file a DECISION)

- Adding/removing a major feature from the MVP
- Changing the tech stack (DB engine, auth provider, framework, hosting)
- Anything affecting cost (paid services, third-party APIs with cost tiers)
- Anything affecting users' data privacy or compliance
- Scope-shifting choices: "should we build X now or in Phase N?"
- External dependencies that lock us in (vendor selection)
- UX choices that change the core user flow
- Pricing model decisions
- Anything legal (terms, ToS, GDPR)

## SOMETIMES Escalate (judgment call)

- Two equally-good technical options where the team has no strong preference → file decision
- Story scope ambiguity that can't be resolved from the wiki → ask in chat
- Conflicting requirements between modules → file decision

## NEVER Escalate (just do it)

- Code structure, file names, variable names
- Choosing between equivalent libraries with no lock-in
- Bug fixes
- Refactors that don't change behavior
- Adding tests
- Writing documentation
- Style/lint choices that follow CLAUDE.md
- Implementation details inside an already-decided design
- Wiki page organization

## How to Escalate Without Bugging

If you need user input, file a `DECISION-XXX-*.md` and continue working on **other unblocked tasks**. Don't sit idle.

The TPM surfaces open decisions in the dashboard. The user reviews on their schedule, not yours.

## Synchronous vs. Async

- **Async** (preferred): file a decision, continue work, user reviews when ready
- **Sync** (rare): only when the entire pipeline is blocked — surface in the chat directly

If you must go sync, format as:
```
🔴 BLOCKING DECISION — {topic}

Three options: A, B, C. My recommendation: B because {reason}.

Filed full analysis at pmo/decisions/DECISION-NNN-*.md.

Need your call to proceed.
```

## Escalation Anti-Patterns

❌ Asking the user about every API field name
❌ Asking the user to pick between two libraries when one is clearly better
❌ Asking the user how to implement something the wiki already specifies
❌ Asking the user the same question twice (check `pmo/decisions/` first)
❌ Pinging the user for status updates ("are you free to review?") — let the dashboard speak

## When in Doubt

Default: **proceed**. Document your reasoning in the wiki. If the user disagrees later, that's a [feedback-protocol](feedback-protocol.md) moment, not an escalation failure.
