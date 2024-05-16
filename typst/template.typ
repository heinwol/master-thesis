#import "./typst-packages/packages/preview/ctheorems/1.1.2/lib.typ": *
#import "@preview/sourcerer:0.2.1": code as code_

#let indent = 1.25cm

#let code(..args) = code_(..args)

#let thmbox = thmbox.with(
  inset: (top: 0.2em, left: 0em, right: 0em, bottom: 0.2em),
  padding: (top: 0em, bottom: 0em),
)
#let thmplain = thmplain.with(
  inset: (top: 0.2em, left: 0em, right: 0em, bottom: 0.2em),
  padding: (top: 0em, bottom: 0em),
)

#let theorem = thmplain(
  "theorem",
  [#h(indent) Теорема],
  titlefmt: strong,
  supplement: none,
  base_level: 1,
  //
)

#let corollary = thmplain(
  "corollary",
  [#h(indent) Следствие],
  base: "theorem",
  titlefmt: strong,
)

#let remark = thmplain(
  "remark",
  [#h(indent) Замечание],
  titlefmt: strong,
).with(numbering: none)

#let lemma = thmplain(
  "lemma",
  [#h(indent) Лемма],
  titlefmt: strong,
  supplement: none,
  base_level: 1,
  //
)

#let claim = thmplain(
  "claim",
  [#h(indent) Утверждение],
  titlefmt: strong,
  supplement: none,
  base_level: 1,
  //
)

#let proof = thmproof("proof", [#h(indent) Доказательство])
#let definition = thmplain(
  "definition",
  [#h(indent) Определение],
  base_level: 1, // take only the first level from the base
  titlefmt: strong,
  supplement: none,
  // separator: none, //[#h(0.1em):#h(0.2em)],
)

#let with(func: function, ..k, content: content) = {
  set func(..k)
  content
}

// #show terms: it => {
//   for item in it.children {
//     definition(item.term, item.description)
//   }
// }

// indentation hack from https://github.com/typst/typst/issues/311#issuecomment-2104447655

#let styled = [#set text(red)].func()
#let space = [ ].func()
#let sequence = [].func()

#let turn-on-first-line-indentation(
  doc,
  last-is-heading: false, // space and parbreak are ignored
  indent-already-added: false,
) = {
  for (i, elem) in doc.children.enumerate() {
    let element = elem.func()
    if element == text {
      let previous-elem = doc.children.at(i - 1)
      if i == 0 or last-is-heading or previous-elem.func() == parbreak {
        if not indent-already-added {
          indent-already-added = true
          h(indent)
        }
      }
      elem
    } else if element == heading {
      indent-already-added = false
      last-is-heading = true
      elem
    } else if element == space {
      elem
    } else if element == parbreak {
      indent-already-added = false
      elem
    } else if element == sequence {
      turn-on-first-line-indentation(
        elem,
        last-is-heading: last-is-heading,
        indent-already-added: indent-already-added,
      )
    } else if element == styled {
      styled(
        turn-on-first-line-indentation(
          elem.child,
          last-is-heading: last-is-heading,
          indent-already-added: indent-already-added,
        ),
        elem.styles,
      )
    } else {
      indent-already-added = false
      last-is-heading = false
      elem
    }
  }
}

#let template(body) = {
  // set document(author: "dds", title: "ds")
  // Set the basic text properties.
  set text(
    font: "Liberation Serif",
    lang: "ru",
    size: 14pt,
    // fallback: true,
    hyphenate: false,
    overhang: false,
  )

  // Set the basic page properties.
  set page(
    paper: "a4",
    number-align: center,
    margin: (top: 20.5mm, bottom: 20.5mm, left: 30.5mm, right: 10.5mm),
    numbering: "1",
    // footer: rect(fill: aqua)[Footer],
  )
  counter(page).update(1)

  // Set the basic paragraph properties.
  set par(
    leading: 1.25em,
    justify: true,
    // first-line-indent: 1.25em,
    // hanging-indent: 1.25em,
  )

  // block spacing
  // set block(spacing: 3.65em,)

  // Additionally styling for list.
  set enum(indent: 0.5cm)
  set list(indent: 0.5cm)

  set heading(numbering: "1.1.")
  show heading: set align(center)
  show heading: it => {
    it
    v(1em)
  }
  show heading.where(level: 1): it => {
    pagebreak()
    it
  }
  show heading.where(level: 3): set heading(numbering: none, outlined: false)

  set math.equation( //
    numbering: (num =>
    "("
    + ((counter(heading).get().at(0),)
    + (num,)).map(str).join(".")
    + ")")
  )
  set math.equation(supplement: none)
  show math.cases: set align(left)


  show figure.caption: set text(size: 0.8em)
  show figure.caption: set par(leading: 1em)

  // show figure.where(kind: 1): ""

  // set figure(supplement: "рис.")

  // see https://github.com/typst/typst/issues/311#issuecomment-1722331318
  show regex("^\s*!!\s*"): context h(indent)

  show <nonum>: set heading(numbering: none)
  show <nonum>: set math.equation(numbering: none)

  show: turn-on-first-line-indentation

  body
}
