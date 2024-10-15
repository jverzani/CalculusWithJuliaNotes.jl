# make pdf files
# should run in each director julia make.jl

using PDFmerger

dirs = (
    "precalc",
    "limits",
    "derivatives",
    "integrals",
    "ODEs",
    "differentiable_vector_calculus",
    "integral_vector_calculus",
    "alternatives",
    "misc"
)

function (@main)(args...)
    @info "Making index pages"
    run(`quarto render _pdf_index.qmd --to typst`)
    for d in dirs
        cd(d)
        @info "Making files in $d"
        include("make_pdf.jl")
        cd("..")
    end

    @info "Stitch together pdfs"
    pieces = ["_pdf_index.pdf"]
    append!(pieces, dirs .* "/_pdf_index.pdf")
    merge_pdfs(pieces, "CalculusWithJulia.pdf")
end
