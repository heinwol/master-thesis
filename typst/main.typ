#import "./template.typ": thmrules, template, definition, theorem, proof, claim, code, lemma, corollary, remark, turn-on-first-line-indentation as fli

#let sp = h(0.5em)

#let state_dict(d) = {
  // assert(type(d) == dictionary)
  ${#(d
    .pairs()
    .map(((k, v)) => $bold(#(k+":")) #v$)
    .join(",")
    )}$
}

#let generated_image(subpath) = {
  // assert(type(subpath) == str)
  (..args) => image("../assets/generated/" + subpath, ..args)
}

#let image_by_hand(subpath) = {
  // assert(type(subpath) == str)
  (..args) => image("../assets/images/" + subpath, ..args)
}

#let varnothing = $text(font: "Fira Sans", nothing)$

#let comment(cnt) = text(fill: red, cnt)

#let quo(l, r) = {
  $#l"/"#r$
}
#let esq(u, eqv_rel: none) = $[#u]_#( if eqv_rel == none {"~"} else {eqv_rel})$

#let Stab = $"Stab"$
#let Aut = $"Aut"$

#show: thmrules
#show: template

////////////////////////
// Document begins!
////////////////////////

#outline(title: [СОДЕРЖАНИЕ])

= ВВЕДЕНИЕ <nonum>

Сетевые модели находят много форм и приложений в современной математической науке. На основе сетевых моделей строятся нейронные сети, модели социальных сетей, автоматы, многоагентные системы и т.п. Одним из направлений исследований сетевых моделей являются ресурсные сети.

Модель ресурсной сети представляет собой ориентированный граф, в каждой вершине которого располагается некоторое количество так называемого ресурса (некоторое неотрицательное вещественное число). Вершины могут накапливать сколь угодно большое количество ресурса. Модель представляет собой динамическую систему в дискретном времени, похожую на цепь Маркова. Как и в цепи Маркова, на каждом такте между соседними вершинами происходит перераспределение значений чисел, приписанных к вершинам, так, чтобы суммарное количество ресурса осталось неизменным (ресурс не появляется из ниоткуда и не исчезает в пустоту). Если суммарное количество ресурса в сети невелико, то ресурсная сеть функционирует как цепь Маркова (с поправкой на некоторый коэффициент). Однако же в случае большого суммарного ресурса в силу вступают нелинейные факторы: согласно определению ресурсной сети, вершина не может отдать по ребру ресурса больше, чем пропускная способность этого ребра.

Понятие ресурсной сети было впервые предложено Кузнецовым О.П. в 2009 году @Kuznetsov2009. Данная тема получила широкое развитие: были исследованы многие свойства обыкновенных ресурсных сетей. Так, в монографии Жиляковой~Л.Ю. @ЖИЛЯКОВА2013 были вычленены основные характеристики ресурсных сетей (например, пороговое значение ресурса, вершины-аттракторы) и предложена классификация сетей. Был проведен полный анализ поведения нерегулярных ресурсных сетей при малом количестве ресурса, эйлеровых сетей, регулярных сетей и др. Можно отметить и работу @Zhilyakova2022, в которой с помощью ресурсных сетей были получены результаты в теории стохастических матриц и неоднородных цепей Маркова. Рассматривалось также и множество модификаций указанной модели. Особого внимания заслуживает модификация ресурсной сети с «жадными» вершинами @Чаплинская2021. Исследовались также и приложения ресурсных сетей к моделированию реальных процессов, например, распространения вещества в жидкой среде @Zhilyakova2012.

Наша работа предлагает еще одно приложение ресурсных сетей: моделирование перколяции, т.е. просачивания в некоторой среде. Каноническим трудом является @Bollobas_Riordan_2006, где описаны основные модели, исследующие это явление. Исследование перколяции как направления математики активно и по сей день, примером чему может служить обзорная статья @Li2021, в которой описываются современные модели и методы их исследования. Исследования процессов перколяции на графах продолжаются, предлагаются всё новые модели, такие как перколяция на случайных регулярных графах @Nachmias2007.

Отметим, однако, что основным методом исследования перколяции является теория случайных графов. Мы же предлагаем несколько иное прочтение понятия перколяции и иной способ моделирования -- с помощью регулярных ресурсных сетей (названных _губковыми сетями_), которые являются модификацией модели ресурсной сети.

Мы сконцентрируемся на симметриях губковых сетей в качестве нашей основной цели исследования. Мотивацией такого выбора является соображение о том, что основное свойство регулярных структур (в том числе графов) в их симметричности и периодичности. В этом же смысле и стоит понимать основное отличие губковых сетей от ресурсных сетей вообще. Однако возникает следующий вопрос: если графы ресурсной сети обладают некоторой симметрией, то как это отразится на функционировании соответствующей динамической системы? Сохранится ли эта "симметричность", и если да, то в каком смысле? На эти вопросы мы и попытаемся ответить в данной работе.

Объектом исследования работы являются регулярные ресурсные сети, предметом -- их симметрии. Цель работы состоит в описании всех симметрий губковых сетей как графов и проведение связи между симметриями их как графов и как динамических систем. Ставятся следующие задачи:
- Построить модель регулярной ресурсной сети (губковой сети);
- Описать связь симметрий регулярных замощений плоскости и симметрий губковых сетей;
- Описать полную группу симметрий губковых сетей;
- Ввести понятие факторизации губковых сетей, установить базовые свойства сетей при факторизации;
- Рассмотреть симметрии регулярных сетей после некоторых факторизаций, в частности, после помещения их на цилиндр;
- Установить связь между симметриями графов губковых сетей и симметриями динамических систем, порождающихся ресурсными сетями.

