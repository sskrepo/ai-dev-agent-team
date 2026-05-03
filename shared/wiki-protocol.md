---
title: Wiki Protocol
source: dev-agent-team v0.1.0
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory]
status: current
---

# Wiki Protocol (mandatory for every agent)

This is the **Karpathy LLM Wiki pattern** applied to every project. Every agent MUST follow this protocol on every session.

## Three Layers

| Layer | Where | Who writes |
|-------|-------|-----------|
| **Raw sources** | `docs/raw/` | Never edited (immutable inputs) |
| **Wiki** | `docs/wiki/`, `pmo/` | Agents own writes (compiled knowledge) |
| **Schema** | `CLAUDE.md` | Sets project rules |

## Universal Files

Every project wiki has:

- **`docs/wiki/index.md`** — catalog of all wiki pages with one-line summaries
- **`docs/wiki/log.md`** — append-only `## [YYYY-MM-DD] agent | what changed`
- **`docs/wiki/current-status.md`** — single-paragraph + bullet list of where the project is right now
- **`pmo/dashboard.md`** — TPM-owned program dashboard (single pane of glass)
- **`manifests/raw_sources.csv`** — index of every file in `docs/raw/`

## Session Start (mandatory)

Every agent, on invocation, reads in this order:
1. `CLAUDE.md` — project rules (loaded automatically)
2. `docs/wiki/index.md` — what pages exist
3. `docs/wiki/current-status.md` — where things stand
4. `docs/wiki/log.md` — recent session history (last 10 entries)
5. `pmo/dashboard.md` — current phase, blockers
6. **Topic-specific pages relevant to the current task** (don't read everything)

## During Work

- **New decision made** → write/update the relevant wiki page immediately
- **New raw doc encountered** → register in `manifests/raw_sources.csv`
- **Code/design diverges from wiki** → update wiki in same session (wiki and code MUST agree)
- **Decision needs user input** → use `decision-protocol.md` to file a `pmo/decisions/DECISION-XXX-*.md`

## Session End (mandatory)

Before ending:
1. Append to `docs/wiki/log.md`: `## [YYYY-MM-DD] {agent-name} | {one-line summary of what changed}`
2. Update `docs/wiki/current-status.md` if status changed
3. Update `pmo/dashboard.md` if any task moved phases
4. Hand off via `handoff-protocol.md` if next agent needs to act

## Wiki Page Format

Every wiki page begins with:

```yaml
---
title: Page Title
source: where this info came from
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: agent-name
tags: [module:tryouts, phase:1]
status: current | superseded | draft
---
```

Body uses:
- Markdown headings, lists, tables
- Internal cross-references: `[link text](other-page.md)`
- Code blocks for examples
- Citations: when info comes from a raw source, cite it: `(from docs/raw/requirements.txt §3.2)`

## Lint (run periodically by TPM)

- Find pages not in `index.md` (orphans) → add or delete
- Find pages with `status: superseded` still being referenced → update references
- Find code/wiki contradictions → flag in `pmo/dashboard.md`
- Find raw sources not in `manifests/raw_sources.csv` → register them
- Find stale `current-status.md` (older than 7 days with no log entries) → refresh

## Why This Pattern

From Karpathy's LLM Wiki: "instead of rediscovering knowledge from scratch on every question, build a persistent compounding artifact." Knowledge is compiled once, kept current, never re-derived.

For a multi-agent dev team, this means:
- Agents don't repeat each other's analysis
- Decisions are permanent and citable
- New team members (or future Claude sessions) ramp up by reading the wiki
- The wiki and code stay in sync (same session updates both)
