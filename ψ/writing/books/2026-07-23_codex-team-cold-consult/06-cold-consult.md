# บทที่ 6: การถามผู้เชี่ยวชาญแบบเย็น

ภาค 1 ปิดท้ายด้วยการสังเคราะห์บทเรียนจาก crew-master-oracle — ทฤษฎีที่กลั่นมาจากทีมจริงหลายทีม จนถึงจุดนี้ผู้อ่านน่าจะรู้แล้วว่า "ควรทำอะไร" แต่บทนี้เปลี่ยนโหมด จากทฤษฎีไปเป็น case study สดๆ ตัวเดียว บันทึกแบบ timestamp-level จาก session จริงชื่อ `codex-fanout` วันที่ 23 กรกฎาคม 2026

Session นี้เริ่มต้นแบบเปล่าเปลือกที่สุดเท่าที่จะเป็นไปได้ — Claude Sonnet ตัวหนึ่ง รัน reasoning effort ระดับ low ไม่มี briefing มาก่อน ไม่มี context เกี่ยวกับ codex team ในหัวเลยแม้แต่น้อย งานที่ได้รับคือประโยคสั้นๆ จาก Nat: "maw ls to check and talk to maw-rs how to start make codex team to help us here" แล้วตามด้วยการเจาะจงให้แคบลง — "I just want 1 codex and use account 5"

โจทย์ตรงนี้คือปัญหาคลาสสิกที่ทุก orchestrator เจอ — ต้อง spawn ทีมโดยไม่รู้ contract ปัจจุบันของระบบ ทางเลือกมีสองทาง หนึ่งคือเปิด guidebook เก่าแล้วเดาไปตามนั้น สองคือถามคนที่เพิ่งทำงานแบบเดียวกันมาสดๆ บทนี้จะเล่าว่าทางที่สองพาไปถึงไหน และทำไมทางแรกถึงเกือบทำให้ทีมพังตั้งแต่ยังไม่ทันเริ่ม

## 6.1 บริบท — session ว่างเปล่า ต้องการ 1 coder บัญชี 5

ก่อนพิมพ์คำสั่งแรก session `codex-fanout` ไม่มีอะไรเลย repo ว่าง ไม่มี context งานเก่า ไม่มีแม้แต่ commit สักตัว (เรื่องนี้จะเป็นปัญหาจริงในบทที่ 7) สิ่งเดียวที่มีคือคำสั่งของ Nat กับ session name

โจทย์แคบลงเรื่อยๆ จาก "make codex team" กว้างๆ กลายเป็นตัวเลขชัด — coder ตัวเดียว ใช้บัญชี (pool) หมายเลข 5 นี่คือจุดสำคัญที่ทำให้ปัญหาไม่ใหญ่เกินจัดการ เพราะถ้าตั้งเป้าหมาย 5 coder ตั้งแต่แรก ความเสี่ยงจะพุ่งขึ้นตามจำนวน แต่ตัวเดียวหมายความว่า ถ้าอะไรพัง cause-space ก็มีแค่หนึ่งจุด — หลักการเดียวกับที่ TING-ORACLE เรียนรู้มาด้วยราคา 45 นาที (รายละเอียดใน 6.4)

คำถามที่เหลืออยู่คือ "แล้วจะเริ่มยังไง" — charter เขียนแบบไหน engine key ต้องตั้งชื่ออะไร มี pitfall อะไรซ่อนอยู่บ้างสำหรับ fresh worktree ตรงนี้แหละที่ session ตัดสินใจไม่เดา แต่ไปถามคนที่รู้จริง

## 6.2 maw hey แบบ cold — ไม่มี context ร่วมกันมาก่อน, maw-rs กำลังยุ่งอยู่กับงานอื่น

`maw ls` แสดง session ทั้งหมด 40 ตัวในเฟลีต ในนั้นมี `33-maw-rs` — 9 pane กำลังรัน 4-coder fanout ของตัวเองอยู่ นี่คือ oracle ที่รู้เรื่อง codex team contract ล่าสุดจริงๆ เพราะเพิ่งสร้างทีม 5-coder ของตัวเองมาไม่กี่วันก่อนหน้า

ไม่มีการทักทายอุ่นเครื่อง ไม่มี pre-coordination มาก่อนเลย ข้อความแรกที่ส่งไปคือ

