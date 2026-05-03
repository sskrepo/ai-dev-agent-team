# Conventions

How the dev agent team is structured and maintained.

## Wiki Pattern (Karpathy LLM Wiki)

Three layers everywhere:

| Layer | In `dev-agent-team/` | In a project |
|-------|----------------------|--------------|
| **Raw sources** | `feedback/pending.md` | `docs/raw/` |
| **Wiki** (LLM-compiled) | `agents/`, `shared/` | `docs/wiki/`, `pmo/` |
| **Schema** | `README.md`, this file | `CLAUDE.md` |

Plus two universal files in every wiki:
- **`index.md`** — catalog of all pages with one-line summaries
- **`log.md`** — append-only `## [YYYY-MM-DD] operation | description`

## Agent File Format

Each `agents/*.md` file uses Claude Code subagent format:

```yaml
---
name: agent-name
description: When the orchestrator should invoke this agent (be specific so other agents know when to delegate)
tools: Read, Write, Edit, Bash, Grep, Glob, WebFetch
model: sonnet
---

# Role

One-paragraph description of who this agent is and what they own.

## Reads (session start)
- shared/wiki-protocol.md
- shared/decision-protocol.md
- (etc.)
- docs/wiki/index.md, current-status.md, log.md
- (topic-specific pages relevant to current task)

## Writes
- (which wiki/pmo files this agent updates)

## Workflow
- (numbered steps for the agent's typical task)

## Outputs
- (what artifacts this agent produces)

## Hands off to
- (which agent receives the work next, with what handoff)

## Boundaries
- (what this agent does NOT do)
```

## Wiki Page Frontmatter

Every wiki page (in `docs/wiki/`, `pmo/`, `shared/`, `agents/`) starts with:

```yaml
---
title: Page Title
source: where this info came from (file path, conversation, derived)
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: tpm | pm | architect | ...
tags: [module:tryouts, phase:1, kind:decision]
status: current | superseded | draft
---
```

Exceptions: `index.md`, `log.md`, `CHANGELOG.md`, `VERSION`, `README.md` — no frontmatter (they're meta-files).

## Versioning

Semver in `VERSION`:
- **Major** — agent responsibilities or protocols change in breaking ways
- **Minor** — new agent added, new behavior added to existing agent
- **Patch** — clarifications, typo fixes, prompt tuning

Every change logged in `CHANGELOG.md` with the user feedback that prompted it (when applicable).

## How Behavior Changes Flow

```
User feedback (during a project session)
   ↓
Agent classifies: one-off | project-only | permanent
   ↓
If permanent:
   ↓
Agent edits dev-agent-team/agents/{name}.md
Agent appends to dev-agent-team/CHANGELOG.md
Agent appends to dev-agent-team/feedback/applied.md
Agent bumps VERSION (patch/minor/major)
   ↓
All projects using the team see the update on next run
```

See [shared/feedback-protocol.md](shared/feedback-protocol.md) for full protocol.

## Conversation Logging

Conversation logs are NEVER stored in the project repo. They live in:

```
~/Google Drive/AI Projects/Claude/Conversations/{project-name}/YYYY-MM-DD.md
```

Each project's `.claude/settings.json` configures hooks that write verbatim user prompts and assistant responses to this folder. Google Drive syncs them automatically.

The project's `conversations` symlink (gitignored) points to the synced folder for easy local access.
