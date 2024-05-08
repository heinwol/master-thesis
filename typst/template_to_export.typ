#let theorem(cnt) = [*Теорема:* #cnt]
#let proposition(cnt) = [*Предложение:* #cnt]
#let proof(cnt) = [*Доказательство:* #cnt]
#let definition(cnt) = [*Определение:* #cnt]
#let lemma(cnt) = [*Лемма:* #cnt]
#let corollary(cnt) = [*Следствие:* #cnt]
#let remark(cnt) = [*Замечание:* #cnt]

#let thmrules(it) = it

#let code(..args) = [..args]

#let with(func: function, ..k, content: content) = {
  set func(..k)
  content
}

// #show terms: it => {
//   for item in it.children {
//     definition(item.term, item.description)
//   }
// }

#let template(body) = {
  // set document(author: "dds", title: "ds")

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
  set par(
    leading: 1.25em,
    justify: true,
    first-line-indent: 1.25em,
    // hanging-indent: 1.25em,
  )

  // block spacing
  // set block(spacing: 3.65em,)

  // Additionally styling for list.
  set enum(indent: 0.5cm)
  set list(indent: 0.5cm)

  set heading(numbering: "1.1.")
  show heading: set align(center)
  show heading: it => {it; v(1em)}
  show heading.where(level: 1): it => { pagebreak(); it }
  show heading.where(level: 3): set heading(numbering: none, outlined: false)

  // set math.equation(
  //   numbering: num =>
  //   "(" + ((counter(heading).get().at(0),) + (num,)).map(str).join(".") + ")"
  // )
  // set math.equation(supplement: none)
  // show math.cases: set align(left)


  // show figure.caption: set text(size: 0.8em)
  // show figure.caption: set par(leading: 1em)

  // show figure.where(kind: 1): ""

  // set figure(supplement: "рис.")

  // see https://github.com/typst/typst/issues/311#issuecomment-1722331318
  // show regex("^!!"): context h(par.leading)

  show <nonum>: set heading(numbering: none)
  show <nonum>: set math.equation(numbering: none)

  body
}
