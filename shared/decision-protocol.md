---
title: Decision Protocol
source: dev-agent-team v0.1.0
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory]
status: current
---

# Decision Protocol

How agents escalate decisions to the user. The principle: **bring options, not problems**.

## When to File a Decision

File a `pmo/decisions/DECISION-XXX-*.md` when:
- A choice has long-term architectural impact (DB engine, auth provider, framework)
- A trade-off requires the user's preference (cost vs. speed, simplicity vs. flexibility)
- The choice locks in scope (what's in MVP vs. v2)
- A choice affects user experience in a non-trivial way
- The agents disagree and can't resolve internally

## When NOT to File a Decision

Do NOT file a decision for:
- Implementation details with no user-visible impact (variable names, file paths, internal helper structure)
- Choices already specified in the wiki or CLAUDE.md
- Reversible choices that cost <1 hour to change
- Bugs or fixes — just fix them

## Decision File Format

Filename: `pmo/decisions/DECISION-{NNN}-{kebab-slug}.md`

```yaml
---
title: DECISION-NNN — Short Title
status: open | decided | superseded
created: 2026-05-03
owner: agent-name (the one who filed it)
deciders: user
tags: [phase:0, kind:architecture]
---
```

Body sections (mandatory):

```markdown
## Context
2-4 sentences. Why are we deciding this now? What changes if we don't decide?

## Options
### Option A — {name}
- **Pros:** ...
- **Cons:** ...
- **Effort:** S / M / L
- **Reversibility:** easy / hard / one-way

### Option B — {name}
(same structure)

### Option C — {name}
(if applicable; max 3 options usually)

## Recommendation
The team's recommendation, with one-sentence reasoning.

## Your call
> Reply with: A, B, C, or "tell me more about X"
```

After user decides, append:

```markdown
## Decision (YYYY-MM-DD)
User chose Option {X}. Recorded as the source of truth in [wiki-page-name](../docs/wiki/wiki-page.md).

## Consequences
- What this enables
- What this rules out
- What now needs to change in the wiki/code
```

Then change `status: decided` and update the relevant wiki page (e.g., `docs/wiki/architecture.md`) with the decision and a citation back to the DECISION file.

## Decision Numbering

Sequential, project-wide, never reused. TPM keeps the counter in `pmo/decisions/README.md`.

## Surface to User

Open decisions appear in `pmo/dashboard.md` under a "🔴 Decisions awaiting your review" section. The TPM is responsible for keeping this list accurate.

## Examples of Good Decisions to File

- "Should we use Twilio or Vonage for WhatsApp?"
- "MVP scope: include travel tournaments in Phase 4 or defer to Phase 6?"
- "Free tier limits: how many players per club?"
- "Player data retention policy after they leave the club?"

## Examples of Bad Decisions to File (just decide)

- "Should the user table column be `created_at` or `createdAt`?" (pick one, document in conventions)
- "Should we use ESLint or Biome?" (pick the one with better TS support)
- "Should the login button be blue or green?" (designer decides)
