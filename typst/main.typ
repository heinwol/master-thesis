#import "./template.typ": thmrules, template, definition, theorem, proof

#let sp = h(0.5em)

#let state_dict(d) = {
  assert(type(d) == dictionary)
  ${
    #(d
    .pairs()
    .map(((k, v)) => $bold(#(k+":")) #v$)
    .join(",")
    )
  }$
}

#let generated_image(subpath) = {
  assert(type(subpath) == str)
  (..args) => image("../assets/generated/" + subpath, ..args)
}

#show: thmrules
#show: template

////////////////////////
// Document begins!
////////////////////////

= РЕФЕРАТ <nonum>

Ключевые слова: графовая динамическая пороговая модель, ресурсная сеть

#outline(title: [Содержание])

= СПИСОК ОБОЗНАЧЕНИЙ <nonum>

- $(A -> B)$ --- множество (тип) всех функций из $A$ в $B$, т.е. $A -> B = B^A = {f | f: A -> B}$. Данный оператор $(- -> -)$ является право-ассоциативным, т.е. $A -> B -> C = A -> (B -> C)$.
// - *Оператор точки $(-.-)$* --- доступ к полю структуры (по аналогии с объектно-ориентированными языками программирования) или сужение контекста. Так, если сказано, например, что $A eq.def (B, C)$, где $B eq.def (X, Y union.sq Z)$, то $A.B.X$ означает именно $X$, определенный выше, т.е. относящийся к $B$, который, в свою очередь, относится к $A$.
- *Оператор степени функции $(-^n)$*. Если $f(x)$ -- некоторая функция, то под $f^n$ понимается функция $f$ взятая в композиции с собой $n$ раз, т.е. $f^n (x) = f(f(...f(x))) = underbrace(f circle.tiny f circle.tiny ... circle.tiny f, n "раз")(x)$.

// TODO Дописать или переписать))

= ВВЕДЕНИЕ <nonum>

Сетевые модели находят много форм и приложений в современной математической науке. На основе сетевых моделей строятся нейронные сети, модели социальных сетей, автоматы, многоагентные системы и т.п. Одним из направлений исследований сетевых моделей являются ресурсные сети.

Модель ресурсной сети представляет из себя ориентированный граф, в каждой вершине которого располагается некоторое количество так называемого ресурса (некоторое неотрицательное вещественное число). Вершины могут накапливать сколь угодно большое количество ресурса. Модель представляет из себя динамическую систему в дискретном времени, похожую на цепь Маркова. Как и в цепи Маркова, на каждом такте между соседними вершинами происходит перераспределение значений чисел, приписанных к вершинам, так, чтобы суммарное количество ресурса осталось неизменным (ресурс не появляется из ниоткуда и не исчезает в пустоту). Если суммарное количество ресурса в сети невелико, то ресурсная сеть функционирует как цепь Маркова (с поправкой на некоторый коэффициент). Однако же в случае большого суммарного ресурса в силу вступают нелинейные факторы: согласно определению ресурсной сети, вершина не может отдать по ребру ресурса больше, чем пропускная способность этого ребра.

Понятие ресурсной сети было впервые предложено Кузнецовым О.П. в 2009 году @Kuznetsov2009. Данная тема получила широкое развитие: были исследованы многие свойства обыкновенных ресурсных сетей. Так, в монографии @ЖИЛЯКОВА2013 были вычленены основные характеристики ресурсных сетей (например, пороговое значение ресурса, вершины-аттракторы) и предложена классификация сетей. Был проведен полный анализ поведения нерегулярных ресурсных сетей при малом количестве ресурса, эйлеровых сетей, регулярных сетей и др. Можно отметить и работу @Zhilyakova2022, в которой с помощью ресурсных сетей были получены результаты в теории стохастических матриц и неоднородных цепей Маркова. Рассматривалось также и множество модификаций указанной модели. Особого внимания заслуживает модификация ресурсной сети с «жадными» вершинами @Чаплинская2021. Исследовались также и приложения ресурсных сетей к моделированию реальных процессов, например, распространения вещества в жидкой среде @Zhilyakova2012.

