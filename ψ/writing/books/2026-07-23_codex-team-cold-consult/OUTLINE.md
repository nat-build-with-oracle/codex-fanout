# Codex Team ก่อร่างสร้างทีม — จาก Foundations ถึง Cold Consult

## Metadata

```yaml
title: "Codex Team ก่อร่างสร้างทีม"
subtitle: "จาก Foundations ถึง Cold Consult — บทเรียนจริงจากฟลีต maw-rs"
author: codex-fanout-oracle
date: 2026-07-23
language: Thai (kien-thai 7 frames)
register: technical-conversational
target_chapters: 10
target_words_per_chapter: 2500-3500
parts: 2
```

## Source Material (proof)

- `crew-master-oracle/CODEX-TEAM-GUIDEBOOK.md` — SSOT charter/dispatch/monitor contract
- `crew-master-oracle/ψ/writing/books/2026-06-18_art-of-team-formation-complete/*.md` — 13-chapter proven
  experiment log (solo/trio/swarm/tournament/thousand, the lock, the traps, federation wisdom,
  decision framework, quick reference) — **condensed/re-synthesized, not copied verbatim**
- `maw-rs/ψ/teams/maw-rs-team.yaml` — live 5-coder charter, role-based crate ownership
- `codex-fanout/CODEX-TEAM-BOOTUP.md` — this session's full narrative (cold consult, empty-repo
  blocker, maw-rs #658 bug live-reproduced, symlink workaround, report-target gotcha)
- `codex-fanout/ψ/memory/retrospectives/2026-07/23/19.22_codex-bootup-fanout.md` — this session's retro
- `codex-fanout/ψ/memory/learnings/2026-07-23_codex-team-cold-consult.md` — this session's lesson
- `codex-fanout/.claude/skills/codex-lead/SKILL.md` — the operational skill this session updated

## Structure

### ภาค 1: Foundations (จากประสบการณ์ที่พิสูจน์แล้วของ crew-master-oracle)

## บทที่ 1: ทำไมต้อง Codex Team
target_words: 2800
dna: "Multiply, don't grind" — เหตุผลที่ทีมชนะ solo agent เมื่องานขนานได้จริง
soul_thread: ต้นทุนของการรอ vs ต้นทุนของการประสาน
subtopics:
  - 1.1 ปัญหาที่ solo agent แก้ไม่ได้ (context, เวลา, ขอบเขต)
  - 1.2 Codex Team คืออะไร — lead + coder ในการแยก worktree
  - 1.3 บทเรียนจาก Round 3 collision event (crew-master-oracle proven case)
  - 1.4 ผู้ร่วมสร้างมาตรฐาน — ting, tee, maw-rs, transcriber
proof:
  - crew-master-oracle 01-what-is-crew-master.md (Round 3 reconstruction)
checklist:
  - [ ] อ้างอิง proven collision event จริง ไม่ fabricate ตัวเลข

## บทที่ 2: กายวิภาคของ Charter
target_words: 3000
dna: "Contract before code" — YAML ที่ผิดแม้แต่ field เดียวก็ทำให้ worktree ไปผิดที่
soul_thread: field ที่ดู optional แต่ mandatory จริง
subtopics:
  - 2.1 name / project / session — สามฟิลด์ที่พังทีมได้ถ้าหาย
  - 2.2 engine resolution — charter engines block ชนะ config เสมอ
  - 2.3 v1 vs v2 contract — defaults.worktree หายไปยังไง (จาก session จริงของเรา)
  - 2.4 lead vs coder — worktree:false คือสิ่งที่แยกสองบทบาท
proof:
  - crew-master-oracle 02-architecture.md
  - codex-fanout/ψ/teams/codex-fanout-team.yaml (charter จริงที่ใช้งาน)
checklist:
  - [ ] โชว์ charter จริงจาก session เปรียบเทียบกับ v1 guidebook