```bash
maw hey 33-maw-rs "Hi maw-rs — I'm working in codex-fanout and want to set up a codex coder
team to help here. What's the recommended flow — maw team up, dry-run first, charter setup?
Any gotchas for a fresh worktree (e.g. omx boot pitfall)? Please advise briefly."
```

จุดที่ต้องขีดเส้นใต้คือ maw-rs ไม่ได้ว่างตอนนั้น กำลัง mid-dispatch อยู่กับ fanout ของตัวเองที่มี issue ผูกอยู่ (`#648`) — แต่ `maw hey` ไม่ใช่การโทรแบบ synchronous ที่ต้องรอคนรับสายว่าง ข้อความถูก queue ไว้ แล้ว maw-rs ก็ตอบกลับมาระหว่างที่สลับ context ไปมาระหว่าง step งานของตัวเอง

นี่คือกลไกที่ทำให้ cold consult ใช้ได้จริงในทางปฏิบัติ peer ไม่ต้องว่างถึงจะช่วยได้ — แค่คำถามต้องเจาะจงพอที่จะตอบสั้นๆ ได้โดยไม่ต้องหยุดงานตัวเองทั้งกระบวน

## 6.3 คำตอบที่ขัดแย้งกับ guidebook เก่า

คำตอบของ maw-rs กลับมาแบบย่อ อ้างอิง SSOT ที่ `crew-master-oracle/CODEX-TEAM-GUIDEBOOK.md` แต่เนื้อหาจริงกลับขัดกับสิ่งที่ session คิดว่ารู้อยู่แล้ว

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

ประโยคที่สำคัญที่สุดในคำตอบนี้คือ "**v2 contract: NO `defaults.worktree` block**" — session อ่าน guidebook มาก่อนหน้านี้ (mental model เก่า) แล้วคิดว่า charter ต้องมี `defaults: {worktree: true}` แบบ block กลาง กับ engine key ที่ใช้ path แชร์กันแบบ `~/.codex-team/N` แต่นั่นคือ contract เวอร์ชันเก่า ที่ตายไปแล้วจริงๆ ในระบบปัจจุบัน

contract จริง — v2 — ทุก member ต้องมี `branch:` ของตัวเอง ไม่มี default กลางให้พึ่งพา ส่วน `CODEX_HOME` ก็ไม่ใช่ path แชร์อีกต่อไป แต่เป็น worktree-local — ตั้งใหม่ทุกครั้งตาม `$PWD` ของ worktree นั้นๆ ผ่าน `codex-setup.ts` ก่อนบูต engine

ทำไม maw-rs ถึงรู้เรื่องนี้แม่นขนาดนี้ — เพราะ maw-rs ไม่ได้อ่านมาจาก doc แต่ **เพิ่งชนปัญหาเดียวกันมาด้วยตัวเองเมื่อไม่กี่วันก่อน** ตอนสร้างทีม 5-coder ของตัวเอง contract v2 ไม่ได้อยู่ในหนังสือคู่มือที่ update ทัน แต่อยู่ใน working memory ของ peer ที่เพิ่งใช้งานจริง

ตรงนี้คือ soul thread ของบทนี้ — ความมั่นใจปลอมจาก doc เก่ากับความรู้จริงจาก peer ที่เพิ่งทำ ถ้า session เดินหน้าไปเขียน charter ตาม mental model เก่าโดยไม่ถามใครก่อน `maw team preflight` คงพังตั้งแต่ต้น เพราะ charter จะอ้างอิง `defaults.worktree` ที่ไม่มีอยู่จริงในระบบแล้ว

## 6.4 Federation Wisdom ที่เกี่ยวข้อง

สิ่งที่เกิดขึ้นใน 6.2 กับ 6.3 ไม่ใช่เรื่องบังเอิญ แต่ตรงกับบทเรียนสองข้อที่ federation สรุปไว้แล้วจากทีมอื่นๆ ที่เคยพังมาก่อน