Данная работа предлагает еще одно приложение ресурсных сетей: моделирование перколяции, т.е. просачивания в некоторой среде. Каноническим трудом является @Bollobas_Riordan_2006, где описаны основные модели, исследующие это явление. Исследование перколяции как направления математики активно и по сей день, примером чему может служить @Li2021. Отметим, однако, что основным методом исследования перколяции является теория случайных графов. Мы же предлагаем несколько иное прочтение понятия перколяции и иной способ моделирования -- с помощью губковых сетей, которые являются модификацией модели ресурсной сети.

= Основные понятия

== Модель ресурсной сети

Неформально говоря, ресурсная сеть -- ориентированный размеченный граф, в каждой вершине которого находится некоторое количество «ресурса». Ресурс есть некоторое неотрицательное вещественное число. Можно мыслить о ресурсе как о жидкости, к примеру. Ресурсная сеть образует динамическую систему с дискретным временем. А именно, каждый такт ресурс перераспределяется между вершинами так, чтобы суммарное количество ресурса в сети оставалось неизменным. Каждая вершина «отдает» в каждое из своих ребер ресурс, пропорциональный пропускной способности (метке) этого ребра, но не больше, чем сама пропускная способность. Таким образом, если в каждой вершине ресурса достаточно мало, то система функционирует эквивалентно цепи Маркова (с поправкой на некоторый коэффициент). Если же ресурса много, то в каждую вершину приходит столько ресурса, какова суммарная пропускная способность входящих в эту вершину ребер (по крайней мере, некоторое время). Оба этих случая по отдельности кажутся очень простыми, однако сложность представляет исследование именно промежуточных состояний, то есть таких, при которых часть вершин содержит мало ресурса, а часть -- много.

Определим теперь понятие ресурсной сети более формально.

#definition[
  *Ресурсная сеть* -- это тройка $S = (G, D, S)$, где:
]
- $G = (V, E)$ -- ориентированный граф, дуги $E$ которого размечены над множеством $RR_+$ неотрицательных вещественных чисел, а $|V| = n$. Метки дуг лучше всего понимать как аналог пропускной способности. Предположим, что зафиксирована некоторая нумерация вершин $"num" : V -> overline(1"," n) .$ Тогда метку дуги $e_(i j)$ будем записывать как $r_(i j)$ ($r_(i j) = 0$ если дуги не существует);

- $D$ -- множество (допустимых) состояний динамической системы, т.е. некоторое подмножество множества $(V arrow.r med bb(R)_(+))$. Менее формально говоря: каждой вершине $v$ может быть присвоено некоторое значение из множества $bb(R)_(+)$, но, вообще говоря, не все значения из $bb(R)_(+)$ могут быть допустимыми. Произвольное состояние из $D$ будем обозначать как $q in D$. Если нумерация вершин считается фиксированной, то под $q$ будем понимать $n$-мерный вектор.

- $S : D -> D$ -- функция эволюции динамической системы, при этом $S$ однозначно определяется $G$ и $D$. Более подробное описание функции $S$ будет приведено ниже.


_Примечание:_ Как можно видеть, довольно сложно сформулировать определение ресурсной сети, инвариантное относительно выбранной нумерации вершин. В связи с этим для легкости дальнейшего изложения зафиксируем нумерацию, покуда это не вызовет недопониманий.

#definition[
  *Ресурсы* $q_i (t)$ — неотрицательные числа, присвоенные вершинам $v_i; #h(0.6em) i = overline(1"," n)$ и изменяющиеся в дискретном времени $t$.

  *Состояние* $Q(t)$ c на временном шаге $t$ представляет собой вектор-строку значений ресурсов в каждой вершине: $q(t) = (q_1(t), q_2(t), ..., q_(n)(t))$.
]

#definition[
  *Матрица пропускной способности* ресурсной сети -- $R eq.def (r_(i j))_(n times n)$. В~сущности, это матрица смежности графа $G$ с весами из $RR_+$.
]

#definition[
  *Стохастическая матрица* ресурсной сети:

  $ R' eq.def 
    mat(
      delim: "(", 
      r_11 / r_1^("out"), dots.h.c, r_(1 n) / r_1^("out"); 
      dots.v, dots.down, dots.v;
      r_(n 1) / r_n^("out"), dots.h.c, r_(n n) / r_n^("out")
    ), $ <nonum>

  где $bold(r_i^("out")) eq.def sum_(j=1)^n r_(i j)$.

  Матрица $R'$ называется стохастической потому, что если рассмотреть цепь Маркова, построенную по тому же графу $G$, что и ресурсная сеть, отнормировав при этом веса ребер так, чтобы в каждой строке матрицы смежности сумма значений была равна единице, то получим в точности матрицу $R'$.
]

