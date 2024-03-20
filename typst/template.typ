#import "./typst-packages/packages/preview/ctheorems/1.1.2/lib.typ": *

#let theorem = thmbox(
  "theorem",
  "Теорема",
  fill: rgb("#eeffee"),
  supplement: none,
  //
)
#let proof = thmproof("proof", "Доказательство")
#let definition = thmbox(
  "definition",
  "Определение",
  base_level: 1, // take only the first level from the base
  stroke: rgb("#68ff68") + 1pt,
  // fill: rgb("#eeffee"),
  supplement: none,
  inset: (top: 0.4em, left: 1em, right: 0em, bottom: 0.2em),
  padding: (top: 0em, bottom: 0em),
  // separator: none, //[#h(0.1em):#h(0.2em)],
)

#let template(body) = {
  set document(author: "dds", title: "ds")

  // Set the basic text properties.
  set text(
    font: "Liberation Serif",
    lang: "ru",
    size: 12pt,
    // fallback: true,
    // hyphenate: false,
  )

  // Set the basic page properties.
  set page(
    paper: "a4",
    number-align: center,
    margin: (top: 10mm, bottom: 10mm, left: 30mm, right: 10mm),
    numbering: "1",
    // footer: rect(fill: aqua)[Footer],
  )
  counter(page).update(2)

  // Set the basic paragraph properties.
  set par(leading: 1.25em, justify: true, first-line-indent: 1.25em)

  // block spacing
  // set block(spacing: 3.65em,)

  // Additionally styling for list.
  set enum(indent: 0.5cm)
  set list(indent: 0.5cm)

  // Global show rules for links:
  //  - Show links to websites in blue
  //  - Underline links to websites
  //  - Show other links as-is
  // show link: it => if type(it.dest) == str {
  // set text(fill: ugent-blue)
  //   underline(it)
  // } else {
  //   it
  // }

  set heading(numbering: "1.1.")

  body
}
