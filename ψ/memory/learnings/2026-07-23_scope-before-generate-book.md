---
pattern: Before running a "write N chapters" pipeline on thin source material, check whether comparable material already exists elsewhere before padding or duplicating
date: 2026-07-23
source: "rrr: codex-fanout"
concepts: [oracle-write-complete-book, scope-check, source-material, licensing-assumption]
---

# Scope-check before generate — and verify permission the same way you'd verify a suspected bug

## The pattern

Invoked `/oracle-write-complete-book` on material from a single session. The skill defaults to
10-20 chapters / 200+ pages — mechanically following that default would have meant padding a
one-session story with fabricated "general wisdom" chapters, which fails the skill's own
proof-every-claim rule. Instead of proceeding, asked the user via `AskUserQuestion` whether to
scope down, pull in more real material, or proceed anyway accepting fabrication risk. User chose
to pull in more material — which led to actually mining sibling oracle vaults
(`maw-rs-oracle`, `crew-master-oracle`) rather than assuming the session transcript was the only
available source.

That mining turned up something unexpected: `crew-master-oracle` already had a **complete,
proven, 13-chapter book on the identical topic** ("The Art of Team Formation"). At that point
the honest move was a second question, not a silent decision — write a new book on the same
topic risks either duplicating existing work or looking derivative. The user chose synthesis
(condense the proven material as Part 1, add the new session as Part 2, cite throughout, copy
nothing verbatim).

## The gap not caught in time

What didn't get checked: whether crew-master-oracle's existing book carried any explicit
license or attribution expectation before treating it as safe source material to synthesize
from. The assumption was "sibling org, same human owner, AI-authored — implicitly fine." That
assumption was never verified against an actual license file or stated terms. It probably was
fine in this case (condensed + cited, not copied), but the *reasoning process* was the same
shortcut flagged in an earlier session's retro for the opposite case (assuming a tool error was
user-caused instead of a real bug) — resolving uncertainty toward "keep moving" instead of
toward "verify first."

## Apply this

- When a generation pipeline has a default scale (N chapters, X agents, Y pages), treat that
  default as a question to answer from real material, not a target to hit regardless of source
  depth.
- Before writing on a topic, search sibling repos/vaults for existing complete work on the same
  subject — not just the current session's material — and surface it to the human rather than
  silently duplicating or silently declining.
- Treat "can I use this as source material" (license, attribution) with the same discipline as
  "is this actually a bug" — both are places where assuming the convenient answer and continuing
  is faster but not verified; check before committing to the assumption, especially before
  publishing anything derived from it externally.