#definition[
  *Матрица потока* ресурсной сети: 
  
  $ F(q) eq.def min { R' dot.circle (bold(1) dot.op q), R }, $ <nonum>

  где min применяется поэлементно, $dot.circle$ -- произведение Адамара, $bold(1)$ -- вектор-столбец из единиц.

  Поток из $i$-й вершины в $j$-ю есть в точности то количество ресурса, которое придет из $i$-й вершины в $j$-ю под действием $S$. Следует отметить, что
    + ресурсы, приходящие из разных вершин, складывается и
    + если суммарный выходной поток меньше текущего количества ресурса в вершине, то излишек не пропадает, а остается в вершине.
] <def:flow-matrix>

Таким образом, можно определить, наконец, функцию эволюции динамической системы $S$:

$ S(q) eq.def q - (F(q) dot bold(1))^T + bold(1)^T dot F(q) $ <eq:S>

Дискретная динамическая система определяется стандартно: пусть дано некоторое начальное состояние $q^0 in D,$ тогда определим:

$ cases(
  q(0) &= q^0";",
  q(t) &= S(q(t-1))"," sp t in NN.
) $

#definition[
  Пусть дано некоторое состояние $q$ ресурсной сети. Тогда определим

  $
    Z^(-)(q) = {v_i in G | q_i <= r_i^("out")};\
    Z^(+)(q) = {v_i in G | q_i > r_i^("out")},
  $

  Очевидно, что $forall q in RR_(+)^n sp Z^(+)(q) union.sq.big_()^() Z^(-)(q) = V$. Если вершина принадлежит $Z^(+)(q)$, то говорим, что она *работает по правилу 1*. Если же вершина принадлежит $Z^(-)(q)$, то говорим, что она *работает по правилу 2*.
]

#let state_1 = ("0": 8, "1": 1, "2": 0)
Пример ресурсной сети $"network"_1$ можно видеть на @fig:basic_network_1. Множество вершин здесь есть $"network"_1.G.V = {0, 1, 2}$, а метки ребер обозначают соответствующие веса в графе $"network"_1.G$. На @fig:basic_network_2 показано некоторое состояние сети с ресурсами #state_dict(state_1). При данном способе визуализации вершины имеют разный размер в зависимости от количества имеющегося в них ресурса. Более того, вершины $v_i$, в которых ресурс не меньше порогового значения (т.е. $q_i >= r_i^("out")$), окрашены в фиолетовый цвет, а остальные -- в салатовый. 

#grid(
  columns: 2,
  align: bottom,
  [
    #figure(
      caption: [Ресурсная сеть $"network"_1$.],
      generated_image("basic_network/plot.svg")(width: 75%)
    ) <fig:basic_network_1>
  ],
  [
    #figure(
      caption: [Состояние сети $"network"_1$ при #state_dict(state_1).],
      generated_image("basic_network/sim.svg")()
    ) <fig:basic_network_2>
  ],
)

Матрица пропускной способности $"network"_1$ приведена в уравнении @eq:basic_network_R, а ее стохастическая матрица -- в уравнении @eq:basic_network_R_. Можно убедиться, что сумма значений в каждой строке стохастической матрицы равна единице.

#grid(
  columns: 2,
  [
    $ R = mat(
        0, 3, 1;
        4, 1, 0;
        2, 2, 0;
    ) $ <eq:basic_network_R>
  ],
  [
    $ R' = mat(
      0   , 0.75, 0.25;
      0.8 , 0.2 , 0   ;
      0.5 , 0.5 , 0   ;
    ) $ <eq:basic_network_R_>
  ],
)


Исходя из формы определения матрицы потока @def:flow-matrix, можно объяснить механизм функционирования ресурсной сети более наглядно. Если предположить, что в некотором состоянии все вершины работают по правилу 1 (т.е. $Z^+(q) = V$), то из @eq:S и определения @def:flow-matrix получим

