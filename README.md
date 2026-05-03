# Dev Agent Team

A reusable team of Claude Code subagents for building software products end-to-end.

This is the **canonical source** for all agent prompts. Projects symlink into `agents/` from their `.claude/agents/` directory, so updates here propagate to every project using the team.

## The Team (8 agents)

| Agent | Owns |
|-------|------|
| [product-manager](agents/product-manager.md) | User stories, acceptance criteria, MVP scope, prioritization |
| [architect](agents/architect.md) | API contracts, data model, tech decisions, ADRs |
| [ux-designer](agents/ux-designer.md) | Wireframes, user flows, component specs, design system |
| [tpm](agents/tpm.md) | Cross-phase tracking, dashboard, decision queue, handoffs |
| [dev-manager](agents/dev-manager.md) | Engineering execution, task breakdown, code quality |
| [backend-dev](agents/backend-dev.md) | API implementation, DB, business logic, integrations |
| [frontend-dev](agents/frontend-dev.md) | Web UI (one of many API clients) |
| [qa-engineer](agents/qa-engineer.md) | API contract tests, E2E, UAT, bug filing |

## Shared Protocols

Every agent inherits these. Read first:

- [wiki-protocol.md](shared/wiki-protocol.md) — How to read/write the project wiki
- [decision-protocol.md](shared/decision-protocol.md) — How to escalate decisions to user
- [handoff-protocol.md](shared/handoff-protocol.md) — How to hand work to the next agent
- [status-update-protocol.md](shared/status-update-protocol.md) — How to update the dashboard
- [feedback-protocol.md](shared/feedback-protocol.md) — How to handle behavior-change feedback (self-improvement)
- [escalation-rules.md](shared/escalation-rules.md) — When to bug user vs. proceed autonomously

## Self-Improvement

When a user gives feedback that implies a permanent behavior change, the agent:
1. Detects it
2. Asks: project-only or permanent?
3. If permanent: edits its prompt here in `agents/`, logs to `CHANGELOG.md`
4. All projects using the team get the update

See [shared/feedback-protocol.md](shared/feedback-protocol.md).

## Versioning

- Current version in [VERSION](VERSION)
- Every behavior change logged in [CHANGELOG.md](CHANGELOG.md)
- Major bumps when an agent's responsibilities meaningfully change
- Minor bumps for added behaviors
- Patch bumps for clarifications

## Using the Team in a New Project

```bash
./scripts/init-project.sh /path/to/new-project ProjectName
```

This:
- Creates project directory structure (wiki, pmo, api, server, web)
- Copies `templates/CLAUDE.md.template` → `CLAUDE.md`
- Copies `templates/KICKOFF.md.template` → `KICKOFF.md`
- Sets up `.claude/settings.json` with conversation logging hooks
- Symlinks `.claude/agents/*` → `dev-agent-team/agents/*`
- Initializes empty wiki, PMO dashboard, manifests
- Adds `conversations/` symlink to Google Drive sync folder

## Directory Layout

```
dev-agent-team/
├── README.md, CONVENTIONS.md, VERSION, CHANGELOG.md, index.md, log.md
├── agents/         # The 8 agent prompts (canonical)
├── shared/         # Protocols every agent inherits
├── templates/      # Files copied to each new project
├── scripts/        # init-project.sh, sync-agents.sh
└── feedback/       # Real-world feedback raw → applied
```

## Index

See [index.md](index.md) for the full catalog of agents and protocols.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for the evolution history.