= ОСНОВНЫЕ ПОНЯТИЯ

== Модель ресурсной сети

Ресурсная сеть -- ориентированный размеченный граф, в каждой вершине которого находится некоторое количество «ресурса». Ресурс есть некоторое неотрицательное вещественное число. Можно мыслить о ресурсе как о жидкости. Ресурсная сеть образует динамическую систему с дискретным временем. А именно, каждый такт ресурс перераспределяется между вершинами так, чтобы суммарное количество ресурса в сети оставалось неизменным. Каждая вершина «отдает» в каждое из своих ребер ресурс, пропорциональный пропускной способности (метке) этого ребра, но не больше, чем сама пропускная способность. Таким образом, если в вершине ресурса достаточно мало, то система функционирует эквивалентно цепи Маркова (с поправкой на некоторый коэффициент). Напротив, если предположить, что во всех вершинах сети ресурса больше, чем их пропускная способность, то на следующем такте из каждой вершины уйдет ровно столько ресурса, какова ее пропускная способность, и придет столько ресурса, каков суммарный вес всех входящих в нее ребер. Оба этих случая по отдельности кажутся очень простыми, однако сложность представляет исследование именно промежуточных состояний, то есть таких, при которых часть вершин содержит мало ресурса, а часть -- много.

Определим теперь понятие ресурсной сети более формально.

#definition[
  *Ресурсная сеть* -- это тройка $"SN" = (G, D, S)$, где:
]
- $G = (V, E)$ -- ориентированный граф, дуги $E$ которого размечены над множеством $RR_+$ неотрицательных вещественных чисел, а $|V| = n$. Метки дуг лучше всего понимать как аналог пропускной способности. Предположим, что зафиксирована некоторая нумерация вершин $"num" : $ \ $V -> overline(1"," n) .$ Тогда метку дуги $e_(i j)$ будем записывать как $r_(i j)$ ($r_(i j) = 0$ если дуги не существует);

- $D$ -- множество (допустимых) состояний динамической системы, т.е. некоторое подмножество множества $(V arrow.r med bb(R)_(+))$. Менее формально говоря: каждой вершине $v$ может быть присвоено некоторое значение из множества $bb(R)_(+)$, но, вообще говоря, не все значения из $bb(R)_(+)$ могут быть допустимыми. Произвольное состояние из $D$ будем обозначать как $q in D$. Если нумерация вершин считается фиксированной, то под $q$ будем понимать $n$-мерный вектор.

- $S : D -> D$ -- функция эволюции динамической системы, при этом $S$ однозначно определяется $G$ и $D$. Более подробное описание функции $S$ будет приведено ниже.

_Примечание:_ Как можно видеть, довольно сложно сформулировать определение ресурсной сети, инвариантное относительно выбранной нумерации вершин. В связи с этим для легкости дальнейшего изложения зафиксируем нумерацию, покуда это не вызовет недопониманий.

#definition[
  *Ресурсы* $q_i (t)$ -- неотрицательные числа, присвоенные вершинам $v_i; #h(0.6em) i = overline(1"," n)$ и изменяющиеся в дискретном времени $t$.

  !!*Состояние* $Q(t)$ c на временном шаге $t$ представляет собой вектор-строку значений ресурсов в каждой вершине: $q(t) = (q_1(t), q_2(t), ..., q_(n)(t))$.
]

#definition[
  *Матрица пропускной способности* ресурсной сети -- $R eq.def (r_(i j))_(n times n)$. В~сущности, это матрица смежности графа $G$ с весами из $RR_+$.
]

#definition[
  *Стохастическая матрица* ресурсной сети:

  $
    R' eq.def
    mat(
      delim: "(",
      r_11 / r_1^("out"), dots.h.c, r_(1 n) / r_1^("out");
      dots.v, dots.down, dots.v;
      r_(n 1) / r_n^("out"), dots.h.c, r_(n n) / r_n^("out")
    ),
  $ <nonum>

  где $bold(r_i^("out")) eq.def sum_(j=1)^n r_(i j)$.

  !! Матрица $R'$ называется стохастической потому, что если рассмотреть цепь Маркова, построенную по тому же графу $G$, что и ресурсная сеть, отнормировав при этом веса ребер так, чтобы в каждой строке матрицы смежности сумма значений была равна единице, то получим в точности матрицу $R'$.
]

#definition[
  *Матрица потока* ресурсной сети:

  $ F(q) eq.def min {R' dot.circle (bold(1) dot.op q), R}, $ <nonum>

  где min применяется поэлементно, $dot.circle$ -- произведение Адамара, $bold(1)$ -- вектор-столбец из единиц.

  !! Поток из $i$-й вершины в $j$-ю есть в точности то количество ресурса, которое придет из $i$-й вершины в $j$-ю под действием $S$. Следует отметить следующее.
  + Ресурсы, приходящие из разных вершин, складываются.
  + Если суммарный выходной поток меньше текущего количества ресурса в вершине, то излишек не пропадает, а остается в вершине.
] <def:flow-matrix>

Таким образом, можно определить, наконец, функцию эволюции динамической системы $S$:

$ S(q) eq.def q - (F(q) dot bold(1))^T + bold(1)^T dot F(q) $ <eq:S>

Дискретная динамическая система определяется стандартно: пусть дано некоторое начальное состояние $q^0 in D,$ тогда определим:

