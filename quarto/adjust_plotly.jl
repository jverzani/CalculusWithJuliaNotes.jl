# The issue with `PlotlyLight` appears to be that
# the `str` below is called *after* the inclusion of `require.min.js`
# (That str is included in the `.qmd` file to be included in the header
# but the order of inclusion appears not to be adjustable)
# This little script just adds a line *before* the require call
# which seems to make it all work. The line number 83 might change.

#alternatives/plotly_plotting.html
function _add_plotly(f)
    #lineno = 117


    r = readlines(f)
    inserted = false
    open(f, "w") do io
        for (i,l) ∈ enumerate(r)
            if contains(l, "require.min.js")
                !inserted && println(io, """
<script src="https://cdn.plot.ly/plotly-2.6.3.min.js"></script>
""")
                inserted = true
            end
            println(io, l)
        end
    end
end



function (@main)(args...)
    for (root, dirs, files) in walkdir("_book")
        for fᵢ ∈ files
            f = joinpath(root, fᵢ)
            if endswith(f, ".html")
                dirname(f) == "_book" && continue
                _add_plotly(f)
            end
        end
    end

    #f = "_book/integrals/center_of_mass.html"
    #_add_plotly(f)

    return 1
end

 ["ODEs", "alternatives", "derivatives", "differentiable_vector_calculus", "integral_vector_calculus", "integrals", "limits", "misc", "precalc", "site_libs"]
