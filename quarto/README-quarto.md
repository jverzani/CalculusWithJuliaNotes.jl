## TODO


* mermaid, ojs?

CAN'T DO * set up quarto to generate on CI. (Tried, but can't get through to the finish before a CI timeout...; Must use quarto publish command locally...)
DONE * PlotlyLight
DONE * clean up edit link
DONE * remove pinned header
DONE * clean up directory
DONE (?) * JSXGraph files
WON'T DO * download links to Pluto .jl files (if we have .jmd, but we might deprecate...) For *now* .jmd is derprecated; though we keep the files around ....

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

* XXX to get `PlotlyLight` to work the plotly library needs loading **before** require.min.js. This is accomplished by **editing** the .html file and moving up this line:

<script src="https://cdn.plot.ly/plotly-2.11.0.min.js"></script>

This can be done with this commandline call: julia adjust_plotly.jl

* This error
> fatal: 'gh-pages' is already checked out at '/Users/verzani/julia/CalculusWithJuliaNotes/quarto/f5611730'

was solved with (https://waylonwalker.com/til/git-checkout-worktree/)
> git worktree remove f5611730


# ------

In summary, there are two steps

```
quarto render
```

Preview output in `_book/index.html`. If okay to publish:


```
julia adjust_plotly.jl
quarto publish gh-pages --no-render
```

Then one should:

* push changes to origin
* merge into main
* branch to new version
* pull origin to merge





---
Eventually, if this workflow seems to be settled:

	* deprecate need to make "pluto friendly"
* take advantage of mermaid, ojs, bibliography, ...

DONE * move to not use CalculusWithJulia.WeaveSupport
DONE * remove frontmatter
DONE * fig_size -> _common_code
DONE * deprecate .jmd files
DONE? * do something with JSXGraph
DONE * figure out why PlotlyLight doesn't work XXX hacky!
DONE * use an include file not the "hack" in jmd2qmd
DONE * modify sympy's show method