$
  cases(
  q(0) &= q^0";",
  q(t) &= S(q(t-1))"," sp t in NN.
)
$

#definition[
  Пусть дано некоторое состояние $q$ ресурсной сети. Тогда определим

  $
    Z^(-)(q) = {v_i in G | q_i <= r_i^("out")};\
    Z^(+)(q) = {v_i in G | q_i > r_i^("out")},
  $

  !! Очевидно, что $forall q in RR_(+)^n sp Z^(+)(q) union.sq.big_()^() Z^(-)(q) = V$. Если вершина принадлежит $Z^(+)(q)$, то говорим, что она *работает по правилу 1*. Если же вершина принадлежит $Z^(-)(q)$, то говорим, что она *работает по правилу 2*.
]

#let state_1 = ("0": 8, "1": 1, "2": 0)

Пример ресурсной сети $"network"_1$ можно видеть на @fig:basic_network_1. Множество вершин здесь есть $V = {0, 1, 2}$, а метки ребер обозначают соответствующие веса в графе $G$. На @fig:basic_network_2 показано некоторое состояние сети с ресурсами #state_dict(state_1). При данном способе визуализации вершины имеют разный размер в зависимости от количества имеющегося в них ресурса. Более того, вершины $v_i$, в которых ресурс не меньше порогового значения (т.е. $q_i >= r_i^("out")$), окрашены в фиолетовый цвет, а остальные -- в салатовый.

#grid(
  columns: 2,
  align: bottom,
  [
    #figure(
      caption: [Ресурсная сеть $"network"_1$.],
      generated_image("basic_network/plot.svg")(width: 75%),
    ) <fig:basic_network_1>
  ],
  [
    #figure(
      caption: [Состояние сети $"network"_1$ при #state_dict(state_1).],
      generated_image("basic_network/sim.svg")(),
    ) <fig:basic_network_2>
  ],
)

Матрица пропускной способности $"network"_1$ приведена в формуле @eq:basic_network_R, а ее стохастическая матрица -- в формуле @eq:basic_network_R_1. Можно убедиться, что сумма значений в каждой строке стохастической матрицы равна единице.

#grid(
  columns: 2,
  [
    $
      R = mat(
        0, 3, 1;
        4, 1, 0;
        2, 2, 0;
    )
    $ <eq:basic_network_R>
  ],
  [
    $
      R' = mat(
      0   , 0.75, 0.25;
      0.8 , 0.2 , 0   ;
      0.5 , 0.5 , 0   ;
    )
    $ <eq:basic_network_R_1>
  ],
)

Исходя из формы определения матрицы потока @def:flow-matrix, можно объяснить механизм функционирования ресурсной сети более наглядно. Если предположить, что в некотором состоянии все вершины работают по правилу 1 (т.е. $Z^+(q) = V$), то из @eq:S и определения @def:flow-matrix получим

$ S(q) = q - (R dot bold(1))^T + bold(1)^T dot R = q + 1^T (R - R^T). $ <nonum>

Иначе говоря, в этой ситуации модель напоминает потоковую @Goldberg1989, поток не зависит от текущего состояния, а только от свойств самого графа. Напротив, если предположить, что все вершины работают по правилу 2 (т.е. $Z^-(q) = V$), то окажется, что модель получается линейной:

$ S(q) = q dot R'. $ <eq:Markov>

Поскольку матрица $R'$ -- стохастическая (т.е. сумма значений в каждой строке равна 1), то модель @eq:Markov аналогична модели цепи Маркова с непрерывным состоянием и дискретным временем @Dynkin1965.

Отметим, что "большая часть" ресурсных сетей в пределе ведут себя во многом идентично цепям Маркова. Подробное и объемлющее описание поведения обычных ресурсных сетей приведено в @ЖИЛЯКОВА2013.

== Модель ресурсной сети с жадными вершинами

Данная модификация модели обыкновенной ресурсной сети была предложена Чаплинской Н.В. в @Жилякова2021, а затем исследована в работах @Чаплинская2021 @Чаплинская2021a. Суть модели в следующем: вершины, обладающие петлей отдают свой ресурс сначала в петлю, а остаток распределяют уже согласно обыкновенному закону функционирования ресурсной сети. Получается, что такие вершины -- \ "запасливые", пытающиеся сначала "отложить" ресурс себе, а уже потом распределять его между соседями. Из такой аналогии и проистекает их название.

Одно из интересных свойств такой сети состоит в том, что при достаточно маленьком количестве ресурса и при выполнении некоторых дополнительных свойств достижимости в графе и при некотором начальном распределении ресурса по вершинам происходит так называемая "остановка" сети: 100% ресурса оказывается сосредоточено в жадных вершинах, при этом вершина не может отдавать ресурс никуда, помимо петли (поскольку ресурса у нее недостаточно). Получается, что поток в сети оказывается нулевым (за исключением петель, в которые все время поступает весь ресурс из вершин). Естественно, динамическая система оказывается стабилизированной в том смысле, что $S(q) = S^2(q)$. Пример останавливающейся сети и ее начального состояния приведены на @fig:stop_network_1, а остановившаяся сеть -- на @fig:stop_network_2.

#grid(
  columns: 2,
  align: bottom,
  [
    #figure(
      caption: [Начальное состояние стабилизирующейся сети.],
      generated_image("stop_network/sim1.svg")(),
    ) <fig:stop_network_1>
  ],
  [
    #figure(
      caption: [Та же сеть в остановившемся состоянии.],
      generated_image("stop_network/sim2.svg")(),
    ) <fig:stop_network_2>
  ],
)

