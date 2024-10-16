module Make
# makefile for generating typst pdfs
# per directory usage

dir = "limits"
files = (
    "limits",
    "limits_extensions",
    "continuity",
    "intermediate_value_theorem",
)
include("../_make_pdf.jl")
main()
end
