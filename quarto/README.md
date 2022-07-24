# CalculusWithJulia via quarto

To compile the pages through quarto


* author in `.jmd` files (to be run through pluto)
* run `julia make_qmd.jl` to convert to `.qmd` files
  - The files in subdirectories are generated, they should not be edited
  - The files in this main directory are quarto specific.
  - `_book` and `_freeze` are conveniences
* run `quarto preview` to develop interactively (kinda slow!)
* run `quarto render` to render pages (not too bad)

# to publish

* bump the version number in `_quarto.yml`, `Project.toml`
* run `quarto publish gh-pages` to publish
* should also push project to github
* no need to push `_freeze` the repo, as files are locally rendered for now.




---
Eventually, if this workflow seems to be settled:

* deprecate .jmd files
* deprecate need to make "pluto friendly"
* do something with JSXGraph
* figure out why PlotlyLight doesn't work
* move to not use CalculusWithJulia.WeaveSupport
* use an include file not the "hack" in jmd2qmd
* modify sympy's show method
* take advantage of mermaid, ojs, bibliography, ...