Более подробное описание ситуаций, в которых сети демонстрируют подобное поведение представлено в @Чаплинская2021 (например, утверждение 5).

= РЕЗУЛЬТАТЫ

== Губковые сети

Настоящее исследование посвящено *губковым сетям*. Относить к губковым сетям мы будем ресурсные сети с жадными вершинами, имеющими специфическую топологию. А именно, будем рассматривать графы, являющиеся _регулярными_ (определим "регулярность" более подробно ниже), при этом у таких графов будет выделен "верх" и "низ", т.е. множество вершин, в которые в начальный момент времени будет класться ресурс и множество вершин, в которые этот ресурс может стекать. При этом подразумевается наличие некоторой ориентации: протекание ресурса "сверху вниз" должно идти быстрее, чем "снизу вверх". Более того, в целях более точной геометрической интерпретации модели можно было бы считать, что графы губковых сетей планарны, т.е. допускают вложение в $RR^2$. Однако, как будет показано в дальнейшем, такое ограничение является слишком сильным. Пример губковой сети ($"sponge_network"_1$) приведен на @fig:some_sponge_network_1. Верхними вершинами в $"sponge_network"_1$ являются ${(i, 2) | i in #overline[0, 4]}$, а стоковыми ${(i, -1) | i in overline(0"," 4)}$.

#figure(
  caption: [Пример губковой сети $"sponge_network"_1$.],
  generated_image("some_sponge_network/plot.svg")(width: 70%),
) <fig:some_sponge_network_1>

На данном примере можно показать, откуда проистекает название губковых ресурсных сетей. Можно представить, что данный граф моделирует некоторую двухмерную губку с решетчатой внутренней структурой (в данном случае, решетка квадратная). В начальный момент времени на губку капают некоторой жидкостью сверху (на верхние вершины). Затем жидкость просачивается через губку, дотекая до низу, и вытекает из губки (в стоковые вершины). Мы рассматриваем также вариант модели, в которой нет стоковых вершин (например, как на @fig:some_sponge_network_without_sinks_1). Граф "губки" при этом (по крайней мере, если убрать стоковые вершины) является сильно связным. Это сделано для моделирования капиллярного эффекта: жидкость может распространяться из одного кусочка губки во все соприкасающиеся с ним куски, в том числе и вверх.

#figure(
  caption: [Губковая сеть $"sponge_network"_1$, в которой убраны стоки.],
  generated_image("some_sponge_network_without_sinks/plot.svg")(width: 70%),
) <fig:some_sponge_network_without_sinks_1>

#[
  #set text(hyphenate: false)
  Заметим, что веса ребер, идущих "сверху вниз", заметно больше, чем веса ребер, идущих "снизу вверх" ($5 >> 1$), что подкрепляет физическую аналогию.
]

Губковая сеть в некотором роде есть продолжение модели распространения загрязнения в водной среде, описанной в @Жилякова2011. В ней распространения загрязнения моделировалось растеканием ресурса в сети, заданной прямоугольной решеткой, в которой пропускные способности соответствовали силе течений и скорости ветра. Губковая сеть, помимо иной интерпретации, отличается большей гибкостью: она включает большее разнообразие топологий, имеет жадные вершины, а также является открытой -- ресурс может втекать сверху и вытекать снизу.

=== Типы топологий сетей

Были рассмотрены и реализованы губковые сети не только с квадратной сеткой (как на @fig:some_sponge_network_1), но и с треугольной (@fig:network_types_example_triangular), и с шестиугольной (@fig:network_types_example_hexagonal).

#figure(
  caption: [Пример губковой сети с треугольной сеткой (`n_rows` $= 3$, `n_cols` $= 5$).],
  placement: top,
  generated_image("network_types_example/triangular.svg")(width: 65%),
) <fig:network_types_example_triangular>

#figure(
  caption: [Пример губковой сети с шестиугольной сеткой (`n_rows` $= 2$, `n_cols` $= 4$).],
  placement: top,
  generated_image("network_types_example/hexagonal.svg")(width: 85%),
) <fig:network_types_example_hexagonal>

Все вышеуказанные сети могут быть построены с помощью функции `build_sponge_network`.
Из приведенного вызова функции можно видеть, какие параметры можно задавать для сети: тип сети `grid_type` (`"grid_2d"` -- квадратная сетка, `"triangular"` -- треугольная, `"hexagonal"` -- шестиугольная); количество "строк" `n_rows`; количество "столбцов" `n_cols`; видимую длину ребер, ведущих в стоковые вершины `visual_sink_edge_length` и особенности сети `layout`. Последний параметр включает в себя описание весов ребер в сети, а также флаг, указывающий, создавать ли стоковые вершины.

== Симметричность и асимметричность губковых сетей

#definition[
  Пусть дана некоторая ресурсная сеть $"RN"$. Отображение $Phi : "RN" -> "RN"$ будем называть *автоморфизмом ресурсной сети*, если оно является автоморфизмом графа $G$, соответствующего этой сети, которое сохраняет, при этом, веса ребер, т.е. $forall e in E sp w(e) = w(Phi(e))$, где $w(e)$ -- вес ребра $e$, а также переводит верхние вершины в верхние.

  !! *Группой автоморфизмов ресурсной сети $"RN"$* назовем множество всех автоморфизмов данной сети $Aut("RN")$, в котором композиция функций выступает в качестве бинарной операции, наделяя указанное множество групповой структурой.
] <def:rn_aut>

#claim[
  Автоморфизм губковой сети переводит стоковые вершины в стоковые.
] <claim:auto>

