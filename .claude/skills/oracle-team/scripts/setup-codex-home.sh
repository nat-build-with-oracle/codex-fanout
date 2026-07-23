#!/usr/bin/env bash
# setup-codex-home.sh — give each oracle its OWN CODEX_HOME so codex coders
# don't collide on the shared ~/.codex-team/ pool (SQLite + PID lock contention).
#
# WHY: ~/.codex-team/1-5 is shared fleet-wide. With 6+ oracles each spawning
# coders, home/1 can have 17+ processes racing for the same SQLite databases
# (goals/logs/memories/state) and daemon.lock. The losers can't boot → bare
# zsh shell → maw team up primes the prompt into the shell → garbage.
#
# FIX: per-oracle CODEX_HOME. Each instance gets its own SQLite/locks (created
# fresh on boot), but SHARES the credential (auth.json symlink) and read-only
# config (agents/skills/prompts symlink). config.toml is copied so reasoning
# effort stays independent.
#
# Usage: setup-codex-home.sh <oracle-name> [N]
#   oracle-name: e.g. maw-rs, crew-master, ting
#   N: number of homes (default 5)
#
# Idempotent — safe to run before every spawn.

set -euo pipefail

ORACLE="${1:?usage: setup-codex-home.sh <oracle-name> [N]}"
N="${2:-5}"
POOL="$HOME/.codex-team"        # shared credential pool
DEST="$HOME/.codex-$ORACLE"     # this oracle's private homes

# read-only config to symlink (shared, never write-locked)
SYMLINK_ITEMS=(auth.json agents AGENTS.md skills prompts hooks.json)
# settings to copy (so each oracle owns its reasoning_effort etc)
COPY_ITEMS=(config.toml version.json installation_id models_cache.json)

for i in $(seq 1 "$N"); do
  src="$POOL/$i"
  dst="$DEST/$i"
  [ -d "$src" ] || { echo "⚠ skip $i: $src missing"; continue; }
  mkdir -p "$dst"

  for item in "${SYMLINK_ITEMS[@]}"; do
    [ -e "$src/$item" ] && ln -sfn "$src/$item" "$dst/$item"
  done
  for item in "${COPY_ITEMS[@]}"; do
    [ -e "$src/$item" ] && [ ! -e "$dst/$item" ] && cp "$src/$item" "$dst/$item"
  done

  # enforce xhigh reasoning (codex needs it to parse charter prompts correctly)
  if [ -f "$dst/config.toml" ]; then
    sed -i '' 's/model_reasoning_effort = "low"/model_reasoning_effort = "xhigh"/' "$dst/config.toml" 2>/dev/null || \
    sed -i 's/model_reasoning_effort = "low"/model_reasoning_effort = "xhigh"/' "$dst/config.toml" 2>/dev/null || true
  fi

  echo "✓ $dst (auth→pool/$i, own sqlite/locks)"
done

echo ""
echo "Engine commands for charter engines: block —"
for i in $(seq 1 "$N"); do
  echo "  omx-$i: \"OMX_AUTO_UPDATE=0 CODEX_HOME=\$HOME/.codex-$ORACLE/$i omx --direct --madmax\""
done
