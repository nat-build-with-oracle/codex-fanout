#!/usr/bin/env bun
// codex-setup.ts <pool-index> — prepare a WORKTREE-LOCAL CODEX_HOME, then exit.
// Does NOT launch omx — the engine command chains `&& omx` so omx runs directly
// in the pane shell and keeps its TTY (a forked omx loses the terminal → exit 1).
//
// Sets up $PWD/.codex inside the coder's worktree:
//   - auth.json symlinked from the shared pool (reuse credential)
//   - agents/AGENTS.md/skills/prompts symlinked (read-only config)
//   - hooks.json copied locally + trusted for that exact local path
//   - config.toml copied + forced reasoning_effort=xhigh
//   - own SQLite/locks created fresh by omx → no fleet-wide collision
//
// Usage (in a maw engine command, run from the coder's worktree):
//   bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts <pool-index> \
//     && CODEX_HOME=$PWD/.codex OMX_AUTO_UPDATE=0 omx --direct --madmax

import { homedir } from "os";
import { join } from "path";
import { createHash } from "crypto";
import { symlinkSync, mkdirSync, copyFileSync, existsSync, rmSync, readFileSync, writeFileSync } from "fs";

const poolIdx = process.argv[2];
if (!poolIdx) {
  console.error("usage: codex-setup.ts <pool-index>");
  process.exit(1);
}

const HOME = homedir();
const pool = join(HOME, ".codex-team", poolIdx);
const dst = join(process.cwd(), ".codex"); // worktree-local home — unique per coder

if (!existsSync(join(pool, "auth.json"))) {
  console.error(`✗ pool ${pool} missing auth.json`);
  process.exit(1);
}

mkdirSync(dst, { recursive: true });

function link(src: string, target: string) {
  if (!existsSync(src)) return;
  try { rmSync(target, { force: true, recursive: false }); } catch {}
  try { symlinkSync(src, target); } catch {}
}

const HOOK_EVENT_LABELS: Record<string, string> = {
  SessionStart: "session_start",
  PreToolUse: "pre_tool_use",
  PostToolUse: "post_tool_use",
  UserPromptSubmit: "user_prompt_submit",
  PreCompact: "pre_compact",
  PostCompact: "post_compact",
  Stop: "stop",
};

const HOOK_TRUST_START = "# OMX worktree-local Codex hook trust state (managed by codex-setup.ts)";
const HOOK_TRUST_END = "# End OMX worktree-local Codex hook trust state";

function isPlainObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function canonicalJson(value: unknown): unknown {
  if (Array.isArray(value)) return value.map((item) => canonicalJson(item));
  if (isPlainObject(value)) {
    return Object.fromEntries(
      Object.keys(value)
        .sort()
        .map((key) => [key, canonicalJson(value[key])]),
    );
  }
  return value;
}

function eventLabel(eventName: string): string {
  return HOOK_EVENT_LABELS[eventName] ?? eventName.replace(/([a-z0-9])([A-Z])/g, "$1_$2").toLowerCase();
}