Утверждение @claim:auto очевидно следует из того, что список смежности вершины является инвариантом графа, а вершины без исходящих ребер все суть стоковые.

Пусть $m in NN$ -- количество столбцов в сети, а $n in NN$ -- количество строк. Будем теперь иметь в виду, что вершины в губковых сетях допускают нумерацию парой натуральных чисел, как демонстрировалось на приведенных выше рисунках. При этом вершина с наименьшими индексами $(x, y)$ находится "слева снизу", а с наибольшими -- "справа сверху". Стоковые вершины нумеруются индексами $(x, -1)$. Верхние вершины в прямоугольной и треугольной сетях обладают индексами $(i, n)$, а в шестиугольных $(i, 2 n + 1)$ (в шестиугольных вершины с индексами $(i, 2 n)$ верхними не являются).

#definition[
  Пусть дана произвольная губковая сеть $"SN"$ (прямоугольная, треугольная или шестиугольная), а $v_1 = (x_1, y_1) in V$ и \ $v_2 = (x_2, y_2) in V$, при этом $e = (v_1, v_2) in E$. Определим наименования *типов ребер* следующим образом:
  - Ребро $e$ -- *горизонтальное*, если $x_1 != x_2 and y_1 = y_2$;
  - Ребро $e$ -- *"сверху вниз"*, если $y_1 > y_2$;
  - Ребро $e$ -- *"снизу вверх"*, если $y_1 < y_2$;
  - Ребро $e$ -- *петля*, если $v_1 = v_2$.
]

Будем исходить из того, что веса ребер в сети таковы, что:
- все ребра одного типа имеют одинаковые веса;
- вес ребер "сверху вниз" больше, чем вес ребер "снизу вверх".

Данные предположения будем называть *базовыми предположениями о губковой сети*. Все сети, продемонстрированные выше, удовлетворяют этим предположениям.

#theorem[
  Пусть губковая сеть $"SN"$ удовлетворяет базовым предположениям о губковой сети.
  Верно следующее:
  - $"SN"$ обладает осевой симметрией, т.е. $Aut("SN") tilde.equiv quo(ZZ, 2 ZZ)$, если сеть:
    - прямоугольная;
    - шестиугольная, при этом $m$ -- нечетное;
    - треугольная, при этом $m$ -- нечетное и $m > 1$;
  - $Aut("SN") tilde.equiv limits(times.big)_(i = 1)^(ceil(n "/" 2)) quo(ZZ, 2 ZZ)$ если сеть треугольная и $m = 1$;
  - в остальных случаях, сеть не обладает симметрией, т.е. $Aut("SN") tilde.equiv bold(1)$.

  !! При этом не важно, есть ли в сети стоки или нет.
]<th:sym>

Перед тем, как перейти к доказательству, покажем примеры сетей, о которых идет речь. На @fig:network_types_example_triangular приведен пример треугольной сетки с нечетным количеством столбцов, а на @fig:network_types_example_hexagonal -- шестиугольной с четным. Дополним указанные рисунки треугольной сеткой с четным количеством столбцов (@fig:network_types_example_triangular_sym) и шестиугольной с нечетным (@fig:network_types_example_hexagonal_sym). Также на @fig:network_types_example_triangular_single_sym показан пример треугольной сетки с единственным столбцом.

#grid(columns: 2, align: center + bottom)[
  #figure(
    caption: [Пример губковой сети с треугольной сеткой \ (`n_rows` $= 2$, `n_cols` $= 4$).],
    generated_image("network_types_example_sym/triangular.svg")(),
  ) <fig:network_types_example_triangular_sym>
][
  #figure(
    caption: [Пример губковой сети с шестиугольной сеткой \ (`n_rows` $= 2$, `n_cols` $= 3$).],
    generated_image("network_types_example_sym/hexagonal.svg")(),
  ) <fig:network_types_example_hexagonal_sym>
]
#figure(
  caption: [Пример губковой сети с треугольной сеткой и одним столбцом (повернуто на $90 degree$).],
  scale(
    x: 80%,
    y: 80%,
    rotate(
      reflow: true,
      -90deg,
      generated_image("network_types_example_sym/triangular_single.svg")(),
    ),
  ),
) <fig:network_types_example_triangular_single_sym>

Наблюдение, касающееся того, какие автоморфизмы может иметь объединение двух графов, можно обобщить с помощью следующего утверждения.

#claim[
  Пусть $G$ -- произвольный граф (возможно, неориентированный или же с взвешенными ребрами), при этом $V = V_1 union.sq V_2$. Пусть $Aut(G)(V_1) = V_1 and Aut(G)(V_2) = V_2$, т.е. все автоморфизмы графа $G$ переводят вершины из $V_i$ в $V_i$. Определим $tilde(V)_1$ как множество тех вершин из $V_1$, которые смежны с некоторыми вершинами из $V_2$ в графе $G$, т.е. \ $tilde(V_1) = {v in V_1 | "adj"_G (v) sect V_2 != varnothing}$, аналогичным образом определим $tilde(V)_2$. Пусть $H_1 = Aut("Gen"_G V_1)$, $H_2 = Aut("Gen"_G V_2)$. Тогда выполняется неравенство:

  $
    (limits(sect.big)_(v in tilde(V)_1) Stab_(H_1)(v)) times (
      limits(sect.big)_(v in tilde(V)_2) Stab_(H_2)(v)
    ) <= Aut(G) <= H_1 times H_2,
  $
  где $Stab_H (x)$ -- стабилизатор элемента $x$ при действии группы $H$ на него.
]

