#!/usr/bin/env bash
# codex-local.sh <pool-index> — boot omx with a WORKTREE-LOCAL CODEX_HOME.
#
# WHY: ~/.codex-team/1-5 is shared fleet-wide → SQLite + PID lock contention
# (home/1 can have 17+ processes racing). A coder that loses the race can't
# boot → bare zsh shell → maw priming injects the prompt as shell commands.
#
# FIX: each coder gets its OWN CODEX_HOME inside its own worktree ($PWD/.codex).
# Worktrees are unique per coder by construction, so the SQLite databases and
# PID locks never collide — not with other coders, not with other oracles.
# Auth is symlinked from a shared pool account so we reuse the 5 credentials.
#
# Usage (as a maw engine command, run from inside the coder's worktree):
#   bash ~/.claude/skills/oracle-team/scripts/codex-local.sh <pool-index>
#
# Each coder maps to a distinct pool index (1-5) to spread token load.

set -euo pipefail

POOL_IDX="${1:?usage: codex-local.sh <pool-index>}"
POOL="$HOME/.codex-team/$POOL_IDX"
DST="$PWD/.codex"   # worktree-local home — unique per coder

[ -d "$POOL" ] || { echo "✗ pool $POOL missing"; exit 1; }

mkdir -p "$DST"

# share credential + read-only config from the pool (symlink, never write-locked)
ln -sfn "$POOL/auth.json" "$DST/auth.json"
for f in agents AGENTS.md skills prompts hooks.json; do
  [ -e "$POOL/$f" ] && ln -sfn "$POOL/$f" "$DST/$f"
done

# own settings (copy so reasoning_effort is independent + forced xhigh)
[ -f "$DST/config.toml" ] || cp "$POOL/config.toml" "$DST/config.toml" 2>/dev/null || true
if [ -f "$DST/config.toml" ]; then
  sed -i '' 's/model_reasoning_effort = "low"/model_reasoning_effort = "xhigh"/' "$DST/config.toml" 2>/dev/null || \
  sed -i    's/model_reasoning_effort = "low"/model_reasoning_effort = "xhigh"/' "$DST/config.toml" 2>/dev/null || true
fi

# own SQLite/locks/sessions are created fresh by omx inside $DST → no collision
export CODEX_HOME="$DST"
export OMX_AUTO_UPDATE=0
exec omx --direct --madmax
