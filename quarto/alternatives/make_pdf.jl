module Make

# makefile for generating typst pdfs
# per directory usage

dir = "alternatives"
files = (
    "symbolics",
    "SciML",
    "plotly_plotting",
    "makie_plotting",

)

include("../_make_pdf.jl")

main()
end