## บทที่ 3: การเดินทางของ Setup
target_words: 3000
dna: "Empty repo is not ready" — worktree ต้องการ commit ก่อนมันจะมีที่ยืน
soul_thread: การเตรียมที่มองไม่เห็นจนกว่าจะพัง
subtopics:
  - 3.1 Trust Prerequisite — ทำไม codex ค้างที่ prompt ถ้าไม่ pre-seed
  - 3.2 5-Phase Protocol (repo prep → verify → spawn one → probe → scale)
  - 3.3 บล็อกเกอร์จริง — repo ว่างเปล่า ไม่มี commit ไม่มี origin
  - 3.4 pool/account contention — บัญชีเดียวกัน ขีดจำกัดเดียวกัน
proof:
  - crew-master-oracle 03-setup-journey.md
  - codex-fanout/CODEX-TEAM-BOOTUP.md §4-5 (empty repo blocker, pool 5 confirm)
checklist:
  - [ ] ใช้ error message จริงจาก session (`your current branch main does not have any commits yet`)

## บทที่ 4: จาก Solo ถึง Thousand — สเกลที่พิสูจน์แล้ว
target_words: 3200
dna: "Each scale breaks differently" — bug ที่ solo ไม่เจอ จะโผล่ตอน swarm
soul_thread: ต้นทุนต่อ coder ที่ไม่ linear
subtopics:
  - 4.1 The Solo — null hypothesis ที่ไม่จริงอย่างที่คิด
  - 4.2 The Trio — token economics เริ่มมีความหมาย
  - 4.3 The Swarm — เมื่อ isolated worktree ยังไม่พอ
  - 4.4 The Tournament และ The Thousand — token efficiency inversion + throughput formula
proof:
  - crew-master-oracle 04-the-solo.md, 05-the-trio.md, 06-the-swarm.md, 07-the-tournament.md, 08-the-thousand.md
checklist:
  - [ ] ระบุชัดว่าตัวเลขมาจาก proven experiment ของ crew-master-oracle ไม่ใช่ของ session นี้

## บทที่ 5: The Lock และ Twelve Traps
target_words: 3000
dna: "Silent failure is the expensive one" — bug ที่ไม่ error แต่ทำงานผิด
soul_thread: กลไกที่มองไม่เห็นจนกว่าจะสาย
subtopics:
  - 5.1 The Symptom — team ค้างโดยไม่มี error
  - 5.2 The Mechanism และ Fix Evolution
  - 5.3 Twelve Traps สรุปย่อ (charter engine block, team down --only, ฯลฯ)
  - 5.4 การเปรียบเทียบกับ bug #658 ที่เราเจอเอง (foreshadow ภาค 2)
proof:
  - crew-master-oracle 09-the-lock.md, 10-the-traps.md
checklist:
  - [ ] เชื่อมโยงไปยัง #658 case study อย่างชัดเจนเป็นสะพานสู่ภาค 2

### ภาค 2: Cold Consult — Case Study จาก codex-fanout (2026-07-23)

## บทที่ 6: การถามผู้เชี่ยวชาญแบบเย็น
target_words: 3200
dna: "Ask before you guess" — peer ที่ยุ่งอยู่ก็ยังตอบได้ถ้าถามให้ถูก
soul_thread: ความมั่นใจปลอมจาก doc เก่า vs ความรู้จริงจาก peer ที่เพิ่งทำ
subtopics:
  - 6.1 บริบท — session ว่างเปล่า ต้องการ 1 coder บัญชี 5
  - 6.2 maw hey แบบ cold — ไม่มี context ร่วมกันมาก่อน
  - 6.3 คำตอบที่ขัดแย้งกับ guidebook เก่า (v2 contract จริง)
  - 6.4 Federation Wisdom — 45-minute tax, issue URL ไม่ใช่ number
proof:
  - codex-fanout/CODEX-TEAM-BOOTUP.md §3
  - crew-master-oracle 11-federation-wisdom.md
checklist:
  - [ ] อ้างข้อความจริงจาก maw-rs (คำตอบที่ส่งกลับมา)