$ S(q) = q - (R dot bold(1))^T + bold(1)^T dot R = q + 1^T (R - R^T). $ <nonum>

Иначе говоря, в этой ситуации модель напоминает потоковую  @Goldberg1989, поток не зависит от текущего состояния, а только от свойств самого графа. Напротив, если предположить, что все вершины работают по правилу 2 (т.е. $Z^-(q) = V$), то окажется, что модель получается линейной:

$ S(q) = q dot R'. $ <eq:Markov>

Поскольку матрица $R'$ -- стохастическая (т.е. сумма значений в каждой строке равна 1), то модель @eq:Markov аналогична модели цепи Маркова с непрерывным состоянием и дискретным временем @Dynkin1965.

Отметим, что "большая часть" ресурсных сетей в пределе ведут себя во многом идентично цепям Маркова. Подробное и объемлющее описание поведения обычных ресурсных сетей приведено в @ЖИЛЯКОВА2013.

== Модель ресурсной сети с жадными вершинами

Данная модификация модели обыкновенной ресурсной сети была предложена Чаплинской Н.В. в @Жилякова2021, а затем исследована в работах @Чаплинская2021 @Чаплинская2021a. Суть модели в следующем: вершины, обладающие петлей (т.е. $e_(i i) in G.E$) отдают свой ресурс сначала в петлю, а остаток распределяют уже согласно обыкновенному закону функционирования ресурсной сети. Получается, что такие вершины -- "запасливые", пытающиеся сначала "отложить" ресурс себе, а уже потом распределять его между соседями. Из такой аналогии и проистекает их название.

Одно из интересных свойств такой сети состоит в том, что при достаточно маленьком количестве ресурса и при выполнении некоторых дополнительных свойств достижимости в графе и при некотором начальном распределении ресурса по вершинам  происходит так называемая "остановка" сети: 70% ресурса оказывается сосредоточено в жадных вершинах, при этом вершина не может отдавать ресурс никуда, помимо петли (поскольку ресурса у нее недостаточно). Получается, что поток в сети оказывается нулевым (за исключением петель, в которые все время поступает весь ресурс из вершин). Естественно, динамическая система оказывается стабилизированной в том смысле, что $S(q) = S^2(q)$. Пример останавливающейся сети и ее начального состояния приведены на @fig:stop_network_1, а остановившаяся сеть -- на @fig:stop_network_2.

#grid(
  columns: 2,
  align: bottom,
  [
    #figure(
      caption: [Начальное состояние стабилизирующейся сети.],
      generated_image("stop_network/sim1.svg")()
    ) <fig:stop_network_1>
  ],
  [
    #figure(
      caption: [Та же сеть в остановившемся состоянии.],
      generated_image("stop_network/sim2.svg")()
    ) <fig:stop_network_2>
  ],
)

Более подробное описание ситуаций, в которых сети демонстрируют подобное поведение представлено в @Чаплинская2021 (например, утверждение 5).

= Результаты

== Губковые сети

Особый интерес нашего исследования представляют *губковые сети*. Относить к губковым сетям мы будем ресурсные сети с жадными вершинами, имеющими специфическую топологию. А именно, будем рассматривать графы, являющиеся в некотором смысле регулярными (определим "регулярность" более подробно ниже), при этом у таких графов будет выделен "верх" и "низ", т.е. множество вершин, в которые в начальный момент времени будет класться ресурс и множество вершин, в которые этот ресурс может стекать. При этом подразумевается наличие некоторой ориентации: протекание ресурса "сверху вниз" должно идти быстрее, чем "снизу вверх". Более того, в целях более точной геометрической интерпретации модели можно было бы считать, что графы губковых сетей планарны, т.е. допускают вложение в $RR^2$. Однако, как мы увидим в дальнейшем, такое  ограничение является слишком сильным. Пример губковой сети ($"sponge_network"_1$) приведен на @fig:some_sponge_network_1. Верхними вершинами в $"sponge_network"_1$ являются ${(i, 2) | i in #overline[0, 4]}$, а стоковыми ${(i, -1) | i in overline(0"," 4)}$.

#figure(
  caption: [Пример губковой сети $"sponge_network"_1$.],
  generated_image("some_sponge_network/plot.svg")(width: 70%),
) <fig:some_sponge_network_1>

