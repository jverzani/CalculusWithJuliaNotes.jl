## Modified from
## https://github.com/SciML/SciMLTutorials.jl/blob/master/src/SciMLTutorials.jl

using CalculusWithJulia
import Pluto
using Weave

using Pkg
using SHA
using TOML


const repo_directory = joinpath(@__DIR__,"..")
const cache_file = joinpath(@__DIR__, "build_cache.toml")
const build_dir = joinpath(@__DIR__, "build")

sha(s::IO) = bytes2hex(sha256(s))
sha(path::AbstractString) = open(path, "r") do io
    sha(io)
end

read_cache() = TOML.parsefile(cache_file)
write_cache(D) =
    open(cache_file, "w") do io
        for (k,v) ∈ D
            println(io, k, " = ", "\"$v\"")
        end
    end

function write_sha(folder, file)
    file = replace(file, r"\.jmd$"=>"")
    key = join((folder, file), "_")
    jmd_sha = sha(jmd_file(folder, file))
    # may need to block!
    D = read_cache()
    D[key] = jmd_sha
    write_cache(D)
end

# build file check sha in cache
jmd_file(folder, file) = joinpath(repo_directory, "CwJ", folder, file)

# should we build this file?
function build_fileq(folder, file; force=true)
    force && return force

    key = join((folder, file), "_")
    D = read_cache()

    jmd_sha = sha(jmd_file(folder, file))
    cache_sha = get(D, key, nothing)
    Δ = jmd_sha != cache_sha
    return Δ
end

## ----

function build_toc(force=true)
    @info "building table of contents"

    jmd_dir = joinpath(repo_directory, "CwJ", "misc")
    build_dir = joinpath(@__DIR__, "build")
    isdir(build_dir) || mkpath(build_dir)

    file = joinpath(jmd_dir, "toc.jmd")

    outfile = joinpath(build_dir, "index.html")

    cd(jmd_dir)

    build_fileq(file, outfile, force=force) || return nothing
    header = CalculusWithJulia.WeaveSupport.header_cmd
    #footer = CalculusWithJulia.WeaveSupport.footer_cmd(bnm, folder)
    html_content = md2html(file,
                           header_cmds=(header,),
                           footer_cmds=()
                           )

    open(outfile, "w") do io
        write(io, html_content)
    end

    # to use weave, not pluto
    # weave(file;
    #       out_path=outfile,
    #       doctype="md2html",
    #       fig_ext=".svg",
    #       template=htmlfile,
    #       fig_path=tempdir())
end


# do we build the file check mtime
# function build_file(jmdfile, outfile; force=false)

#     force && return true
#     !isfile(outfile) && return true
#     mtime(outfile) < mtime(jmdfile) && return true
#     return false
# end

# build pluto html
# file **has**  ".jmd" extension
function build_file(folder, file, force)
    ## use jmd -> pluto notebook -> generate_html
    @info "Building HTML: $file"

    occursin(r"\.jmd$", file) || (file *=  ".jmd")

    o = build_fileq(folder, file, force=force)
    o || return false

    bnm = replace(file, r"\.jmd$"=>"")

    jmd_dir = joinpath(repo_directory, "CwJ", folder)
    cd(jmd_dir)

    dir = joinpath(build_dir, folder)
    isdir(dir) || mkpath(dir)

    ext = ".html"
    outfile = joinpath(build_dir, folder, bnm*ext)




    header = CalculusWithJulia.WeaveSupport.header_cmd
    footer = CalculusWithJulia.WeaveSupport.footer_cmd(bnm, folder)
    html_content = md2html(jmd_file(folder, file),
                           header_cmds=(header,),
                           footer_cmds=(footer,)
                           )

    open(outfile, "w") do io
        write(io, html_content)
    end

    write_sha(folder, file)
end


# what to build
function build_all(force)
    folders = readdir(joinpath(repo_directory,"CwJ"))
    folders = filter(F -> isdir(joinpath(repo_directory, "CwJ", F)), folders)
    asyncmap(F -> build_folder(F, force), folders)
end

function build_folder(folder, force)
    !isnothing(match(r"\.ico$", folder)) && return nothing
    files = readdir(joinpath(repo_directory,"CwJ",folder))
    files = filter(f -> occursin(r".jmd$", basename(f)), files)
    asyncmap(file -> build_file(folder, file, force), files)

end

function build_pages(folder=nothing, file=nothing, target=:html, force=false)
    if folder == nothing
        build_all(force)
    elseif file == nothing
        build_folder(folder, force)
    else
        # build file in folder
        build_file(folder, file, force)
    end
end

