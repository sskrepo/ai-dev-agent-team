---
title: Autonomous Dev Protocol
source: dev-agent-team v0.1.5
created: 2026-05-04
owner: team
tags: [protocol, mandatory, autonomy]
status: current
---

# Autonomous Dev Protocol

During implementation work, agents operate **fully autonomously** on file ops and routine engineering choices. The user does not want to be asked permission for tool calls or routine implementation decisions during dev.

This protocol defines when to act and when to pause.

## Default mode: autonomous

When implementing tasks (Backend Dev, Frontend Dev, QA Engineer, Dev Manager during execution), agents:

- **Read any file** in the project without asking — wiki, spec, conventions, env templates, code
- **Write/edit any project file** as part of executing the task
- **Make routine implementation choices** inline (library version pins, file structure, ESM vs CommonJS, npm scripts naming)
- **Document choices** in commit messages, code comments, or wiki updates — not by interrupting the user
- **Run tests, builds, codegen, linters** without asking
- **Fix bugs you encounter** in code paths you touched, including in code another agent wrote

## Pause for these (mandatory)

Even in autonomous mode, agents stop and surface for user input on:

1. **Approval gates** ([phase-deliverables-protocol.md](phase-deliverables-protocol.md)):
   - Gate 1: PDD + UI mocks → user approves before Architect's spec is finalized
   - Gate 2: OpenAPI spec → user approves before Dev Manager picks up engineering work

2. **Decisions requiring user input** ([decision-protocol.md](decision-protocol.md)):
   - Scope changes (defer a feature, add a feature, change phase plan)
   - Stack-level architecture choices (DB engine, auth provider, framework swap)
   - Cross-cutting design choices that materially affect cost or roadmap
   - File `pmo/decisions/DECISION-NNN-*.md` and surface in dashboard with 2-3 options

3. **Pending items the user must deliver** ([pending-decisions-protocol.md](pending-decisions-protocol.md)):
   - New external credentials, accounts, approvals → add row to `pmo/pending-decisions/PHASE-N.md` and surface
   - Don't stub-and-forget; the user must see it

4. **Prohibited actions** (per Claude's safety rules — non-negotiable):
   - Never auto-execute payments, account creation, password-protected logins
   - Never permanently delete user data
   - Never modify access controls / sharing settings
   - Never enter sensitive financial data

5. **Security or correctness issues requiring user-side action**:
   - Found a vulnerability → surface it
   - Found a correctness bug that requires a product decision to fix → surface it

## What this looks like in agent prompts

Spawn prompts for dev-execution agents (backend-dev, frontend-dev, qa-engineer) should include this language:

> Operate in fully autonomous mode for this task. Read any project files you need. Write/edit files freely as part of the work. Make implementation choices inline and document them in commit messages or code comments. Do not pause to ask permission for tool calls or routine engineering decisions. Pause only for: (a) approval gates per phase-deliverables-protocol.md if any are open, (b) decisions requiring user input — file as DECISION-NNN, (c) new pending items the user must deliver — add to pending-decisions/PHASE-N.md.

Project orchestrators (the user's main chat) should NOT pre-confirm individual file reads/writes/edits with the user before spawning. The autonomy rule is in effect from spawn until the agent reports back.

## Examples

### Autonomous (just do it)
- "I need to read CLAUDE.md and openapi.yaml" → read them
- "Tests need a vitest config" → write it; document choices in the file
- "Library SDK has a new package name (deprecation)" → use the new one; note in commit message
- "Need to copy creds from worktree-root .env.local to server/.env" → do it
- "The agent before me wrote a placeholder; I now have the real thing" → replace it

### Pause and surface
- "PDD-PHASE-N is ready for review" → ask `GATE-1-PHASE-N: approved?`
- "I found we need OCI credentials we hadn't surfaced" → add row to pending-decisions/PHASE-N.md and mention in report
- "The architecture should change DBs" → file DECISION-NNN with options
- "I encountered a security issue (e.g., a hardcoded secret in user's repo)" → surface explicitly

## Why

User-stated explicitly during AAUClubManager Phase 0 Wave 2 execution (2026-05-04): "pls go fully autonomous during dev .. except for the approval gates that we discussed earlier.. don't ask permissions to read or write files."

The prior implicit autonomy was being violated in pieces — agents were asking "should I create this file?" or pausing between steps. This protocol makes the rule explicit and uniform across the team.

Approval gates and decision-files remain the **only** sanctioned interruption channels. Don't replace them with informal "should I proceed?" pings.
