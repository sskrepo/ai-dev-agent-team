#!/bin/bash
# Refresh .claude/agents/ symlinks in an existing project.
# Useful after dev-agent-team adds new agents or after a project was set up before some agents existed.
#
# Usage:
#   ./sync-agents.sh /path/to/project

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /path/to/project"
  exit 1
fi

PROJECT_DIR="$1"
TEAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "$PROJECT_DIR/.claude" ]; then
  echo "❌ $PROJECT_DIR doesn't look like a bootstrapped project (.claude/ missing)"
  exit 1
fi

mkdir -p "$PROJECT_DIR/.claude/agents"

echo "▶ Syncing agents from $TEAM_DIR/agents/ → $PROJECT_DIR/.claude/agents/"

for agent_file in "$TEAM_DIR"/agents/*.md; do
  agent_name=$(basename "$agent_file")
  ln -sf "$agent_file" "$PROJECT_DIR/.claude/agents/$agent_name"
  echo "  ✓ $agent_name"
done

# Remove symlinks pointing to deleted agents
for link in "$PROJECT_DIR"/.claude/agents/*.md; do
  [ -e "$link" ] || continue
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    rm "$link"
    echo "  ✗ removed broken symlink: $(basename "$link")"
  fi
done

echo "✅ Agents synced (team v$(cat "$TEAM_DIR/VERSION"))"
