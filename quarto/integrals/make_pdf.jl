module Make
# makefile for generating typst pdfs
# per directory usage

dir = "integrals"
files = (
        "area",
        "ftc",
        "substitution",
        "integration_by_parts",
        "partial_fractions",
        "improper_integrals",
        "mean_value_theorem",
        "area_between_curves",
        "center_of_mass",
        "volumes_slice",
        "arc_length",
        "surface_area",
        "twelve-qs",
)

include("../_make_pdf.jl")

main()
end
