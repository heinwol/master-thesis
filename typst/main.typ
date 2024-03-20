#import "./template.typ": *

#show: thmrules
#show: template

// Document begins!

= Lorem ipsum

#lorem(30)

Я думаю, что все это очень хорошо $cal(A) := { x in RR | x "натуральное" }; angle.right.dot$

#theorem[
  dsds fddf\
  fdfd
] <dsdd>

В @dsdd сказано s@dsdd ляля

#proof[
  - аваав
  - авав
] <proof1>

как следует из @dsdd s dssd

#figure(
  align(
    center,
  )[#grid(
      columns: 2,
      align: (col, row) => (auto, auto,).at(col),
      inset: 20pt,
      [$ f (q) = min {R^prime dot.circle (q times.circle bold(1)) , med R} $],
      [\(1.2)],
    )],
)
// #show terms: it => { it.children.map(item => { repr(item) }) }

#show terms: it => {
  for item in it.children {
    definition(item.term, item.description)
  }
}
/ Хороший человек: молодец
/ Нехороший человек: редиска

// #definition("lala", "baba")
// #definition("lalas", "babas")
аывы

/ ЛЯЛЯ: jds
