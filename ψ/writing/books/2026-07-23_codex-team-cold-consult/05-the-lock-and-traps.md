# บทที่ 5: The Lock และ Twelve Traps

บั๊กที่แพงที่สุดในระบบ distributed ไม่ใช่บั๊กที่ error ดัง ๆ แล้วล่มทั้งระบบ — บั๊กที่แพงที่สุดคือบั๊กที่ทำงาน "สำเร็จ" แต่สำเร็จผิดอย่าง เงียบสนิท ไม่มี log ไม่มี exception ไม่มีใครรู้จนกว่าจะสาย

เรื่องในบทนี้มาจาก session จริงของ crew-master-oracle ที่ codex-1 ตายซ้ำ ๆ ไม่ใช่ตายแบบ crash แต่ตายแบบ boot ขึ้นมาเป็น shell เปล่า ไม่มี task ไม่มี memory ไม่มี goal ระบบรายงานว่า fleet เขียว แต่ coder ไม่ได้ coding อะไรเลย นี่คือ symptom ที่อันตรายกว่า error เพราะไม่มีสัญญาณให้จับ

การไล่ root cause ใช้เวลาสามสมมติฐาน สองข้อแรกผิด ข้อที่สามถูก — และวิธีที่ทีมพิสูจน์แต่ละข้อคือบทเรียนที่สำคัญพอ ๆ กับตัวบั๊กเอง ต่อจากนั้นบทนี้จะสรุป Twelve Traps ที่ทีมเดียวกันเจอตลอด session และปิดท้ายด้วยการเปรียบเทียบกับบั๊ก #658 ที่เจอเองในภาค 2 ของหนังสือเล่มนี้ — pattern เดียวกัน คนละบริบท

---

## 5.1 อาการที่ไม่มี error

codex-1 บูตซ้ำแล้วซ้ำเล่า ทุกครั้งจบที่ shell เปล่า ไม่มี context ไม่มีอะไรให้ agent ทำงานต่อ จากภายนอกดูเหมือน initialization ค้างกลางทาง แต่ process ยังรันอยู่ — เทคนิคแล้วคือ "alive" แต่ใช้งานจริงไม่ได้เลย

fleet monitor รายงานสถานะปกติทุกอย่าง เขียวหมด แต่ coder ไม่ผลิตอะไรออกมา ระบบที่ดูสุขภาพดีในขณะที่ไม่ผลิตผลลัพธ์ ยากกว่าระบบที่ล่มชัดเจนเยอะ เพราะไม่มี stack trace ให้ตาม ไม่มี exit code ให้ grep

ทีมตั้งสมมติฐานสามข้อเรียงกัน แต่ละข้อฟังดูสมเหตุสมผล แต่ละข้อพิสูจน์ไม่ตรง มีแค่ข้อที่สามที่ยืนยันได้ด้วยเครื่องมือระดับ process — `lsof` กับ `ps eww`

## 5.2 กลไก และวิวัฒนาการของ fix

สมมติฐานแรกโทษ `reasoning_effort=low` — คิดว่า reasoning ต่ำทำให้ agent parse task state ไม่ออก แล้วก็ fallback ไป shell ปิด flag นี้แล้วอาการไม่หาย พิสูจน์แล้วว่าไม่ใช่จุดนี้

สมมติฐานที่สองโทษ token expiry — คิดว่า credential หมดอายุทำให้ auth ล้มเหลวแล้ว process ตกไป shell แทนที่จะ error ตรง ๆ แต่มี screenshot คัดค้านตรง ๆ: `omx` ใช้ credential pool เดียวกัน บูตปกติ ถ้า token หมดจริง `omx` บูตไม่ได้แน่ — screenshot นี้คือ falsifier ที่ปฏิเสธไม่ได้ บทเรียนตรงนี้ไม่ใช่ "เก็บข้อมูลให้มากก่อนตั้งสมมติฐาน" แต่คือหาทางพิสูจน์ว่าสมมติฐานตัวเองผิดทันทีที่ตั้งขึ้นมา

สมมติฐานที่สามต้องใช้เครื่องมือระดับ process จริง ๆ ทีมส่ง 5-agent workflow ไปรัน `lsof` ดู open file handle กับ `ps eww` ดู environment variable ทั้ง fleet ผลออกมาชัดเจน

```
$ ps eww | grep CODEX_HOME | grep -o 'CODEX_HOME=[^ ]*' | sort | uniq -c | sort -rn
     17 CODEX_HOME=/Users/nat/.codex-team/1
```

สิบเจ็ด process ชี้ไปที่ directory เดียวกัน — SQLite lock contention คือ root cause ตัวจริง

