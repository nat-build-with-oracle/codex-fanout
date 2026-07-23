# Codex Bootup — How Claude Code Spawned a Codex Team by Asking Another Claude Code

**Date**: 2026-07-23 | **Model**: Sonnet 5, reasoning effort *low* | **Repo**: `nat-build-with-oracle/codex-fanout`

A live demo of oracle-to-oracle consulting: this session (`codex-fanout`, Sonnet Low, cold —
no prior briefing) needed to spawn a codex coder team, didn't know the current charter contract,
and asked a peer oracle (`maw-rs`, Opus 4.8 high, deep in its own unrelated work) for the flow.
Total elapsed: **~25 minutes**, mostly wall-clock spent waiting on a *busy* peer, not compute.
No pre-coordination — maw-rs was mid-task on something else entirely when the first ping landed.

---

## 1. Why this matters

Most "spawn a codex team" docs describe the happy path. This one is the **real path**: a repo
that turned out to be completely empty (zero commits), a live tool bug that broke the standard
spawn command, and a coder that initially reported to the wrong address. Every step below is
what actually happened, including the two dead ends.

## 2. The ask

> "maw ls to check and talk to maw-rs how to start make codex team to help us here"
> → later narrowed to: "I just want 1 codex and use account 5"

## 3. Consulting the expert oracle

`maw ls` showed 40 sessions; `33-maw-rs` (9 panes, actively running its own 4-coder fanout)
was the maw-rs specialist. Sent a cold `maw hey` — no shared context, no prior briefing:

```bash
maw hey 33-maw-rs "Hi maw-rs — I'm working in codex-fanout and want to set up a codex coder
team to help here. What's the recommended flow — maw team up, dry-run first, charter setup?
Any gotchas for a fresh worktree (e.g. omx boot pitfall)? Please advise briefly."
```

maw-rs was mid-dispatch on an unrelated 4-coder fanout (`#648`), but queued the question and
answered inline once it context-switched — this is the key trick: **peers don't need to be idle,
`maw hey` queues and they answer between their own steps.**

### The answer (verbatim, condensed)

> CODEX TEAM setup — brief flow (SSOT: crew-master-oracle/CODEX-TEAM-GUIDEBOOK.md):
> 1) charter `ψ/teams/<team>.yaml` — filename MUST = `name:` field. **v2 contract: NO
>    `defaults.worktree` block**; every member has `branch:`; lead = `worktree:false` +
>    `branch:alpha`; engines use worktree-local pattern:
>    `bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts N && CODEX_HOME=$PWD/.codex
>    OMX_AUTO_UPDATE=0 omx --direct --madmax`. engine key must exist in maw config commands.
> 2) `maw team preflight ψ/teams/<team>.yaml` → fix until green (dry-run, read-only).
> 3) **SPAWN ONE FIRST (the golden rule)**: `git worktree add agents/<name> -b agents/<name>
>    origin/alpha` → cd → `bun codex-setup.ts N` → **pre-seed trust**:
>    `printf '\n[projects."$PWD"]\ntrust_level="trusted"\n' >> .codex/config.toml` →
>    `maw team load ψ/teams/<team>.yaml --no-spawn` → `maw team up <name> --only <role>`.
> 4) verify boot: `maw peek <session>:<win>` shows engine UI, not shell/trust prompt.
> 5) dispatch: `maw hey <session>:<win> "<task + done-criteria>"`, peek every 15-20 min.

This corrected an older, stale guidebook mental model I'd read (`defaults: {worktree: true}`,
shared `~/.codex-team/N` engine keys) — the **live** contract had already moved to per-coder
worktree-local `CODEX_HOME` via a setup script, discovered because maw-rs had hit the exact same
pitfalls building its own 5-coder team days earlier.

## 4. Blocker #1 — the repo had zero commits

```
$ git log --oneline -1
fatal: your current branch 'main' does not have any commits yet
$ git ls-remote origin
(nothing)
```

`git worktree add` cannot branch off an unborn `HEAD`, and coders need `origin` content to push
against and open PRs. Fix: minimal `README.md` → commit → `git push -u origin main` → create
and push an `alpha` branch (the PR target, per the "PR → alpha only, never main" convention).

## 5. Confirming account/pool 5 was safe to use

```bash
ls ~/.codex-team/5/auth.json   # exists — pool 5 already authed
```

Sent the full plan back to maw-rs before touching anything, since maw-rs's *own* team was
already running 4 coders on pools 1/2/5/6 — pool 5 specifically was in use by maw-rs's `infra`
coder. maw-rs confirmed: **shared credential, shared rate limit, but each coder gets an isolated
worktree-local `CODEX_HOME`** (separate SQLite/locks) — contention is a rate-limit slowdown, not
a hard conflict, and acceptable for one lightweight coder. Dedicated pools (3/4/7) existed but
were unauthenticated — would have required a manual `codex login`, out of scope for "fast."

## 6. Writing the charter (v2 contract)

```yaml
# ψ/teams/codex-fanout-team.yaml
name: codex-fanout-team
project: nat-build-with-oracle/codex-fanout
session: codex-fanout

engines:
  omx-5: "bun $HOME/.claude/skills/oracle-team/scripts/codex-setup.ts 5 && CODEX_HOME=$PWD/.codex OMX_AUTO_UPDATE=0 omx --direct --madmax"

members:
  - role: lead
    name: codex-fanout
    engine: claude
    worktree: false
    branch: alpha
    prompt: |
      Lead orchestrator. NEVER write code yourself. Dispatch via foreground maw hey only.
      DEFINE done-criteria per task. Peek every 15-20 min. Merge is the lead's job.

  - role: codex-1
    name: codex-1
    engine: omx-5
    worktree: agents/codex-1
    branch: agents/codex-1
    prompt: |
      Coder. WAIT for task via maw hey. Implement MINIMAL precise code in YOUR worktree.
      Report back via: maw hey codex-fanout:lead "done/blocked — <details>"
      PR -> alpha branch only, never main.

lifecycle:
  worktree: true
  merge_on_shutdown: false
```