В определении автоморфизма сказано о необходимости того, чтобы верхние вершины переходили в верхние при отображении. На самом деле, об этом можно не говорить явно, поскольку это требование автоматически выполняется. По аналогии с тем, как было доказано, что в шестиугольной сети вершины $(0, 2n)$ и $(m, 2n)$ не могут перейти ни в какие другие кроме как друг в друга, здесь можно также проанализировать список смежности верхних вершин и сравнить его с другими вершинами.

Отметим еще одну деталь, касающуюся базовых предположений о губковой сети.

#claim[
  Предположим, что, в нарушение базовых предположений о губковой сети, веса "сверху вниз" и "снизу вверх" в сети $"SN"$ совпадают. Предположим также, что в сети нет стоковых вершин. Пусть сеть треугольная или прямоугольная и, дополнительно, в случае треугольной сети количество строк четно ($n = 2k$), а в случае прямоугольной $m != n$. В данном случае сеть будет иметь еще один автоморфизм $Phi: Phi((i, j)) =$ \ $= (i, 2 ceil(n "/" 2) - j)$ и, соответственно, $Aut("SN") tilde.equiv quo(ZZ, 2 ZZ)$ в случае треугольной сети и $Aut("SN") tilde.equiv (quo(ZZ, 2 ZZ))^2 = D_2$ (вторая группа диэдра, полная группа симметрий прямоугольника) в случае прямоугольной сети.
]

Очевидно, при этом, что указанная симметрия меняет местами "верх" и "низ" сети. Это выбивается за рамки нашей модели, поэтому и были сформулированы базовые предположения о губковой сети.

== Фактор-сети

// TODO: сделать что-нибудь с D, оно нам вообще надо?
#definition[
  Пусть $"RN"$ -- произвольная ресурсная сеть (возможно, с жадными вершинами), а "$~$" -- произвольное отношение эквивалентности на вершинах соответствующего графа $G$. Определим *факторизованную ресурсную сеть* (*фактор-сеть*) $quo("RN", ~) eq.def (G', D', S')$ по отношению эквивалентности "$~$" как ресурсную сеть, где:
  // - Граф $G "/" ~$ -- факторграф графа $G$ по отношению $~$;
  // Пусть $u, v in V$ и, соответственно, $esq(u), esq(v) in quo(V, ~)$.
  - Ребра $E'$ и веса $w'$ графа $G'$ определяются следующим образом. \ $forall esq(u) in quo(V, ~), forall esq(v) in quo(V, ~)$:
    - $(exists u in esq(u) : (u, u) in E) <=> (esq(u), esq(u)) in E';$ тогда

    $
      w'((esq(u), esq(u))) = "avg"{w((u, u)) | (u, u) in E and u in esq(u)}.
    $ <nonum>

    Здесь $"avg" X$ есть среднее арифметическое элементов множества чисел $X$;

    - $(exists u in esq(u), exists v in esq(v) : (u, v) in E) <=> (esq(u), esq(v)) in E'$; тогда

    $
      w'((esq(u), esq(v))) = "avg"{w((u, v)) | (u, v) in E and u in esq(u) and v in esq(v)}.
    $ <nonum>

  - Функция эволюции динамической системы $S'$ определяется согласно правилам работы ресурсной сети (возможно, с жадными вершинами), соответствущей графу $G'$.
] <def:quotient-network>

Как можно видеть, так же, как и в случае обычного факторграфа, в при факторизации в ресурсной сети не появляется никаких "новых" ребер в том смысле что количество ребер в факторизованной сети не больше, чем в исходной. Отметим также, что данное определение не согласуется с определением обычного ориентированного факторграфа. Действительно, если представить себе некоторый граф $G$ без петель, в котором отождествлены смежные вершины $u$ и $v$, то в $quo(G, ~)$ появится петля $(esq(u), esq(u)) = (esq(v), esq(v))$. Напротив, если представить себе подобную ситуацию с ресурсной сетью $"RN"$, то новых петель в ходе факторизации не появится. Такая разница введена для того, чтобы различить разные по своей сути классы ребер в ресурсной сети с жадными вершинами: петли и все остальные ребра. Действительно, если бы мы разрешили отождествлять вершины без петель так, чтобы в результате получалась "жадная" вершина, это бы заметно изменило качественные свойства сети. Впрочем, мы будем рассматривать несколько иные ситуации, подпадающие под \ определение @def:ideal-quotient.

#definition[
  Пусть $"RN"$ -- произвольная ресурсная сеть (возможно, с жадными вершинами). Отношение эквивалентности на множестве вершин сети "$~$" назовем *идеальным* (и, соответственно, получившуюся фактор-сеть $quo("RN", ~)$ назовем *идеально факторизованной*), если $forall esq(u) in quo(V, ~)$, $forall esq(v) in quo(V, ~)$ выполняются следующие условия:
  - $forall u', u'' in esq(u) sp ((u', u') in E and (u'', u'') in E and w((u', u')) = w((u'', u'')))$;
  - $forall u', u'' in esq(u), forall v', v'' in esq(v) ((u', v') in E and (u'', v'') in E => w((u', v')) = w((u'', v'')))$.

  !! Иначе говоря, всякий раз, когда в определении @def:quotient-network встречается выражение $"avg" X$ для некоторого $X$, $X$ есть одноэлементное множество.
] <def:ideal-quotient>