กลไกคือ Codex เก็บ state ใน SQLite แล้วล็อกไฟล์ด้วย PID lock ตอน startup พอมี process มากกว่าหนึ่งชี้ไปที่ `CODEX_HOME` เดียวกัน คนแรกที่ถึงล็อกได้ก็ยึดไว้ ที่เหลืออีกสิบหกคนรอจนหมดเวลาแล้วก็บูตต่อโดยไม่มี state — ไม่ error ไม่ crash แค่รันต่อแบบว่างเปล่า `waitForNonShell` เช็คแค่ว่า process ยังมีชีวิตอยู่ ไม่ได้เช็คว่ามันโหลด state สำเร็จหรือเปล่า presence ไม่เท่ากับ readiness — process ที่เริ่มแล้วไม่ได้แปลว่า process ที่พร้อมใช้งาน

fix ผ่านสองรอบ รอบแรกให้แต่ละ oracle มี `CODEX_HOME` แยกกัน แก้ contention ระหว่าง oracle คนละประเภทได้ แต่สอง instance ของ oracle เดียวกันยังชนกันอยู่ดี รอบสองถึงจะตรงจุด — ผูก `CODEX_HOME` เข้ากับ worktree ผ่าน `codex-setup.ts` แต่ละ worktree มี `.codex` ของตัวเอง ส่วน auth ยัง symlink มาจาก pool กลางได้เพราะ auth เป็น read-only ไม่ต้องล็อก แยกสิ่งที่แชร์ได้โดยธรรมชาติ ออกจากสิ่งที่ต้องแยกโดยสถาปัตยกรรม — สับสนสองอย่างนี้คือบาปต้นทาง

ทดสอบด้วย `maw-rs` รันห้า coder พร้อมกัน — ห้า SQLite file แยกกัน ล็อกไม่ชนกันเลยสักครั้ง บูตครบ state ครบทุกตัว

## 5.3 Twelve Traps สรุปย่อ

นอกจาก SQLite lock ที่เป็นพระเอกของบทนี้ session เดียวกันยังเจอกับดักอีกสิบเอ็ดจุด แต่ละจุดเป็นสิ่งที่ทีมที่ไม่เคยเจอมาก่อนจะเจ็บแน่นอน

**Charter engine block** — engine ที่ประกาศไว้ตอน spawn ไม่ถูกจดทะเบียนใน config runtime เลยข้ามขั้น charter ไปเงียบ ๆ coder ที่ออกมาไม่มี task boundary ไม่มี scope เลย fix คือลงทะเบียน engine ใน `~/.maw/config.toml` แล้วเช็คด้วย `maw engine list` ก่อน spawn ทุกครั้ง

**`maw team down --only` ฆ่าทุกคน** — flag ตั้งใจให้ terminate เฉพาะบางตัว แต่ parsing บั๊กทำให้ ignore selector ฆ่าทั้ง fleด flag ที่ไม่ทำงานอันตรายกว่า flag ที่ไม่มีอยู่ เพราะมันสร้างความมั่นใจปลอมว่าคำสั่งทำงานตามที่สั่ง

**SendMessage เงียบสำหรับ omx** — omx ไม่ได้ poll inbox ที่ `SendMessage` เขียนไป ข้อความหายไปเฉย ๆ โดยไม่มี ack ต้องใช้ `maw hey` แทนเสมอ

**False negative warning** — monitor เตือนว่า "may not have submitted" ทั้งที่ coder commit สำเร็จแล้วแค่ยังไม่ push ทำให้คนแทรกแซง coder ที่กำลังทำงานอยู่ กฎคือ peek ก่อนเชื่อ warning

**Auto-explore ใน `--madmax`** — coder ที่ยังไม่มี task เริ่ม explore repo เองก่อนได้รับ dispatch เผาโทเคนฟรี ต้องใส่ WAIT directive ใน charter prompt

**Generic `codex` ชน Claude Code** — เรียก `codex` แบบไม่ระบุ path ชัดเจน ระบบไปเจอ `.claude/` แล้ว resolve ผิดไปที่ Claude Code แทน ต้องระบุชื่อ engine แบบเจาะจง เช่น `omx-3` ไม่ใช่ `codex` เฉย ๆ

**`.codex`/`.claude` บล็อก worktree remove** — สองโฟลเดอร์นี้เป็น untracked โดยดีไซน์ `git worktree remove` เลยปฏิเสธลบถ้าไม่ force ทีม maw-rs วัดได้ fail rate ถึง 45% ตอน shutdown ทางแก้คือ `mv` ออกก่อนแล้วค่อย remove

**Swarm collision ที่ 67%** — dispatch โดยไม่มี atomic task-claiming ทำให้ coder หลายตัวเห็น task เดียวกันแล้วเริ่มทำพร้อมกัน วัดได้ collision rate ราว 67% ทางแก้คือ `UPDATE ... WHERE claimed_by IS NULL` แบบ test-and-set

