## TODO

* download links to Pluto .jl files (if we have .jmd, but we might deprecate...)
* PlotlyLight
* mermaid, ojs?

DONE * clean up edit link
DONE * remove pinned header
DONE * clean up directory
DONE (?) * JSXGraph files

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
* or `quarto publish gh-pages --no-render` to avoid re-rendering, when just done
* should also push project to github
* no need to push `_freeze` the repo, as files are locally rendered for now.

* This error
> fatal: 'gh-pages' is already checked out at '/Users/verzani/julia/CalculusWithJuliaNotes/quarto/f5611730'

was solved with (https://waylonwalker.com/til/git-checkout-worktree/)

> git worktree remove f5611730




---
Eventually, if this workflow seems to be settled:

* deprecate .jmd files
* deprecate need to make "pluto friendly"
DONE? * do something with JSXGraph
* figure out why PlotlyLight doesn't work
* move to not use CalculusWithJulia.WeaveSupport
DONE * use an include file not the "hack" in jmd2qmd
* modify sympy's show method
* take advantage of mermaid, ojs, bibliography, ...
