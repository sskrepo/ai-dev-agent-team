#!/bin/bash
# Bootstrap a new project with the dev-agent-team.
#
# Usage:
#   ./init-project.sh /path/to/project ProjectName
#
# Creates:
#   - Project directory structure
#   - .claude/agents/ symlinks → dev-agent-team/agents/
#   - .claude/settings.json with conversation logging hooks
#   - .claude/scripts/log-*.sh
#   - conversations/ symlink → ~/Google Drive/AI Projects/Claude/Conversations/{ProjectName}/
#   - CLAUDE.md, KICKOFF.md from templates
#   - Empty docs/wiki/, pmo/, manifests/, api/, server/, web/

set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 /path/to/project ProjectName"
  exit 1
fi

PROJECT_DIR="$1"
PROJECT_NAME="$2"
TEAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GDRIVE_BASE="$HOME/Google Drive/AI Projects/Claude/Conversations"
GDRIVE_PROJECT="$GDRIVE_BASE/$PROJECT_NAME"
DATE=$(date +%Y-%m-%d)

echo "▶ Bootstrapping $PROJECT_NAME at $PROJECT_DIR"
echo "  Team: $TEAM_DIR"
echo "  Logs: $GDRIVE_PROJECT"

# 1. Create directory structure
mkdir -p "$PROJECT_DIR"/{.claude/scripts,docs/raw,docs/wiki,docs/wiki/ux,docs/wiki/engineering,docs/wiki/adr,docs/wiki/integrations,pmo/stories,pmo/decisions,pmo/handoffs,pmo/uat,pmo/bugs,manifests,api,server,web}
mkdir -p "$GDRIVE_PROJECT"

# 2. Symlink agents
mkdir -p "$PROJECT_DIR/.claude/agents"
for agent in product-manager architect ux-designer tpm dev-manager backend-dev frontend-dev qa-engineer; do
  ln -sf "$TEAM_DIR/agents/$agent.md" "$PROJECT_DIR/.claude/agents/$agent.md"
done

# 3. Conversation log symlink + hook scripts
ln -sf "$GDRIVE_PROJECT" "$PROJECT_DIR/conversations"
cp "$TEAM_DIR/templates/.claude/scripts/log-user.sh" "$PROJECT_DIR/.claude/scripts/log-user.sh"
cp "$TEAM_DIR/templates/.claude/scripts/log-assistant.sh" "$PROJECT_DIR/.claude/scripts/log-assistant.sh"
echo "$PROJECT_NAME" > "$PROJECT_DIR/.claude/scripts/.project-name"
chmod +x "$PROJECT_DIR/.claude/scripts/"*.sh
cp "$TEAM_DIR/templates/.claude/settings.json.template" "$PROJECT_DIR/.claude/settings.json"

# 4. Templates with substitution
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$TEAM_DIR/templates/CLAUDE.md.template" > "$PROJECT_DIR/CLAUDE.md"
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$TEAM_DIR/templates/KICKOFF.md.template" > "$PROJECT_DIR/KICKOFF.md"
cp "$TEAM_DIR/templates/.gitignore.template" "$PROJECT_DIR/.gitignore"
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g; s/{{DATE}}/$DATE/g" "$TEAM_DIR/templates/pmo/dashboard.md.template" > "$PROJECT_DIR/pmo/dashboard.md"
sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$TEAM_DIR/templates/pmo/phases.md.template" > "$PROJECT_DIR/pmo/phases.md"
cp "$TEAM_DIR/templates/pmo/stories/README.md" "$PROJECT_DIR/pmo/stories/README.md"
cp "$TEAM_DIR/templates/pmo/decisions/README.md" "$PROJECT_DIR/pmo/decisions/README.md"
cp "$TEAM_DIR/templates/pmo/handoffs/README.md" "$PROJECT_DIR/pmo/handoffs/README.md"

# 5. Manifests + empty wiki seed
cat > "$PROJECT_DIR/manifests/raw_sources.csv" <<EOF
filename,kind,registered_at,notes
EOF

cat > "$PROJECT_DIR/docs/wiki/index.md" <<EOF
# $PROJECT_NAME — Wiki Index

## Meta
- [current-status](current-status.md)
- [log](log.md)

## Compiled by PM
(empty — PM will populate after raw ingest)

## Compiled by Architect
(empty)

## Compiled by UX
(empty)

## Compiled by Dev Manager
(empty)
EOF

cat > "$PROJECT_DIR/docs/wiki/log.md" <<EOF
# $PROJECT_NAME — Session Log

Append-only. Format: \`## [YYYY-MM-DD] agent | what changed\`

---

## [$DATE] init | Project bootstrapped from dev-agent-team v$(cat "$TEAM_DIR/VERSION")
EOF

cat > "$PROJECT_DIR/docs/wiki/current-status.md" <<EOF
---
title: Current Status
source: derived from pmo/dashboard.md
compiled_at: ${DATE}T00:00:00Z
created: $DATE
owner: tpm
tags: [meta]
status: current
---

# Current Status

## Where we are
Project just bootstrapped. Awaiting initial requirement ingest by PM.

## Active stories
(none yet)

## Awaiting user decision
(none yet)

## Recent decisions
(none yet)

## Next milestones
- PM ingests raw requirements from \`docs/raw/\`
- PM proposes MVP scope (DECISION-001)
- Architect drafts initial ADRs (tech stack)
EOF

# 6. API spec stub
cat > "$PROJECT_DIR/api/openapi.yaml" <<EOF
openapi: 3.0.3
info:
  title: $PROJECT_NAME API
  version: 0.1.0
  description: API for $PROJECT_NAME. Source of truth for all API definitions.
servers:
  - url: http://localhost:3000
    description: Local dev
paths: {}
components:
  schemas: {}
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
EOF

touch "$PROJECT_DIR/server/.gitkeep"
touch "$PROJECT_DIR/web/.gitkeep"

echo "✅ Project bootstrapped."
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  cat KICKOFF.md"
echo ""
echo "Optional: git init && git add . && git commit -m 'Bootstrap from dev-agent-team v$(cat "$TEAM_DIR/VERSION")'"
