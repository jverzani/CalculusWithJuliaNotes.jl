module Make
# makefile for generating typst pdfs
# per directory usage

dir = "integral_vector_calculus"
files = (
    "double_triple_integrals",
    "line_integrals",
    "div_grad_curl",
    "stokes_theorem",
    "review",
)

include("../_make_pdf.jl")

main()
end
