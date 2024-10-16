// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let unescape-eval(str) = {
  return eval(str.replace("\\", ""))
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "linux libertine",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "linux libertine",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black or heading-decoration == "underline"
           or heading-background-color != none) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#show: doc => article(
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

#block[
#heading(
level: 
1
, 
numbering: 
none
, 
[
Preface
]
)
]
#figure([
#box(image("misc/logo.png"))
], caption: figure.caption(
position: bottom, 
[
Calculus with Julia
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)

#horizontalrule

This is a set of notes for learning #link("http://en.wikipedia.org/wiki/Calculus")[calculus] using the #link("https://julialang.org")[`Julia`] language. `Julia` is an open-source programming language with an easy to learn syntax that is well suited for this task.

Read "#link("./misc/getting_started_with_julia.html")[Getting started with Julia];" to learn how to install and customize `Julia` for following along with these notes. Read "#link("./misc/julia_interfaces.html")[Julia interfaces];" to review different ways to interact with a `Julia` installation.

Since the mid 90s there has been a push to teach calculus using many different points of view. The #link("http://www.math.harvard.edu/~knill/pedagogy/harvardcalculus/")[Harvard] style rule of four says that as much as possible the conversation should include a graphical, numerical, algebraic, and verbal component. These notes use the programming language #link("http://julialang.org")[Julia] to illustrate the graphical, numerical, and, at times, the algebraic aspects of calculus.

There are many examples of integrating a computer algebra system (such as `Mathematica`, `Maple`, or `Sage`) into the calculus conversation. Computer algebra systems can be magical. The popular #link("http://www.wolframalpha.com/")[WolframAlpha] website calls the full power of `Mathematica` while allowing an informal syntax that is flexible enough to be used as a backend for Apple’s Siri feature. ("Siri what is the graph of x squared minus 4?") For learning purposes, computer algebra systems model very well the algebraic/symbolic treatment of the material while providing means to illustrate the numeric aspects. These notes are a bit different in that `Julia` is primarily used for the numeric style of computing and the algebraic/symbolic treatment is added on. Doing the symbolic treatment by hand can be very beneficial while learning, and computer algebra systems make those exercises seem kind of redundant, as the finished product can be produced much more easily.

Our real goal is to get at the concepts using technology as much as possible without getting bogged down in the mechanics of the computer language. We feel `Julia` has a very natural syntax that makes the initial start up not so much more difficult than using a calculator, but with a language that has a tremendous upside. The notes restrict themselves to a reduced set of computational concepts. This set is sufficient for working many of the problems in calculus, but do not cover thoroughly many aspects of programming. (Those who are interested can go off on their own and `Julia` provides a rich opportunity to do so.) Within this restricted set, are operators that make many of the computations of calculus reduce to a function call of the form `action(function, arguments...)`. With a small collection of actions that can be composed, many of the problems associated with introductory calculus can be attacked.

These notes are presented in pages covering a fairly focused concept, in a spirit similar to a section of a book. Just like a book, there are try-it-yourself questions at the end of each page. All have a limited number of self-graded answers. These notes borrow ideas from many sources, for example #cite(<Strang>, form: "prose");, #cite(<Knill>, form: "prose");, #cite(<Schey>, form: "prose");, #cite(<Thomas>, form: "prose");, #cite(<RogawskiAdams>, form: "prose");, several Wikipedia pages, and other sources.

These notes are accompanied by a `Julia` package `CalculusWithJulia` that provides some simple functions to streamline some common tasks and loads some useful packages that will be used repeatedly.

These notes are presented as a Quarto book. To learn more about Quarto books visit #link("https://quarto.org/docs/books");.

To #emph[contribute] – say by suggesting additional topics, correcting a mistake, or fixing a typo – click the "Edit this page" link and join the list of #link("https://github.com/jverzani/CalculusWithJuliaNotes.jl/graphs/contributors")[contributors];. Thanks to all contributors and a #emph[very] special thanks to `@fangliu-tju` for their careful and most-appreciated proofreading.

= Running Julia
<running-julia>
`Julia` is installed quite easily with the `juliaup` utility. There are some brief installation notes in the overview of `Julia` commands. To run `Julia` through the web (though in a resource-constrained manner), these links resolve to `binder.org` instances:

- #link("https://mybinder.org/v2/gh/jverzani/CalculusWithJuliaBinder.jl/main?labpath=blank-notebook.ipynb")[#box(image("test_files/mediabag/badge_logo.svg"))] (Image without SymPy)

- #link("https://mybinder.org/v2/gh/jverzani/CalculusWithJuliaBinder.jl/sympy?labpath=blank-notebook.ipynb")[#box(image("test_files/mediabag/badge_logo.svg"))] (Image with SymPy, longer to load)

#horizontalrule

Calculus with Julia version #strong[?meta:version];, produced on #strong[?meta:date];.