function escapeTomlBasicString(value: string): string {
  return value.replace(/\\/g, "\\\\").replace(/"/g, '\\"');
}

function hookTrustedHash(eventName: string, entry: Record<string, unknown>, hook: Record<string, unknown>): string {
  const timeout = typeof hook.timeout === "number" ? Math.max(1, hook.timeout) : 600;
  const normalized = {
    event_name: eventLabel(eventName),
    ...(typeof entry.matcher === "string" && entry.matcher ? { matcher: entry.matcher } : {}),
    hooks: [
      {
        type: "command",
        command: hook.command,
        timeout,
        async: false,
        ...(typeof hook.statusMessage === "string" && hook.statusMessage ? { statusMessage: hook.statusMessage } : {}),
      },
    ],
  };
  return `sha256:${createHash("sha256").update(JSON.stringify(canonicalJson(normalized))).digest("hex")}`;
}

function buildHookTrustToml(hooksPath: string, hooksJson: string): string {
  const parsed = JSON.parse(hooksJson);
  if (!isPlainObject(parsed) || !isPlainObject(parsed.hooks)) return "";

  const lines: string[] = [];
  for (const eventName of Object.keys(parsed.hooks).sort()) {
    const groups = parsed.hooks[eventName];
    if (!Array.isArray(groups)) continue;

    groups.forEach((entry, groupIndex) => {
      if (!isPlainObject(entry) || !Array.isArray(entry.hooks)) return;
      entry.hooks.forEach((hook, handlerIndex) => {
        if (!isPlainObject(hook) || hook.type !== "command" || typeof hook.command !== "string") return;

        const key = `${hooksPath}:${eventLabel(eventName)}:${groupIndex}:${handlerIndex}`;
        lines.push(
          `[hooks.state."${escapeTomlBasicString(key)}"]`,
          `trusted_hash = "${escapeTomlBasicString(hookTrustedHash(eventName, entry, hook))}"`,
          "",
        );
      });
    });
  }
  return lines.join("\n").trimEnd();
}

function stripHookTrustTablesForPath(config: string, hooksPath: string): string {
  const prefix = `[hooks.state."${escapeTomlBasicString(hooksPath)}:`;
  const out: string[] = [];
  let skipping = false;
  for (const line of config.split("\n")) {
    if (/^\s*\[/.test(line)) {
      skipping = line.trimStart().startsWith(prefix);
    }
    if (!skipping) out.push(line);
  }
  return out.join("\n");
}

function replaceManagedHookTrustBlock(config: string, hooksPath: string, trustToml: string): string {
  let next = config;
  while (true) {
    const start = next.indexOf(HOOK_TRUST_START);
    if (start < 0) break;
    const end = next.indexOf(HOOK_TRUST_END, start);
    if (end < 0) break;
    const afterEnd = end + HOOK_TRUST_END.length;
    const removeStart = start > 0 && next[start - 1] === "\n" ? start - 1 : start;
    const removeEnd = next[afterEnd] === "\n" ? afterEnd + 1 : afterEnd;
      next = next.slice(0, removeStart) + next.slice(removeEnd);
  }
  next = stripHookTrustTablesForPath(next, hooksPath);

  const block = trustToml.trim()
    ? `${HOOK_TRUST_START}\n${trustToml.trim()}\n${HOOK_TRUST_END}\n`
    : "";
  return `${next.trimEnd()}\n\n${block}`;
}

// share credential + read-only config from pool (symlink, never write-locked).
link(join(pool, "auth.json"), join(dst, "auth.json"));
for (const f of ["agents", "AGENTS.md", "skills", "prompts"]) {
  link(join(pool, f), join(dst, f));
}

// hooks.json cannot be symlinked blindly. Codex 0.142.5 stores hook approval in
// config.toml under [hooks.state."<hooks.json path>:<event>:<group>:<handler>"]
// with a sha256 of the normalized command hook identity; it is not stored in the
// state sqlite DB. The source path is the worktree-local hooks.json path, not
// the symlink target, so a plain symlink/copy from ~/.codex makes Codex show the
// interactive "Hooks need review" screen at boot. Copy the hook file and preseed
// trust for this exact local path instead. Do not set bypass_hook_trust: we want
// reviewed hook identities, not a global trust bypass.
const hooksDst = join(dst, "hooks.json");
const hooksSrc = [join(HOME, ".codex", "hooks.json"), join(pool, "hooks.json")].find((path) => existsSync(path));
let hookTrustToml = "";
if (hooksSrc) {
  try {
    const hooksJson = readFileSync(hooksSrc, "utf8");
    hookTrustToml = buildHookTrustToml(hooksDst, hooksJson);
    if (hookTrustToml) {
      rmSync(hooksDst, { force: true });
      writeFileSync(hooksDst, hooksJson);
    } else {
      console.error(`⚠ hooks.json found at ${hooksSrc}, but no command hooks were trusted`);
    }
  } catch (err) {
    console.error(`⚠ failed to copy/trust hooks.json from ${hooksSrc}: ${err instanceof Error ? err.message : String(err)}`);
  }
}

// own settings (copy so reasoning_effort is independent + forced xhigh)
const cfgDst = join(dst, "config.toml");
if (!existsSync(cfgDst) && existsSync(join(pool, "config.toml"))) {
  copyFileSync(join(pool, "config.toml"), cfgDst);
}
if (existsSync(cfgDst) || hookTrustToml) {
  let cfg = existsSync(cfgDst) ? await Bun.file(cfgDst).text() : "";
  cfg = cfg.replace(/model_reasoning_effort = "(low|medium|high)"/g, 'model_reasoning_effort = "xhigh"');
  // suppress the unstable-features warning so the coder doesn't stall on a prompt
  if (!cfg.includes("suppress_unstable_features_warning")) {
    cfg += '\nsuppress_unstable_features_warning = true\n';
  }
  if (hookTrustToml) {
    cfg = replaceManagedHookTrustBlock(cfg, hooksDst, hookTrustToml);
  }
  await Bun.write(cfgDst, cfg);
}

console.error(`✓ CODEX_HOME ready: ${dst} (auth→pool/${poolIdx})`);
process.exit(0);
