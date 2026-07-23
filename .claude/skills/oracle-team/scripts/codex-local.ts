#!/usr/bin/env bun
// codex-local.ts <pool-index> — boot omx with a WORKTREE-LOCAL CODEX_HOME.
//
// WHY: ~/.codex-team/1-5 is shared fleet-wide → SQLite + PID lock contention
// (home/1 can have 17+ processes racing). A coder that loses the race can't
// boot → bare zsh → maw priming injects the prompt as shell commands.
//
// FIX: each coder gets its OWN CODEX_HOME inside its own worktree ($PWD/.codex).
// Worktrees are unique per coder, so SQLite/PID locks never collide. Auth is
// symlinked from a shared pool account so the 5 credentials are reused.
//
// Usage (maw engine command, run from inside the coder's worktree):
//   bun ~/.claude/skills/oracle-team/scripts/codex-local.ts <pool-index>
//
// Bun.$ chosen over bash: no `sed -i ''` (BSD) vs `sed -i` (GNU) quirk,
// cleaner symlink/copy, cross-platform.

import { $ } from "bun";
import { homedir } from "os";
import { join } from "path";

const poolIdx = process.argv[2];
if (!poolIdx) {
  console.error("usage: codex-local.ts <pool-index>");
  process.exit(1);
}

const HOME = homedir();
const pool = join(HOME, ".codex-team", poolIdx);
const dst = join(process.cwd(), ".codex"); // worktree-local home — unique per coder

if (!(await Bun.file(join(pool, "auth.json")).exists())) {
  console.error(`✗ pool ${pool} missing auth.json`);
  process.exit(1);
}

await $`mkdir -p ${dst}`.quiet();

// share credential + read-only config from pool (symlink, never write-locked)
await $`ln -sfn ${join(pool, "auth.json")} ${join(dst, "auth.json")}`.quiet();
for (const f of ["agents", "AGENTS.md", "skills", "prompts", "hooks.json"]) {
  const src = join(pool, f);
  if (await Bun.file(src).exists().catch(() => false) || (await $`test -e ${src}`.quiet().then(() => true).catch(() => false))) {
    await $`ln -sfn ${src} ${join(dst, f)}`.quiet().catch(() => {});
  }
}

// own settings (copy so reasoning_effort is independent + forced xhigh)
const cfgDst = join(dst, "config.toml");
if (!(await Bun.file(cfgDst).exists())) {
  await $`cp ${join(pool, "config.toml")} ${cfgDst}`.quiet().catch(() => {});
}
if (await Bun.file(cfgDst).exists()) {
  const cfg = await Bun.file(cfgDst).text();
  await Bun.write(cfgDst, cfg.replace(/model_reasoning_effort = "low"/g, 'model_reasoning_effort = "xhigh"'));
}

// own SQLite/locks/sessions are created fresh by omx inside $DST → no collision

// hand off to omx with the pane's TTY (stdio inherit — NOT Bun.$ which pipes
// and starves omx of a terminal, causing 'stdin is not a terminal' → exit 1)
const proc = Bun.spawn(["omx", "--direct", "--madmax"], {
  stdio: ["inherit", "inherit", "inherit"],
  env: { ...process.env, CODEX_HOME: dst, OMX_AUTO_UPDATE: "0" },
});
process.exit(await proc.exited);