# ## --------------------------------------------------
# ##  Build more generally, but not use right now
# const cssfile =   joinpath(@__DIR__, "..", "templates", "skeleton_css.css")
# const htmlfile =  joinpath(@__DIR__, "..", "templates", "bootstrap.tpl")
# const latexfile = joinpath(@__DIR__, "..", "templates", "julia_tex.tpl")


# # build list ⊂ (:script,:html,:weave_html, :pdf,:github,:notebook,:pluto)
# function weave_file(folder, file; build_list=(:html,), force=false, kwargs...)

#     jmd_dir = isdir(folder) ? folder : joinpath(repo_directory, "CwJ", folder)
#     jmd_file = joinpath(jmd_dir, file)
#     bnm = replace(basename(jmd_file), r".jmd$" => "")
#     build_dir = joinpath(@__DIR__, "build")
#     isdir(build_dir) || mkpath(build_dir)

#     if !force
#         #testfile = joinpath(repo_directory, "html", folder, bnm*".html")
#         testfile = joinpath(build_dir, folder, bnm*".html")
#         if isfile(testfile) && (mtime(testfile) >= mtime(tmp))
#             return
#         end
#         force=true
#     end


#     Pkg.activate(dirname(jmd_dir))
#     Pkg.instantiate()
#     args = Dict{Symbol,String}(:folder=>folder,:file=>file)

#     if :script ∈ build_list
#         println("Building Script")
#         dir = joinpath(repo_directory,"script",folder)
#         isdir(dir) || mkpath(dir)

#         ext = ".jl"
#         outfile = joinpath(dir, bnm*ext)
#         build_file(file, outfile, force=force) || return nothing

#         args[:doctype] = "script"
#         tangle(tmp;out_path=dir)
#     end

#     # use Pluto to build html pages
#     if :html ∈ build_list
#         ## use jmd -> pluto notebook -> generate_html
#         println("Building HTML: $file")
#         cd(jmd_dir)

#         dir = joinpath(build_dir, folder)
#         isdir(dir) || mkpath(dir)

#         ext = ".html"
#         outfile = joinpath(dir, bnm*ext)
#         o = build_file(file, outfile, force=force)
#         o || return nothing

#         header = CalculusWithJulia.WeaveSupport.header_cmd
#         footer = CalculusWithJulia.WeaveSupport.footer_cmd(bnm, folder)
#         html_content = md2html(file,
#                                header_cmds=(header,),
#                                footer_cmds=(footer,)
#                                )

#         open(outfile, "w") do io
#             write(io, html_content)
#         end

#     end

#     ## old html generation
#     if :weave_html ∈ build_list
#         println("Building HTML for $file")
#         dir = joinpath(build_dir, folder)
#         isdir(dir) || mkpath(dir)

#         figdir = joinpath(jmd_dir,"figures")
#         htmlfigdir = joinpath(dir, "figures")

#         if isdir(figdir)
#             isdir(htmlfigdir) && rm(htmlfigdir, recursive=true)
#             cp(figdir, htmlfigdir)
#         end

#         ext = ".html"
#         outfile = joinpath(dir, bnm*ext)
#         build_file(file, outfile, force=force) || return nothing


#         Weave.set_chunk_defaults!(:wrap=>false)
#         args[:doctype] = "html"



#         # override printing for Polynomials, SymPy with weave
#         𝐦 = Core.eval(@__MODULE__, :(module $(gensym(:WeaveHTMLTestModule)) end))
#         Core.eval(𝐦, quote
# using SymPy, Polynomials
# function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: SymPy.SymbolicObject}
#     #write(io, "<div class=\"well well-sm\">")
#     write(io, "<div class=\"output\">")
#     show(io, "text/latex", x)
#     write(io, "</div>")
# end

# function Base.show(io::IO, ::MIME"text/html", x::Array{T}) where {T <: SymPy.SymbolicObject}
#     #write(io, "<div class=\"well well-sm\">")
#     write(io, "<div class=\"output\">")
#     show(io, "text/latex", x)
#     write(io, "</div>")
# end

# function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: Polynomials.AbstractPolynomial}
# #     #write(io, "<div class=\"well well-sm\">")
#      write(io, "<div class=\"output\">")
#      show(io, "text/latex", x)
#      write(io, "</div>")
# end

#                   end)

#         #weave(tmp,doctype = "md2html",out_path=dir,args=args; fig_ext=".svg", css=cssfile, kwargs...)
#         weave(tmp;
#               doctype = "md2html",
#               out_path=dir,
#               mod = 𝐦,
#               args=args,
#               fig_ext=".svg",
#               template=htmlfile,
#               fig_path=tempdir(),
#               kwargs...)

#         # clean up
#         isdir(htmlfigdir) && rm(htmlfigdir, recursive=true)