ข้อแรก คือ **45-minute tax** ของ TING-ORACLE — ทีมที่รัน 7 coder พร้อมกันตั้งแต่ต้น โดยยังไม่ทดสอบ loop สักตัวเดียว ผลคือเมื่อ coder ตัวแรกไม่ได้รับ task การ diagnose กลายเป็นฝันร้าย เพราะมี 6 coder อื่นรันคู่ขนานอยู่ ทำให้ cause-space ขยายจากหนึ่งจุดเป็นหลายจุดพร้อมกัน เสียเวลาไป 45 นาทีเต็ม บทสรุปของ TING-ORACLE คือประโยคเดียว — "Spawn ONE first, prove the loop, then scale" — ซึ่งตรงกับที่ maw-rs พูดคำต่อคำในข้อ 3 ของคำตอบข้างบนว่า "SPAWN ONE FIRST (the golden rule)" เพราะ session นี้ตั้งเป้าไว้แค่ coder เดียวตั้งแต่แรก โจทย์เลยไม่มีทางชนกับดักข้อนี้ได้เลย แต่ก็เป็นเหตุผลว่าทำไม "1 codex บัญชี 5" ถึงเป็นขอบเขตที่ถูกต้องตั้งแต่คำสั่งแรกของ Nat

ข้อสอง คือกฎเรื่อง **issue URL ไม่ใช่ number** — TING-ORACLE เจอปัญหานี้ตอน coder หนึ่งตัวทำงานข้ามหลาย repo แล้ว dispatch task ด้วย `#42` เฉยๆ เลข 42 ชนกันได้ทุก repo แต่ URL ไม่มีทางชนเพราะพก anchor ของ repo มาด้วยในตัว บทเรียนนี้โผล่มาอีกครั้งใน blocker #2 ของ case study นี้เอง — ตอนที่ maw-rs filed bug ใหม่เป็น **#658** แทนที่จะบอกแค่เลข ตัวเลขนั้นถูกอ้างอิงในบริบทที่ระบุ repo ชัดเจน (crew-master-oracle) ไม่ใช่เลขลอยๆ ที่ session อื่นจะงงว่าหมายถึง repo ไหน

สองบทเรียนนี้ไม่ได้มาจากทฤษฎี แต่มาจาก incident log จริงที่มี timestamp — เขียนไว้ในบทที่ 11 ของหนังสือ "Art of Team Formation" ก่อนหน้านี้แล้ว จุดที่น่าสนใจคือ case study บทนี้ไม่ได้อ่านบทนั้นมาก่อนตอนทำงานจริง แต่ยังคง align กับหลักการเดียวกัน — เพราะหลักการพวกนี้ไม่ใช่ dogma ลอยๆ แต่มาจากข้อจำกัดเชิงโครงสร้างของการ diagnose ปัญหาแบบขนาน ยิ่งจำนวนตัวแปรเยอะ ยิ่ง diagnose ยาก ไม่ว่าใครจะเจอปัญหานี้ที่ไหนก็ตาม

## ปิดท้าย

ถึงจุดนี้ session ยังไม่ได้แตะโค้ดสักบรรทัด ยังไม่ได้เขียน charter สักตัว สิ่งที่ทำไปมีแค่การถามคำถามหนึ่งข้อ กับการได้คำตอบที่แก้ mental model ผิดๆ ก่อนที่มันจะทำให้ preflight พังตั้งแต่รอบแรก นี่คือ dna ของบทนี้ — ask before you guess ถามก่อนเดา แม้ peer จะยุ่งแค่ไหน ถ้าคำถามเจาะจงพอ คำตอบก็มาได้เร็วพอที่จะคุ้มเวลาที่เสียไปกับการรอ

แต่การได้ contract ที่ถูกต้องไม่ได้แปลว่าทางข้างหน้าจะโล่ง ตรงกันข้าม — บทที่ 7 จะพาไปเจอ blocker คู่แรกของ session นี้จริงๆ เริ่มจากสิ่งที่ไม่มีใครคาดคิดว่าจะเป็นปัญหา — repo ที่ไม่มี commit สักตัวเดียว แล้วต่อด้วยบั๊กจริงในเครื่องมือเองที่ maw-rs ต้อง reproduce สดๆ เพื่อยืนยันว่าไม่ใช่ความผิดพลาดของฝ่ายไหนเลย แต่เป็นบั๊กที่ทุกทีมที่ใช้ charter v2 มีสิทธิ์เจอเหมือนกันหมด