## บทที่ 7: Blocker คู่แรก — Repo ว่างเปล่า และ Bug #658
target_words: 3500
dna: "Reproduce before you work around" — bug ที่ยืนยันด้วย peer คนที่สอง คือ bug จริง
soul_thread: ความสงสัยตัวเองก่อนสงสัยเครื่องมือ
subtopics:
  - 7.1 fatal: your current branch main does not have any commits yet
  - 7.2 preflight ล้มเหลว — canonicalize path ที่หาย agents/ prefix
  - 7.3 maw-rs reproduce สดบน charter ของตัวเอง → filed #658
  - 7.4 สามทางแก้ — reorder lead, outside-in repo-path, symlink
proof:
  - codex-fanout/CODEX-TEAM-BOOTUP.md §4, §7
  - maw-rs #658 (filed live, confirmed by maw-rs)
checklist:
  - [ ] โชว์ error message และ workaround จริงทั้งสาม พร้อมอันที่เลือกใช้

## บทที่ 8: Dispatch, Probe, และที่อยู่ที่ผิด
target_words: 3000
dna: "A role label is not an address" — charter role name ≠ tmux window
soul_thread: การสื่อสารที่พังเงียบๆ จนกว่าจะมีคน error กลับมา
subtopics:
  - 8.1 Probe task แรก — เขียนไฟล์ commit push PR
  - 8.2 codex-1 รายงานผิดที่ (`codex-fanout:lead` ไม่มีจริง)
  - 8.3 การแก้ที่ตรงจุด แทนปล่อยให้ coder scan ทั้งฟลีต
  - 8.4 PR #1 merged — ปิด loop
proof:
  - codex-fanout/CODEX-TEAM-BOOTUP.md §8
  - codex-fanout PR #1 (merged, nat-build-with-oracle/codex-fanout)
checklist:
  - [ ] อ้าง transcript จริงของ codex-1 ตอน error และตอนแก้ได้

## บทที่ 9: จาก Session สู่ Skill — สิ่งที่ทำให้คนถัดไปเร็วขึ้น
target_words: 3000
dna: "Document the workaround where the next cold session will look"
soul_thread: ความรู้ที่ไม่ถูกเขียนไว้ = ความรู้ที่หายไปพร้อม session
subtopics:
  - 9.1 อัปเดต codex-lead skill ด้วยของจริง ไม่ใช่ทฤษฎี
  - 9.2 Vendor oracle-team skill — dependency ที่ไม่เคยอยู่ใน git มาก่อน
  - 9.3 ทำไม private repo ถึงเท่ากับ "ไม่มีอะไรเลย" สำหรับ community
  - 9.4 Self-Audit — รู้ทันความมั่นใจเกินจริงของตัวเอง
proof:
  - codex-fanout/.claude/skills/codex-lead/SKILL.md (section 8, fast path)
  - codex-fanout/ψ/memory/retrospectives/2026-07/23/19.22_codex-bootup-fanout.md
checklist:
  - [ ] อ้าง AI Diary + Self-Audit section จริงจาก retro

## บทที่ 10: Decision Framework และ Quick Reference
target_words: 3000
dna: "Choose the smallest team that proves the pattern"
soul_thread: การตัดสินใจไม่ได้อยู่ที่ scale สูงสุด แต่อยู่ที่ scale ที่พอดี
subtopics:
  - 10.1 Scope/Size Branch — เมื่อไหร่ solo พอ เมื่อไหร่ต้อง trio/swarm
  - 10.2 Command Glossary ที่ใช้บ่อยที่สุด (preflight, up, hey, peek, down)
  - 10.3 Checklist ก่อน spawn จริง (รวมจากทั้งสองภาค)
  - 10.4 บทส่งท้าย — ทีมถัดไปควรเริ่มจากบทไหน
proof:
  - crew-master-oracle 12-decision-framework.md, 13-quick-reference.md
  - codex-fanout session ทั้งหมด (เป็นตัวอย่าง end-to-end)
checklist:
  - [ ] ปิดแบบ forward-looking ไม่ recap ซ้ำ
