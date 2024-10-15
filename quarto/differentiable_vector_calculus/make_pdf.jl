module Make
# makefile for generating typst pdfs
# per directory usage
dir = "differentiable_vector_calculus"
files = (
    "polar_coordinates",
    "vectors",
    "vector_valued_functions",
    "scalar_functions",
    "scalar_functions_applications",
    "vector_fields",
    "plots_plotting",
)

include("../_make_pdf.jl")

main()
end