**Stale worktree บล็อก spawn** — worktree เก่าที่ลบไม่หมดชนกับ path ใหม่ ต้อง treat cleanup เป็น idempotent startup logic ไม่ใช่แค่ teardown logic

**`reasoning_effort=low` ผลิตขยะในงาน planning** — ใช้ได้ดีกับงาน classify/route แต่ในงาน multi-step planning มันตัด reasoning chain สั้นเกินไป ได้ output ที่ syntax ผ่านแต่ semantic พัง

**Token spend ไม่แปรผันตรงกับคุณภาพ** — coder ที่ใช้โทเคนเยอะสุดในกลุ่ม (1.7M) กลับส่งงานช้าสุดและ revise เยอะสุด token volume เป็น cost metric ไม่ใช่ quality metric

**วินิจฉัย "token expired" โดยไม่ peek ก่อน** — ความเงียบของ coder ไม่เท่ากับ token หมดอายุเสมอไป อาจแค่กำลังรัน I/O หนักอยู่ การ restart โดยไม่ peek ทำให้เสียงาน checklist ที่ทำไปแล้วหลายสิบนาที

สามข้อสรุปที่ลอยขึ้นมาจากสิบสองกับดักนี้คือ — ความเงียบไม่ใช่ความล้มเหลว ต้อง peek ก่อนสรุปทุกครั้ง shared state ฆ่า parallelism ทุกครั้งที่มี resource แชร์กันโดยไม่ atomic และ default ที่ออกแบบมาสำหรับ agent เดี่ยวอันตรายเมื่อขยายเป็น fleet

## 5.4 เงาสะท้อนจาก #658

เรื่องทั้งหมดในบทนี้เกิดที่ crew-master-oracle คนละ session คนละทีม แต่ pattern เดียวกันนี้โผล่มาอีกครั้งใน session codex-fanout วันที่ 23 กรกฎาคม 2026 — คราวนี้ไม่ใช่ SQLite lock แต่เป็นบั๊กใน `maw team preflight` และ `maw team up` ที่ strip prefix `agents/` ออกจาก path ของ member ตัวสุดท้ายใน charter ก่อน canonicalize

อาการหน้าตาคุ้น ๆ — path ที่ควรจะเป็น `agents/codex-1` กลายเป็น `codex-1` เฉย ๆ ไม่มี error บอกตรง ๆ ว่า "prefix หาย" มีแค่ error ปลายทางที่บอกว่า worktree ไม่พบ กับ trust config อ่านไม่ได้ — เหมือนกับ codex-1 ที่บูตเป็น shell เปล่าตรงที่ทั้งคู่คือ silent failure ที่ต้องไล่ทีละสมมติฐานกว่าจะเจอต้นตอ

ทีมในบท 7 ก็ทำสิ่งเดียวกับที่บทนี้สอน — ไม่เชื่อสมมติฐานแรก (คิดว่าเป็น stale cwd ก่อน) รันซ้ำจาก clean state เพื่อ falsify แล้วพอยังไม่หาย ก็ escalate ไปหา peer ที่เขียนเครื่องมือตัวนั้นเอง จน reproduce ได้ live แล้วยืนยันเป็นบั๊กจริง — วิธีนี้ตรงกับสิ่งที่บทนี้ย้ำไว้ตลอด: อย่าเชื่อสมมติฐานแรก และเมื่อ instrumentation ในมือไม่พอ ให้ไปหาคนที่มี

ภาค 1 ของหนังสือเล่มนี้จบตรงนี้ — ห้าบทที่ผ่านมาคือบทเรียนที่พิสูจน์แล้วจาก crew-master-oracle การกำหนด boundary ของทีม การแบ่ง state ที่ต้องแยกจาก state ที่แชร์ได้ และวิธีอ่านความเงียบไม่ให้เข้าใจผิด ทั้งหมดนี้ไม่ใช่ทฤษฎี แต่เป็นแผนที่ที่เขียนจากรอยแผลจริง

ภาค 2 ตั้งแต่บทที่ 6 เป็นต้นไป จะพาไปดู session codex-fanout ตัวจริง — ทีมที่ประกอบขึ้นจาก lead หนึ่งตัวกับ coder หลายตัว เจอบั๊กใหม่ที่ไม่มีในสิบสองกับดักนี้ ต้อง cold-consult กับ peer เจ้าของเครื่องมือ และต้องตัดสินใจกลางทางว่าจะ workaround แบบไหนถึงจะไม่เสียเวลาไปมากกว่าที่ควร บทที่ 6 จะเริ่มจากการก่อร่างทีมตั้งแต่ศูนย์ ก่อนที่บทที่ 7 จะพาไปดู #658 แบบเต็ม ๆ ว่าทีมไล่ตามรอยยังไงจนเจอ fix จริง
