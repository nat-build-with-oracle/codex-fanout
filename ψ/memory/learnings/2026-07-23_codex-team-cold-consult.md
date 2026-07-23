---
pattern: When spawning infra via a peer oracle's specialty, ask the peer live before writing anything — stale docs and a busy peer's current knowledge will disagree, and the peer is usually right
date: 2026-07-23
source: "rrr: codex-fanout"
concepts: [maw-rs, codex-team, oracle-consult, maw-hey, reproducibility]
---

# Cold peer consult beats stale docs — and a "reproducible" doc isn't, until you check every dependency is actually reachable

## The pattern

A Sonnet-Low session with zero prior context needed to spawn a codex coder team. Instead of
trusting a half-read guidebook (`crew-master-oracle/CODEX-TEAM-GUIDEBOOK.md`), it sent a cold
`maw hey` to a peer oracle (`maw-rs`) that was mid-dispatch on unrelated work. The peer answered
between its own steps with the *current* charter contract — which directly contradicted the
guidebook (no `defaults.worktree` block; worktree-local `CODEX_HOME` via a setup script instead
of shared engine keys). The guidebook was stale; the peer, who'd hit the same pitfalls building
its own team days earlier, was current.

`maw hey` queuing against a busy peer worked exactly as advertised: no need to wait for idle,
no shared context required going in.

## The bug-report payoff

When a genuine tool bug surfaced (`maw team preflight`/`team up` stripping the `agents/` prefix
from the last member's worktree path), reporting it back to the peer — rather than silently
working around it — got it reproduced live on a second, independent charter and filed as a
tracked issue (maw-rs #658) with three documented workarounds, in less time than it took to keep
iterating on the fix alone.

## The gap that slipped through

After writing a detailed "how we did this" doc for the user's community, the doc referenced
`~/.claude/skills/oracle-team/codex-setup.ts` — a script that had never lived in any git repo,
only on the author's local machine. The doc was not actually reproducible by anyone else until
the user asked "and that skill too?" and it got vendored into the repo. The self-check "is every
dependency this doc cites actually reachable from where the doc will be read" should have been
part of finishing the doc, not a follow-up prompted externally.

## Apply this

- Before writing a charter/config/setup step from memory or docs, if a peer with recent hands-on
  experience on the same stack is reachable, ask first — even mid-task peers answer between steps.
- Treat a tool error naming a path that doesn't match your input (e.g. a prefix silently missing)
  as a plausible real bug worth escalating and reproducing, not just a cwd mistake to re-verify.
- Before calling any "how-to"/reproducibility doc done, explicitly list every script/config/binary
  it references and confirm each is reachable outside the author's own machine or session.
