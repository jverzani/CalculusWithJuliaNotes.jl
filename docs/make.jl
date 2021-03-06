using Documenter
using ArgParse

using CalculusWithJuliaNotes


include("weave-support.jl")
include("markdown-to-pluto.jl")

## The command line gathers
## folder[=nothing], file[=nothing], target[=html], force[=false]
function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--folder", "-F"
        help = "Input folder name"
        default = nothing
        "--file", "-f"
        help = "Input file name"
        default = nothing
        "--target", "-o"
        help="target type: html, weave_html, ipynb, "
        default = "html"
        "--force"
        help = "Force compliation"
        default = "false"
    end

    return parse_args(s)
end


# build pages
d = parse_commandline()
folder, file = d["folder"], d["file"]
target = Symbol(d["target"])
force = parse(Bool, d["force"])


if isnothing(folder) && isnothing(file)
    build_pages(nothing, nothing, :html, force)
    build_toc()
else
    build_pages(folder, file, :html, force)
end

build_deploy()




# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
Documenter.deploydocs(;
    repo = "github.com/jverzani/CalculusWithJuliaNotes.jl",
    push_preview=true
)
