module Main
# makefile for generating typst pdfs
# per directory usage

dir = "ODEs"
files = (
    "odes",
    "euler",
    "solve",
    "differential_equations"

)
include("../_make_pdf.jl")

main()
end
