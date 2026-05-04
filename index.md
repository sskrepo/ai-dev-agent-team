# Dev Agent Team — Index

Catalog of all pages in this team.

## Meta
- [README.md](README.md) — what this team is, how to use it
- [CONVENTIONS.md](CONVENTIONS.md) — file formats, wiki pattern, versioning
- [VERSION](VERSION) — current team version
- [CHANGELOG.md](CHANGELOG.md) — every behavior change with reason
- [log.md](log.md) — chronological session log

## Agents

- [product-manager](agents/product-manager.md) — user stories, acceptance criteria, MVP scope
- [architect](agents/architect.md) — API contracts, data model, ADRs, tech decisions
- [ux-designer](agents/ux-designer.md) — wireframes, user flows, component specs
- [tpm](agents/tpm.md) — cross-phase tracking, dashboard, decision queue
- [dev-manager](agents/dev-manager.md) — engineering execution, task breakdown
- [backend-dev](agents/backend-dev.md) — API impl, DB, business logic, integrations
- [frontend-dev](agents/frontend-dev.md) — web UI, design system implementation
- [qa-engineer](agents/qa-engineer.md) — API contract tests, E2E, UAT

## Shared Protocols

- [wiki-protocol](shared/wiki-protocol.md) — how to read/write the wiki
- [decision-protocol](shared/decision-protocol.md) — how to escalate decisions
- [handoff-protocol](shared/handoff-protocol.md) — how to hand work to next agent
- [status-update-protocol](shared/status-update-protocol.md) — how to update the dashboard
- [feedback-protocol](shared/feedback-protocol.md) — self-improvement loop
- [escalation-rules](shared/escalation-rules.md) — when to bug user vs. proceed
- [phase-kickoff-brief](shared/phase-kickoff-brief.md) — mandatory brief at start of every phase listing external deps user must handle
- [phase-deliverables-protocol](shared/phase-deliverables-protocol.md) — two mandatory approval gates per phase (Gate 1: PDD + UI Mocks; Gate 2: OpenAPI spec). Dev Manager blocked until both gates pass.

## Templates (copied to new projects)

- [CLAUDE.md.template](templates/CLAUDE.md.template) — project-level rules
- [KICKOFF.md.template](templates/KICKOFF.md.template) — day-one instructions
- [settings.json.template](templates/.claude/settings.json.template) — hook config
- [log-user.sh, log-assistant.sh](templates/.claude/scripts/) — logging hooks
- [pmo/](templates/pmo/) — dashboard, phases, story/decision/handoff templates

## Scripts

- [init-project.sh](scripts/init-project.sh) — bootstrap a new project
- [sync-agents.sh](scripts/sync-agents.sh) — refresh symlinks in an existing project

## Feedback (raw → applied)

- [feedback/pending.md](feedback/pending.md) — feedback awaiting compilation
- [feedback/applied.md](feedback/applied.md) — feedback folded into agents