#     end

#     if :pdf ∈ build_list

#         eval(quote using Tectonic end) # load Tectonic; wierd testing error

#         println("Building PDF")
#         dir = joinpath(repo_directory,"pdf",folder)
#         isdir(dir) || mkpath(dir)

#         ext = ".pdf"
#         outfile = joinpath(dir, bnm*ext)
#         build_file(file, outfile, force=force) || return nothing



#         fig_path = "_figures_" * bnm
#         figdir = joinpath(jmd_dir,"figures")
#         texfigdir = joinpath(dir, "figures")

#         if isdir(figdir)
#             isdir(texfigdir) && rm(texfigdir, recursive=true)
#             cp(figdir, texfigdir)
#         end

#         args[:doctype] = "pdf"
#         try
#             weave(tmp,doctype="md2tex",out_path=dir,args=args;
#                   template=latexfile,
#                   fig_path=fig_path,
#                   kwargs...)

#             texfile = joinpath(dir, bnm * ".tex")
#             Base.invokelatest(Tectonic.tectonic, bin -> run(`$bin $texfile`))


#             # clean up
#             for ext in (".tex",)
#                 f = joinpath(dir, bnm * ext)
#                 isfile(f) && rm(f)
#             end

#         catch ex
#             @warn "PDF generation failed" exception=(ex, catch_backtrace())

#         end

#         isdir(texfigdir) && rm(texfigdir, recursive=true)
#         isdir(joinpath(dir,fig_path)) && rm(joinpath(dir,fig_path), recursive=true)
#         for ext in (".aux", ".log", ".out")
#             f = joinpath(dir, bnm * ext)
#             isfile(f) && rm(f)
#         end

#     end

#     if :github ∈ build_list
#         println("Building Github Markdown")
#         dir = joinpath(repo_directory,"markdown",folder)
#         isdir(dir) || mkpath(dir)


#         ext = ".md"
#         outfile = joinpath(dir, bnm*ext)
#         build_file(file, outfile, force=force) || return nothing

#         args[:doctype] = "github"
#         weave(tmp,doctype = "github",out_path=dir, args=args;
#               fig_path=tempdir(),
#               kwargs...)
#     end

#     if :notebook ∈ build_list
#         println("Building Notebook")
#         dir = joinpath(repo_directory,"notebook",folder)
#         isdir(dir) || mkpath(dir)

#         ext = ".ipynb"
#         outfile = joinpath(dir, bnm*ext)
#         build_file(file, outfile, force=force) || return nothing

#         args[:doctype] = "notebook"
#         Weave.convert_doc(tmp,outfile)
#     end

#     if :pluto ∈ build_list
#         println("Building Pluto notebook")
#         dir = joinpath(repo_directory,"pluto",folder)
#         isdir(dir) || mkpath(dir)


#         ext = ".jl"
#         outfile = joinpath(dir, bnm*ext)
#         build_file(file, outfile, force=force) || return nothing

#         md2jl(file, outfile)
#     end

# end

# """
#     weave_all(; force=false, build_list=(:script,:html,:pdf,:github,:notebook))

# Run `weave` on all source files.

# * `force`: by default, only run `weave` on files with `html` file older than the source file in `CwJ`
# * `build_list`: list of output types to be built. The default is all types

# The files will be built as subdirectories in the package directory. This is returned by `pathof(CalculusWithJulia)`.

# """
# function weave_all(;force=false, build_list=(:script,:html,:pdf,:github,:notebook))
#     folders = readdir(joinpath(repo_directory,"CwJ"))
#     folders = filter(F -> isdir(joinpath(repo_directory, "CwJ", F)), folders)
#     asyncmap(F -> weave_folder(F; force=force, build_list=build_list), folders)
# #    for folder in readdir(joinpath(repo_directory,"CwJ"))
# #        folder == "test.jmd" && continue
# #        weave_folder(folder; force=force, build_list=build_list)
# #    end
# end

# function weave_folder(folder; force=false, build_list=(:html,))
#     !isnothing(match(r"\.ico$", folder)) && return nothing
#     files = readdir(joinpath(repo_directory,"CwJ",folder))
#     files = filter(f -> occursin(r".jmd$", basename(f)), files)
#     asyncmap(file -> weave_file(folder, file; force=force, build_list=build_list), files)
#     # for file in readdir(joinpath(repo_directory,"CwJ",folder))
#     #     !occursin(r".jmd$", basename(file)) && continue
#     #     println("Building $(joinpath(folder,file))")
#     #     try
#     #         weave_file(folder,file; force=force, build_list=build_list)
#     #     catch
#     #     end
#     # end
# end