Если сеть факторизуется идеально, то вопрос о том, что делать с разными весами ребер, ведущих в отождествляющиеся вершины, снимается: все такие ребра имеют одинаковые веса. Такие факторизации будут представлять для нас основной интерес, поскольку они менее всех искажают симметрии, присутствующие в графе.

#claim[
  Пусть $J = {esq(v) | esq(v) in quo(V, ~) and abs(esq(v)) > 1 }$. Тогда если $forall esq(u) in J, forall esq(v) in J : esq(u) != esq(v) sp (forall u' in esq(u), forall v' in esq(v) sp "adj"_(G)(u') sect$ \ $sect "adj"_(G)(v') = varnothing)$, то выполнено второе условие из определения @def:quotient-network. Если, дополнительно, веса петель в каждом классе эквивалентности равны, то $quo("RN", ~)$ факторизуется идеально.
] <claim:simple_ideal>

Доказательство данного факта провести несложно: стоит заметить, что при выполнении условия из утверждения @claim:simple_ideal в исходном графе $G$ не окажется никакой пары ребер, ведущих из одного общего класса эквивалентности в другой общий класс эквивалентности, а значит условие на равенство весов ребер будет выполнено автоматически.

// cspell:disable-next-line
В качестве примера рассмотрим губковую сеть $"qn"_1$ ("$"qn"$" -- #strong[q]uotient #strong[n]etwork) с 2 строками и 4 столбцами с треугольной сеткой. Определим отношение эквивалентности на множестве вершин сети следующим образом. Отождествим 2 вершины, не имеющие общих смежных вершин, например, вершины $(0, 1)$ и $(3, 0)$, а остальные будут эквивалентны только себе. Для наглядности будем говорить об одноэлементных множествах сети как о самих элементах этих множеств. Так, вместо того, чтобы писать "${(0, 2)} in quo(V, ~)$", будем писать "$(0, 2) in quo(V, ~)$".

На @fig:qn_1_1 приведена данная сеть с начальным состоянием \ $q_0$ = #state_dict(("(0, 2)": 0, "(1, 2)": 30, "(2, 2)": 0, "(3, 2)": 0)) (остальные вершины имеют нулевое начальное состояние). Отождествленные вершины обведены красным. Данный рисунок является условным, поскольку никаких двух вершин в графе на самом деле нет, равно как и ребер, соединяющих эти вершины с другими. Такой способ изображения выбран потому, что в результате факторизации получившийся граф может не быть планарным, так что выбрать наглядное представление соответствующей сети может быть затруднительно. При данном способе отображения состояние "разделяется" отождествленными вершинами. На @fig:qn_1_2 показано состояние $"qn"_1$ в следующий момент времени. Вершина ${(0, 1), (3, 0)}$ содержит 5 единиц ресурса, так что на рисунке обе "вершины" содержат по 5 единиц ресурса.

#grid(columns: 2, align: center + top)[
  #figure(
    caption: [Пример фактор-сети в момент времени $t = 0$.],
    generated_image("qn_1/1.svg")(),
  ) <fig:qn_1_1>
][
  #figure(
    caption: [Та же сеть в момент времени $t = 1$.],
    generated_image("qn_1/2.svg")(),
  ) <fig:qn_1_2>
]

Поскольку в рассмотренной сети выполняются условия утверждения @claim:simple_ideal, то полученная факторизация сети идеальна. С точки зрения выбранного нами способа изображения это значит, что веса ребер на рисунке не меняются по сравнению с сетью до факторизации. Так, в исходной сети ребро $((1, 2), (0, 1))$ имело вес 5, значит и ребро $((1, 2), {(0, 1), (3, 0)})$ имеет вес 5, поэтому на приведенных рисунках соответствующее ребро имеет также вес 5.

== Губковые сети на цилиндре

#let eqcyl = $~_("cyl")$

Пусть дана некоторая сеть $"SN"$, удовлетворяющая базовым предположениям о губковой сети. Пусть $tilde(m) = m$, если сеть прямоугольная или шестиугольная и $tilde(m) = floor(m "/" 2)$, если сеть треугольная.
// Дополнительно, пусть $m$ -- четно, если сеть треугольная и шестиугольная.
Рассмотрим следующее отношение эквивалентности $eqcyl$ на множестве вершин сети $V$:
$
  u sp eqcyl v <=> cases(delim: "[",
    u = v\,,
    j_1 = j_2 and (i_1\, i_2 in {0, tilde(m)})\, #[где] (i_1, j_1) = u\, (i_2, j_2) = v.
  )
$

Будем называть $quo("SN", eqcyl)$ *губковой сетью на цилиндре*. Приведенную факторизацию можно рассматривать как помещение губковой сети на цилиндр: левый и правый края сети "склеиваются" в одну линию. Пример такой сети приведен на @fig:sn_on_cylinder_1. Как и прежде, вершины, которые были отождествлены \ (с какими-либо другими вершинами) обведены красным. Подчеркнем, что классов эквивалентности с числом элементов $> 1$ не 1, а 4: ${(0, 2), (3, 2)}$, ${(0, 1), (3, 1)}$, ${(0, 0), (3, 0)}$ и, наконец ${(0, -1), (3, -1)}$.

#figure(
  caption: [Губковая сеть с треугольной стекой, помещенная на цилиндр.],
  // placement: bottom,
  generated_image("cylinder_triangular_1/plot.svg")(width: 75%)
) <fig:sn_on_cylinder_1>

#lemma[
  Губковая сеть $quo("SN", eqcyl)$ факторизована идеально, если она удовлетворяет базовым предположениям о губковой сети.
] <lem:ideal_cylinder>