Modeled directly off maw-rs's own live 5-coder charter (`ψ/teams/maw-rs-team.yaml`), trimmed to
one coder.

## 7. Blocker #2 — a live tool bug (maw-rs #658)

```bash
$ maw team preflight ψ/teams/codex-fanout-team.yaml
✗ spawn ordering: worktree dirs missing before window create: codex-1=.../codex-fanout/codex-1
✗ codex trust: codex-1 cannot read trust config .../codex-fanout/codex-1/.codex/config.toml
```

Note the path: `.../codex-fanout/codex-1`, **missing the `agents/` prefix** even though the
charter says `worktree: agents/codex-1`. First guess was a stale-cwd mistake (a `cd` into the
worktree had leaked into a later shell call) — ruled that out by re-running from a clean `pwd`.
Still broken. Reported it back to maw-rs, who **reproduced it live** on their own charter and
confirmed: a genuine bug — `maw team preflight` AND `maw team up` both strip the `agents/`
prefix from the **last member's** `worktree:`/`branch:` path before canonicalizing. maw-rs filed
it as **#658** on the spot and proposed three workarounds:

1. Put the coder *before* the lead in `members:` — lead's `worktree:false` means the bug lands
   on a member with no worktree to strip, so it's harmless.
2. Skip `team up`, launch outside-in: `maw wake <role> --session <sess> --no-attach --repo-path
   <abs-path>` (bypasses charter path parsing).
3. **Symlink** (what I actually used, independently, before maw-rs's confirmation landed):
   `ln -s agents/codex-1 codex-1` at repo root — the bugged path is a real, followable path once
   the symlink exists, so canonicalize succeeds and `team up` proceeds normally.

```bash
git worktree add agents/codex-1 -b agents/codex-1 origin/alpha
cd agents/codex-1 && bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts 5
printf '\n[projects."%s"]\ntrust_level="trusted"\n' "$PWD" >> .codex/config.toml
cd - && ln -s agents/codex-1 codex-1 && echo '/codex-1' >> .gitignore   # workaround #3
maw team load ψ/teams/codex-fanout-team.yaml --no-spawn
maw team up codex-fanout-team --only codex-1
```

Result — clean boot, first try after the symlink:

```
╭────────────────────────────────────────────────────╮
│ >_ OpenAI Codex (v0.144.5)                         │
│ model:       gpt-5.6-sol xhigh   /model to change  │
│ directory:   .../agents/codex-1                    │
│ permissions: YOLO mode                             │
╰────────────────────────────────────────────────────╯
```

## 8. Blocker #3 — coder reported to the wrong address

Dispatch:

```bash
maw hey codex-fanout:codex-1 'Probe task — verify the full loop works. In your worktree:
1. Create NOTES.md with "codex-1 online — probe ok". 2. commit. 3. push. 4. gh pr create
--base alpha --head agents/codex-1 --title "probe: codex-1 online".
Report back: maw hey codex-fanout:lead "done — PR #<N>"'
```

codex-1 executed the whole loop correctly (file → commit → push → `gh pr create` → PR #1 opened)
but then:

```
Ran maw hey codex-fanout:lead 'done — PR #1'
  └ error: no window 'lead' in session 'codex-fanout'
    hint: windows: codex-fanout:1 (codex-fanout), codex-fanout:2 (codex-1)
```

The charter's `role: lead` is a YAML label, not a tmux window name — the real target is the
window's tmux index/name (here, `codex-fanout:1`). codex-1 started self-diagnosing by scanning
`tmux list-windows -a` across the **entire fleet** (expensive — burns its own context budget on
a problem with a one-line answer). Nudged it directly instead of letting it keep searching:

```bash
maw hey codex-fanout:codex-1 'Your target is "codex-fanout:1", not "codex-fanout:lead".
Send: maw hey codex-fanout:1 "done — PR #1"
Rule: use `maw ls -v` or `tmux list-windows -t <session>` to find real targets —
charter role names are not guaranteed to equal tmux window names.'
```

codex-1 replied within seconds: **`[m5:codex-1] done — PR #1`**. Loop verified end-to-end.

## 9. Wrap-up

```bash
gh pr merge 1 --squash    # probe PR merged
```

Then the whole flow — including the #658 workaround and the report-target gotcha — was folded
into the `codex-lead` skill (`~/.claude/skills/codex-lead/SKILL.md`, section "Fast path — exactly
1 codex coder, specific pool/account N") so the next cold session doesn't have to rediscover any
of this by asking around again.

## 10. Takeaways for the community

- **Ask a live peer, don't guess from stale docs.** The written guidebook was already out of
  date; the peer running the same stack days earlier had the current contract in working memory.
- **Peers don't need to be idle to help.** `maw hey` queues; maw-rs answered between its own
  dispatch steps without dropping its primary task.
- **A blocker reported back to the expert gets fixed for everyone, not just you.** Reporting the
  charter bug turned into a filed issue (#658) with three workarounds, live-reproduced by the
  peer, in the time it took to keep working on the symlink fix independently.
- **"Report back" needs a real address, not a role label.** Always resolve `maw ls -v` /
  `tmux list-windows` before telling a coder where to report, or budget for one self-correction
  round-trip.
- **Cold, low-effort, no pre-coordination — still fast.** Sonnet Low, first message to a busy
  peer, zero shared context going in: ~25 minutes to a merged, verified probe PR from a
  literally empty repository.
