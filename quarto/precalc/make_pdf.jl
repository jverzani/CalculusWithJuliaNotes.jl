module Make
# makefile for generating typst pdfs
# per directory usage
dir = "precalc"
files = ("functions",
         "plotting",
         "transformations",
         "inversefunctions",
         "polynomial",
         "polynomial_roots",
         "polynomials_package",
         "rational_functions",
         "exp_log_functions",
         "trig_functions",
         "julia_overview"
         )

include("../_make_pdf.jl")
main()

end
