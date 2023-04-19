# The issue with `PlotlyLight` appears to be that
# the `str` below is called *after* the inclusion of `require.min.js`
# (That str is included in the `.qmd` file to be included in the header
# but the order of inclusion appears not to be adjustable)
# This little script just adds a line *before* the require call
# which seems to make it all work. The line number 83 might change.

f = "_book/alternatives/plotly_plotting.html"
lineno = 88

str = """

<script src="https://cdn.plot.ly/plotly-2.11.0.min.js"></script>

"""

r = readlines(f)
open(f, "w") do io
    for (i,l) ∈ enumerate(r)
        i == lineno && println(io, str)
        println(io, l)
    end
end
