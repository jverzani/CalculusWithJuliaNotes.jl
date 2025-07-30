# code to turn a qmd file into a pdf file
# then stictch them all together
# include, then load main
using PDFmerger
using Mustache

index = "_pdf_index"


typst_tpl = mt"""
---
title: {{:title}}
date: today
engine: julia
execute:
  daemon: false
format:
  typst:
    toc: false
    section-numbering: "1.1.1"
    number-depth: 3
    keep-typ: false
    include-before-body:
      - text: |
        #set figure(placement: auto)
bibliography: references.bib
---
```{julia}
#| echo: false
import Plots; Plots.plotly() = Plots.gr();
nothing
```
"""

index = "_pdf_index"
tmp = "XXX.qmd"
function process_file(qmd)
    f = "$qmd.qmd"
    open(tmp, "w") do io
        print(io, typst_tpl(title=qmd))
        for r ∈ readlines(f)
            # fixup
            r = replace(r, "($dir/figures/"=>"(figures/")
            println(io, r)
        end
    end
    run(`quarto render $tmp --to typst`)
end

# run
function (@main)(args...)
    nothing_to_do = mtime("_pdf_index.pdf") > maximum(mtime, (filter(endswith(".qmd"), readdir("."))))

    if !("--force" ∈ args) && nothing_to_do
        @info "Nothing to update"
        return nothing
    end

    @info "process $index.qmd"
    run(`quarto render $index.qmd --to typst`)
    for p in files
        @info "Process $p"
        process_file(p)
        @info "Merge $p into $index.qmd file"
        append_pdf!("$index.pdf", "XXX.pdf")
    end
    @warn "cleanup files"
    rm("XXX.qmd", force=true)
    rm("XXX.pdf", force=true)
    rm("XXX.typ", force=true)
    rm("XXX_files", force=true, recursive=true)
end
