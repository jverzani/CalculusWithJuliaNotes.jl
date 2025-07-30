module Make
# makefile for generating typst pdfs
# per directory usage
dir = "basics"
files = ("calculator",
         "variables",
         "numbers_types",
         "logical_expressions",
         "vectors",
         "ranges",
         )

include("../_make_pdf.jl")
main()

end
