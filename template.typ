// 《深入理解 Claude Code 源码》Typst 模板
// 浅色简约风格，专业中文排版

#set document(
  title: "深入理解 Claude Code 源码",
  author: ("Sawyer Zhang", "Claude Opus 4.6"),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2cm),
  header: context {
    if counter(page).get().first() > 2 {
      set text(size: 9pt, fill: rgb("#999"))
      [深入理解 Claude Code 源码]
      h(1fr)
      counter(page).display()
    }
  },
)

#set text(
  font: ("Source Han Sans SC", "PingFang SC", "Noto Sans CJK SC", "Heiti SC"),
  size: 10.5pt,
  lang: "zh",
)

#set par(
  leading: 0.9em,
  first-line-indent: 0em,
  justify: true,
)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(2em)
  set text(size: 22pt, weight: "bold", fill: rgb("#1a1a2e"))
  block(below: 1em)[
    #it.body
    #v(0.3em)
    #line(length: 100%, stroke: 2pt + rgb("#d4a373"))
  ]
}

#show heading.where(level: 2): it => {
  v(1.5em)
  set text(size: 16pt, weight: "bold", fill: rgb("#2d3436"))
  block(below: 0.8em)[
    #it.body
    #v(0.2em)
    #line(length: 100%, stroke: 0.5pt + rgb("#e0e0e0"))
  ]
}

#show heading.where(level: 3): it => {
  v(1em)
  set text(size: 13pt, weight: "bold", fill: rgb("#636e72"))
  block(below: 0.5em, it.body)
}

#show heading.where(level: 4): it => {
  v(0.8em)
  set text(size: 11pt, weight: "bold", fill: rgb("#636e72"))
  block(below: 0.4em, it.body)
}

// 代码块样式
#show raw.where(block: true): it => {
  set text(font: ("Menlo", "Source Code Pro", "Consolas"), size: 9pt)
  block(
    fill: rgb("#f8f8f8"),
    stroke: 0.5pt + rgb("#e0e0e0"),
    radius: 4pt,
    inset: (x: 12pt, y: 10pt),
    width: 100%,
    it,
  )
}

// 内联代码
#show raw.where(block: false): it => {
  set text(font: ("Menlo", "Source Code Pro"), size: 9.5pt, fill: rgb("#e17055"))
  box(
    fill: rgb("#f5f0eb"),
    radius: 2pt,
    inset: (x: 3pt, y: 1pt),
    it,
  )
}

// 引用块
#show quote: it => {
  block(
    fill: rgb("#faf8f5"),
    stroke: (left: 3pt + rgb("#d4a373")),
    radius: (right: 4pt),
    inset: (x: 14pt, y: 10pt),
    width: 100%,
  )[
    #set text(style: "italic", fill: rgb("#555"))
    #it.body
  ]
}

// 表格样式
#set table(
  stroke: 0.5pt + rgb("#e0e0e0"),
  inset: 8pt,
)
#show table.cell.where(y: 0): set text(weight: "bold")

// 链接颜色
#show link: set text(fill: rgb("#6c5ce7"))

// Pandoc 兼容定义
#let horizontalrule = line(length: 100%, stroke: 0.5pt + rgb("#ccc"))

// ====== 封面 ======
#page(header: none, margin: (top: 0cm, bottom: 0cm, left: 0cm, right: 0cm))[
  #block(
    width: 100%,
    height: 100%,
    fill: rgb("#fafafa"),
  )[
    #v(8cm)
    #align(center)[
      #block(width: 80%)[
        #text(size: 36pt, weight: "bold", fill: rgb("#1a1a2e"))[
          深入理解 Claude Code 源码
        ]
        #v(1cm)
        #line(length: 40%, stroke: 2pt + rgb("#d4a373"))
        #v(1cm)
        #text(size: 14pt, fill: rgb("#636e72"))[
          系统剖析 Anthropic Claude Code CLI 的架构设计、工程实践与编程哲学
        ]
        #v(3cm)
        #text(size: 12pt, fill: rgb("#999"))[
          Sawyer Zhang & Claude Opus 4.6
        ]
        #v(0.5cm)
        #text(size: 11pt, fill: rgb("#bbb"))[
          2026 年 4 月
        ]
        #v(2cm)
        #text(size: 9pt, fill: rgb("#ccc"))[
          25 章 · 101 个 Mermaid 图表 · 467 个代码块 · ~12 万字
        ]
      ]
    ]
  ]
]
