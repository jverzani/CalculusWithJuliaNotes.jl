module Make
# makefile for generating typst pdfs
# per directory usage

dir = "derivatives"
files = (
    "derivatives",
    "numeric_derivatives",
    "symbolic_derivatives",
    "mean_value_theorem",
    "optimization",
    "first_second_derivatives",
    "curve_sketching",
    "linearization",
    "newtons_method",
    "more_zeros",
    "lhospitals_rule",
    "implicit_differentiation",
    "related_rates",
    "taylor_series_polynomials",
)

include("../_make_pdf.jl")
main()
end
