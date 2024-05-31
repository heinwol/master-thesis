#import "./typst-packages/packages/preview/ctheorems/1.1.2/lib.typ": *
#import "@preview/sourcerer:0.2.1": code as code_

// indentation hack from https://github.com/typst/typst/issues/311#issuecomment-2104447655
#let indent = 1.25cm
#let styled = [#set text(red)].func()
#let space = [ ].func()
#let sequence = [].func()

#let turn-on-first-line-indentation(
  doc,
  last-is-heading: false, // space and parbreak are ignored
  indent-already-added: false,
) = {
  if doc.has("children") {
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
  } else {
    doc
  }
}
#let code(..args) = code_(..args)

// ------------

#let default_thm_args = arguments(
  separator: [. #h(0.2em)],
  inset: (top: 0.2em, left: 0em, right: 0em, bottom: 0.2em),
  padding: (top: 0em, bottom: 0em),
)

#let thmbox = thmbox.with(..default_thm_args)
#let thmplain = thmplain.with(..default_thm_args)
#let thmproof = thmproof.with(..default_thm_args)

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

// -----------

#let wrap-thm-with-indentation(env) = {
  (..args, doc) => env(..args, turn-on-first-line-indentation(doc))
}

// #let theorem = wrap-thm-with-indentation(theorem)
// #let corollary = wrap-thm-with-indentation(corollary)
// #let remark = wrap-thm-with-indentation(remark)
// #let claim = wrap-thm-with-indentation(claim)
// #let lemma = wrap-thm-with-indentation(lemma)
// #let proof = wrap-thm-with-indentation(proof)
// #let definition = wrap-thm-with-indentation(definition)

// -----------

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

  set linebreak(justify: true)

  // Additionally styling for list.
  set enum(indent: 0.5cm)
  set list(indent: 0.5cm)

  set heading(numbering: "1.1")
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
  // show math.colon: math.class("punctuation", math.colon)
  show math.equation: e => {
    show math.colon: $math.class("punctuation", math.colon) thin$
    e
  }


  set ref(supplement: it => {
    if it.func() == figure {
      "рис."
    } else {
      it.supplement
    }
  })

  set grid(column-gutter: 5pt)

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