На данном примере можно показать, откуда проистекает название губковых ресурсных сетей. Можно представить, что данный граф моделирует некоторую двухмерную губку с решетчатой внутренней структурой (в данном случае, решетка квадратная). В начальный момент времени на губку капают некоторой жидкостью сверху (на верхние вершины). Затем жидкость просачивается через губку, дотекая до низу, откуда и вытекает из губки (в стоковые вершины). Мы рассматриваем также вариант модели, в которой нет стоковых вершин (например, как на @fig:some_sponge_network_without_sinks_1). Граф "губки" при этом (по крайней мере, если убрать стоковые вершины) является сильно связным. Это сделано для моделирования капиллярного эффекта: жидкость может распространяться из одного кусочка губки во все соприкасающиеся с ним куски, в том числе и вверх. 

#figure(
  caption: [Губковая сеть $"sponge_network"_1$, в которой убраны стоки.],
  generated_image("some_sponge_network_without_sinks/plot.svg")(width: 70%),
) <fig:some_sponge_network_without_sinks_1>

#[
  #set text(hyphenate: false)
  Заметим, что веса ребер, идущих "сверху вниз", заметно больше, чем веса ребер, идущих "снизу вверх" ($5 >> 1$), что подкрепляет нашу геометрическую аналогию.
]

Губковая сеть -- в некотором роде, продолжение модели распространения загрязнения в водной среде, описанной в @Жилякова2011. В ней распространения загрязнения моделировалось растеканием ресурса в сети, заданной прямоугольной решеткой, в которой пропускные способности соответствовали силе течений и скорости ветра. Губковая сеть, помимо иной интерпретации, отличается большей гибкостью: она включает большее разнообразие топологий, имеет жадные вершины, а также является открытой -- ресурс может втекать сверху и вытекать снизу.

=== Программная реализация


Для исследования свойств губковых сетей, было реализовано соответствующее программное окружение на языке Python. Приложение было названо "sponge-netowrks", оно имеет открытый исходный код, опубликованный на Github @Корешков2023. Лицензия проекта -- MIT.

Основная задача проекта -- предоставить пользователю доступ к надежному, удобному и свободно расширяемому интерфейсу для проведения различных исследований в области ресурсных сетей. Проект интегрирован со средой jupyter notebook, что позволяет получать результаты симуляций и прочих операций над ресурсными сетями в удобно читаемом и интерактивном виде. Sponge-networks позволяет:
- создавать ресурсные сети на основе матриц, графов и списков смежности;
- модифицировать произвольным образом ресурсные сети, не нарушая внутренней целостности данных;
- проводить симуляции, задавая количество шагов, которые должна отработать система, и начальные условия. Результат симуляции хранит в себе всю необходимую информацию о состояниях и потоках сети за время симуляции;
- искать предельные состояния ресурсной цепи, а также положения равновесия эргодической ресурсной сети как цепи Маркова;
- представлять симуляции в виде массивов, листов Excel и графиков;
- рисовать ресурсные сети;
- рисовать симуляции в виде ресурсных сетей с анимациями, реализованными с помощью слайдера, который позволяет визуализировать на граф ресурсной сети в произвольный момент времени;
- экспортировать анимации в gif;
- создавать губковые сети на основе обычных ресурсных сетей и проводить их симуляции;
- создавать губковые сети по шаблону, указывая тип и параметры сетки, а также веса ребер по направлению. Присутствует возможность указать, создавать ли в сети стоки.

=== Типы сеток




= ЗАКЛЮЧЕНИЕ <nonum>


// TODO:
// - сослаться на монографию а не на работу 2013 года ЖИЛЯКОВА РЕСУРСНЫЕ СЕТИ...
#bibliography(
  "../literature/sn_literature.bib",
  title: [Список использованных источников],
  style: "../literature/gost-r-7-0-5-2008-numeric.csl",
)

////////////////////////////////////////
#pagebreak()


#figure(
  align(
    center,
  )[#grid(
      columns: 2,
      align: (col, row) => (auto, auto,).at(col),
      inset: 20pt,

      [$ f (q) = min {R^prime dot.circle (q times.circle bold(1)) , med R} $],
      [maybe],
    )],
)