#lemma[
  Пусть $"RN"$ -- произвольная ресурсная сеть, а $~$ -- такое отношение эквивалентности на $V$, что сеть $quo("RN", ~)$ факторизована идеально. Пусть также внутри одного класса эквивалентности:

  - совпадают веса всех ребер, т.е. $forall esq(u) in quo(V, ~) sp forall u_1, u_2, u'_1, u'_2 in esq(u) :$ \ $u_1 != u_2  and u'_1 != u'_2 sp ((u_1, u_2) in E and (u'_1, u'_2) in E => w((u_1, v_1)) =$ \ $= w((u'_1, u'_2)))$;
  - совпадают веса всех петель.

  !! В таком случае, любое измельчение разбиения $quo(V, ~)$ также факторизует сеть идеально. Под измельчением мы понимаем такое отношение эквивалентности $~'$ на $V$, что $u ~' v => u ~ v$.
] <lem:subpartition>

Отметим, что у сети с треугольной сеткой на @fig:sn_on_cylinder_1 число столбцов до факторизации было четным. Для сравнения приведем сеть с треугольной сеткой и нечетным количеством столбцов (@fig:sn_on_cylinder_bad). Может показаться, что -- в отличие от случая с исходной сетью -- сеть на @fig:sn_on_cylinder_1 более симметрична, чем сеть на @fig:sn_on_cylinder_bad. Действительно, это так.

#figure(
  caption: [Губковая сеть с треугольной стекой и нечетным числом столбцов на цилиндре.],
  generated_image("cylinder_triangular_2/plot.svg")(width: 55%),
) <fig:sn_on_cylinder_bad>

#theorem[
  Пусть $"SN"$ -- губковая сеть с числом столбцов $m > 1$. Пусть также, снова, $tilde(m) = m$, если сеть прямоугольная или шестиугольная и $tilde(m) = floor(m "/" 2)$, если сеть треугольная.

  - Если сеть прямоугольная, то $Aut(quo("SN", eqcyl)) tilde.equiv D_(tilde(m) - 1)$, где $D_k$ -- $k$-ая группа диэдра.
  - Если сеть треугольная или шестиугольная, а количество столбцов четно, то $Aut(quo("SN", eqcyl)) tilde.equiv D_(tilde(m) - 1)$.
  - Если сеть треугольная или шестиугольная, но количество столбцов нечетно, то $Aut(quo("SN", eqcyl)) tilde.equiv quo(ZZ, 2 ZZ)$.

] <th:cylinder-sym>

Дополнительно был доказан следующий факт:

#claim[
  Графы губковых сетей, помещенных на цилиндр, планарны.
]

= ЗАКЛЮЧЕНИЕ <nonum>

Нами были исследованы симметрии губковых сетей и связи между автоморфизмами графов и динамических систем ресурсных сетей, порождающихся этими графами. С одной стороны, мы установили, что несмотря на регулярность, губковые сети теряют много своих симметрий относительно замощений плоскости, их порождающих. Вместе с тем было дано полное описание групп автоморфизмов губковых сетей (в том числе и в случае, когда "верх" и "низ" симметричны друг относительно друга). Было введено понятие факторизации ресурсных сетей и исследованы базовые ее свойства: в каких ситуациях сеть факторизуется идеально, а в каких нет? С помощью факторизации мы смогли из обыкновенных губковых сетей строить губковые сети на цилиндре, обладающие намного большим набором симметрий. Группы автоморфизмов таких сетей также были описаны полностью. Наконец, мы установили, что каждая симметрия графа ресурсной сети порождает симметрию ее как динамической системы. Полученные утверждения можно применять для облегчения моделирования и уменьшения размера анализируемой сети.

Проведенное исследование открывает широкий простор для дальнейших изысканий. С одной стороны, можно ставить вопросы о протекании ресурса через губковую сеть, например:

- При данных параметрах сети (столбцы, строки, вес всех типов ребер), каково минимальное количество ресурса, которое может быть помещено в верхние вершины так, чтобы ресурс дотек до стоковых вершин? Каково должно быть распределение этого ресурса?
- При данном начальном распределении ресурса в верхних вершинах, какую форму будет иметь "след" данного ресурса в пределе, если ресурса не хватит на то, чтобы покрыть все "потребности" жадных вершин? Какова зависимость ширины и глубины следа от параметров сети?

С другой стороны, можно исследовать возможность обобщения полученных результатов с губковых сетей на более общие динамические модели на графах, для которых симметрии графа и динамической системы будут соотноситься так же, как и в случае ресурсных сетей. Вероятно, можно найти такое обобщение, под которое подпадут и цепи Маркова, и ресурсные сети, и другие модели, в которых состояние вершины в следующий момент времени зависит лишь от текущего ее состояния и состояния всех смежных с ней вершин.

//  функционирование губковых сетей с

#[
  #let nbsp = sym.space.nobreak

  // HAHAHA, that's a dirty hack, but works in simple cases
  #let re = regex(`#([\w\d\-_]+)\[(.+)\]`.text)
  #show re: it => {
    let (func, text) = it.text.match(re).captures
    eval("#" + func + "[" + text + "]", mode: "markup")
  }

  #let re = regex(`(\d+)–(\d+)`.text)
  #show re: it => {
    let (l, r) = it.text.match(re).captures
    [#nbsp#box[#l–#r]]
  }

  #bibliography(
    "../literature/sn_literature.bib",
    title: [СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ],
    style: "../literature/gost-r-7-0-5-2008-numeric.csl",
  )
]
\
