module Make
# makefile for generating typst pdfs
# per directory usage
dir = "misc"
files = (
        "getting_started_with_julia",
        "julia_interfaces",
        "calculus_with_julia",
        "unicode",
        "quick_notes",
         )

include("../_make_pdf.jl")

main()
end
