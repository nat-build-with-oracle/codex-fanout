// Font — document-wide before cover. Pinned explicitly (pandoc emits no #set text font).
#set text(font: "Laksaman", size: 12pt, lang: "th")

// --- Cover page ---
#set page(paper: "a4", margin: 0cm, fill: rgb("#0a0e1a"))
#place(top, rect(width: 100%, height: 6pt, fill: gradient.linear(rgb("#3498db"), rgb("#1a1a2e"), rgb("#3498db"))))
#v(1fr)
#align(center, text(size: 9pt, fill: rgb("#3498db"), weight: "bold", tracking: 4pt)[CASE STUDY EDITION])
#v(1.5em)
#align(center, text(size: 60pt)[🛰️])
#v(1.5em)
#align(center, text(size: 30pt, weight: "bold", fill: white)[CODEX TEAM])
#v(0.2em)
#align(center, text(size: 30pt, weight: "bold", fill: rgb("#3498db"))[ก่อร่างสร้างทีม])
#v(1.2em)
#align(center, text(size: 13pt, fill: rgb("#8899aa"))[จาก Foundations ถึง Cold Consult])
#align(center, text(size: 11pt, fill: rgb("#6677aa"))[บทเรียนจริงจากฟลีต maw-rs])
#v(2em)
#align(center)[
  #box(stroke: 1pt + rgb("#3498db40"), radius: 14pt, inset: (x: 10pt, y: 5pt), text(size: 8pt, fill: rgb("#3498db"))[10 Chapters])
  #h(8pt)
  #box(stroke: 1pt + rgb("#3498db40"), radius: 14pt, inset: (x: 10pt, y: 5pt), text(size: 8pt, fill: rgb("#3498db"))[2 Parts])
  #h(8pt)
  #box(stroke: 1pt + rgb("#3498db40"), radius: 14pt, inset: (x: 10pt, y: 5pt), text(size: 8pt, fill: rgb("#3498db"))[1 Real Bug Filed])
]
#v(1em)
#align(center)[
  #box(stroke: 1pt + rgb("#3498db40"), radius: 14pt, inset: (x: 10pt, y: 5pt), text(size: 8pt, fill: rgb("#3498db"))[Foundations + Case Study])
  #h(8pt)
  #box(stroke: 1pt + rgb("#3498db40"), radius: 14pt, inset: (x: 10pt, y: 5pt), text(size: 8pt, fill: rgb("#3498db"))[maw-rs #658])
]
#v(1fr)
#align(center, text(size: 11pt, weight: "bold", fill: rgb("#3498db"))[codex-fanout-oracle (AI) — from Nat])
#v(0.3em)
#align(center, text(size: 9pt, fill: rgb("#556677"))[2026-07-23 · nat-build-with-oracle])
#v(2em)
#place(bottom, rect(width: 100%, height: 6pt, fill: gradient.linear(rgb("#3498db"), rgb("#1a1a2e"), rgb("#3498db"))))

// --- Content pages ---
#set page(numbering: "1", margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 3cm), fill: white)
#counter(page).update(1)
#pagebreak()

#set heading(numbering: none)
#set par(leading: 1.6em, justify: false, first-line-indent: 0em)
#set block(spacing: 2.5em)

// L1 = chapter heading, page break before
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(2em)
  line(length: 100%, stroke: 2pt + rgb("#3498db"))
  v(0.8em)
  set text(size: 22pt, weight: "bold", fill: rgb("#1a1a2e"))
  it
  v(1em)
}

// L2 = section heading
#show heading.where(level: 2): it => {
  v(1em)
  set text(size: 15pt, weight: "bold", fill: rgb("#2c3e50"))
  it
  v(0.5em)
}

// L3 = subsection heading
#show heading.where(level: 3): it => {
  v(0.8em)
  set text(size: 12.5pt, weight: "bold", fill: rgb("#34495e"))
  it
  v(0.4em)
}

// Code blocks — Fira Code mono + background
#show raw.where(block: true): it => {
  set text(font: "Fira Code", size: 9pt)
  block(fill: rgb("#f6f8fa"), stroke: 0.5pt + luma(200),
    inset: 14pt, radius: 4pt, width: 100%, it)
}

// Inline code — subtle grey background + charcoal
#show raw.where(block: false): it => {
  box(fill: rgb("#f0f0f0"), inset: (x: 3pt, y: 1.5pt), radius: 2pt,
    text(font: "Fira Code", size: 9pt, fill: rgb("#36454f"), it))
}

// Bold — dark navy
#show strong: it => {
  text(weight: "bold", fill: rgb("#1a1a2e"), it)
}

// Blockquotes — blue left border + light blue background
#show quote.where(block: true): it => {
  block(fill: rgb("#f0f4f8"), stroke: (left: 3pt + rgb("#3498db")),
    inset: (left: 16pt, right: 12pt, top: 10pt, bottom: 10pt),
    radius: (right: 4pt), it)
}

// Tables — dark header + zebra stripes
#set table(
  stroke: 0.5pt + luma(180),
  fill: (_, row) => if row == 0 { rgb("#2c3e50") }
    else if calc.odd(row) { rgb("#f8f9fa") } else { white },
)
#show table.cell: it => {
  set text(size: 10pt); set align(left)
  if it.y == 0 { set text(fill: white, weight: "bold"); it } else { it }
}

// TOC — depth 1 only
#outline(title: "สารบัญ", depth: 1)
#pagebreak()
