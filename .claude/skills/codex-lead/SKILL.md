---
name: codex-lead
description: "Spawn + lead a codex coder team end-to-end — author/upgrade the charter, maw team up (with dry-run), heal the fresh-worktree omx boot pitfall, dispatch via maw hey with done-criteria, run the 15-20min peek loop, and ride the maw zai token-rotation pool. Use when the user says 'set up a codex team', 'spawn coders', 'add codex N', 'lead the team', 'dispatch to coders', or wants the lead/dispatch/peek workflow (not just spawning — see ting's /codex-fleet for spawn/arrange/heal mechanics)."
argument-hint: "up [N] | dispatch <task> | peek | scale N | down"
---

# /codex-lead — Spawn & Lead a Codex Team

Proven on volt-codex2 (2026-06-24): lead=claude + N omx coders in isolated worktrees,
token rotation through the `maw zai` pool. This skill is the **lead's operating loop**.
For pure spawn/arrange/heal mechanics see ting's `~/.claude/skills/codex-fleet/SKILL.md`.

> Golden rules: **dispatch ONLY via `maw hey` (foreground)**, NEVER `maw team send`/SendMessage
> on omx (silent no-op — that's a claude-only file inbox). The lead **reviews + merges, never
> writes code**. Define done-criteria up front; peek on a cadence; no-gap dispatch.

## 1. Charter — `ψ/teams/<team>.yaml` (proven schema)

Required: `name`, `project` (MANDATORY — without it worktrees land wrong), `defaults: {worktree: true}`,
`members` (each: `role`, `name`, `engine`, `branch`, `prompt`). Lead `engine: claude, worktree: false,
name: <tmux window>`. Coders `engine: omx, branch: agents/<team>-coder-N`, prompt = WAIT-for-task +
own-the-loop + report-to-lead contract. Copy a known-good charter (e.g. `volt-codex2.yaml`).

## 2. Spawn

```bash
maw team up <team> --dry-run     # preview: live=skip, missing=would wake
maw team up <team>               # spawn — wakes only missing members
```

## 3. ⚠️ Heal the boot pitfall (RECURRING — hit by ting + volt)

A fresh worktree has no `.envrc` → `OMX_AUTO_UPDATE=0` doesn't take → omx self-updates →
drops to a **shell** (`❯`) or a codex **update menu** instead of the omx prompt, and the
standing contract is LOST (sent to the shell, not omx). **Always peek after spawn.**
Use maw verbs only — raw `tmux send-keys` is safety-hook blocked.

| peek shows | heal |
|---|---|
| empty shell `❯` | `maw run <sess>:coder-N "OMX_AUTO_UPDATE=0 omx"` |
| codex update menu (1.Update / 3.Skip…) | `maw send-text <sess>:coder-N "3"` |
| text stuck in composer | `maw send-enter <sess>:coder-N` |

After omx is up, **re-send the contract**: `maw hey <sess>:coder-N "<coder prompt>"`, then peek
that `Context …% left` dropped below 100% (= ingested). Clean boots show context already used.

## 4. Dispatch discipline

```bash
maw hey <sess>:coder-N "<task + explicit done-criteria>"   # foreground; reaches omx (delivers + submits)
```
- "may not have submitted / still shows pending input" = **FALSE NEGATIVE**. Confirm with `maw peek`;
  only `maw send-enter` if the peek shows your text actually sitting unsent.
- One precise minimal task per coder. State done-criteria (tests pass / build green / behavior verified).

## 5. Peek loop — don't go dark

1. Dispatch with clear done-criteria.
2. Every **~15–20 min**: `maw peek <sess>:coder-N` each coder — who's working / idle / stalled.
3. Stalled → nudge with the **exact blocker**, not "how's it going".
4. Done → review + merge + **NO-GAP DISPATCH** (next task in the same confirm message).
5. Keep a task queue so the next dispatch fires instantly.
   Quick views: `maw team status <team>`, `maw activity`.

## 6. Token rotation — `maw zai` pool

omx coders route through the `maw zai` gateway. `fill_first` drains key #1, auto-overflows to the
next on 429/quota — **that overflow IS the rotation; no extra setup.** Just monitor:
```bash
maw zai status   # chain + active key      maw zai mon   # live refresh      maw zai test   # probe all keys
```
Per-coder key-pinning (true parallel, no shared drain) is advanced maw-zai config — fill_first is
enough for rate-limit protection; tune later.

## 7. Scale / teardown

- Scale: append coder-N blocks to the charter → `maw team up <team>` again (wakes only the new).
- Teardown: `maw team down <team>` (worktrees clean up; `--clean` also deletes merged branches).

## Anti-patterns (from the retros)

- **Charter-before-verification breaks teams** — verify every charter task against live code
  (`ls`/`grep`) before finalizing, or coders block on their first task.
- **Account/token change → full lead-cycle pause** (not just stop new picks).
- **omx fails to start** → `maw team up <team> --only coder-N` relaunch.

## 8. Fast path — exactly 1 codex coder, specific pool/account N

Proven end-to-end on `codex-fanout` (2026-07-23): empty repo → spawn → probe PR → merge, in one sitting.

```bash
# 0. Repo must have a first commit + origin content BEFORE any worktree/spawn.
#    (worktree add fails on an unborn HEAD; coders need origin to push/PR against.)
git log --oneline -1 || { git add README.md && git commit -m "Initial commit" && git push -u origin main; }
git checkout -b alpha && git push -u origin alpha && git checkout main   # PR target

# 1. Charter — v2 contract (verified live, NOT the old defaults.worktree:true schema):
#    - NO defaults.worktree block
#    - every member declares its own worktree: and branch:
#    - lead: worktree:false, branch:alpha
#    - engine command is worktree-local, inline under `engines:`, using codex-setup.ts <N>
#      (N = pool/account index, e.g. 5) — NOT the shared engine keys (codex-t1..t6), which
#      point at ~/.codex-team/<N> directly and skip the worktree-local CODEX_HOME isolation.
mkdir -p ψ/teams
cat > ψ/teams/<team>.yaml <<'YAML'
name: <team>
project: <org>/<repo>
session: <tmux-session>
engines:
  omx-N: "bun $HOME/.claude/skills/oracle-team/scripts/codex-setup.ts N && CODEX_HOME=$PWD/.codex OMX_AUTO_UPDATE=0 omx --direct --madmax"
members:
  - role: codex-1        # coder listed BEFORE lead — see #658 workaround below
    name: codex-1
    engine: omx-N
    worktree: agents/codex-1
    branch: agents/codex-1
    prompt: |
      Coder. WAIT for task via maw hey. Implement minimal precise code in YOUR worktree.
      Report back via: maw hey <session>:<lead-window-index> "done/blocked — <details>"
      PR -> alpha only, never main.
  - role: lead
    name: <lead-window-name>
    engine: claude
    worktree: false
    branch: alpha
lifecycle:
  worktree: true
  merge_on_shutdown: false
YAML

# 2. Manual worktree + trust pre-seed BEFORE team up (SPAWN ONE FIRST — the golden rule):
git worktree add agents/codex-1 -b agents/codex-1 origin/alpha
(cd agents/codex-1 && bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts N \
  && printf "\n[projects.\"$PWD\"]\ntrust_level=\"trusted\"\n" >> .codex/config.toml)

# 3. Load + spawn
maw team load ψ/teams/<team>.yaml --no-spawn
maw team up <team> --only codex-1
maw peek <session>:codex-1     # must show the omx/Codex engine UI, not a shell or trust prompt
```

### ⚠️ Known bug: maw-rs #658 — last-member `agents/` prefix gets stripped

`maw team preflight` AND `maw team up` both fail to canonicalize the **last member's**
`worktree:`/`branch:` path — they strip the `agents/` prefix and look for `<repo>/<role>`
instead of `<repo>/agents/<role>`, erroring `canonicalize <repo>/<role> failed: No such file`.
Three known workarounds (until #658 ships):
1. **Put the coder BEFORE lead in `members:`** — lead has `worktree:false` so the bug lands on
   lead harmlessly (no worktree path to strip).
2. **Symlink workaround**: `ln -s agents/<role> <role>` at repo root, then add `/<role>` to
   `.gitignore` so it never gets committed. Works even with the coder last in the list.
3. **Skip `team up` entirely**: `maw wake <role> --session <sess> --no-attach --repo-path <abs-path-to-worktree>`
   (bypasses the charter-path parsing altogether).

### ⚠️ Report-back target is the tmux window, NOT the charter role name

The coder's prompt should say "report via `maw hey <session>:<lead>`" — but `<lead>` must be
the **actual tmux window index or name** (check with `maw ls -v` or `tmux list-windows -t <session>`),
which is often just the session's window **1**, not the string `"lead"` from the charter. A
coder that tries the wrong target self-corrects by running `tmux list-windows`, but that burns
its own context — give it the real target up front to save a round-trip.

### Pool/account contention

Pools (`~/.codex-team/<N>`) are shared **credential** slots across every codex team on the
machine, even though `codex-setup.ts` gives each coder a worktree-local `CODEX_HOME` (isolated
state/locks). Two coders on the same pool N share that account's rate limit. Check who else is
on a pool before picking it: ask in the fleet (`maw hey <peer-session> "who's on pool N?"`) or
just try it — contention only bites as a rate-limit slowdown, not a hard conflict.
