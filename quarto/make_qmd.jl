# create qmd files from jmd files
# julia make_qmd.jl
include("jmd2qmd.jl")

DIRS = ("precalc",
        "limits",
        "derivatives",
        "integrals",
        "ODEs",
        "differentiable_vector_calculus",
        "integral_vector_calculus",
        "alternatives",
        "misc"
        )

# look over CwJ directory and
# * move .jmd files to .qmd files
# * move figures to figures
# * move .toml to .toml
for DIR ∈ DIRS
    mkpath(DIR)
    dir = joinpath("../CwJ/", DIR)
    for f ∈ readdir(dir)
        F = joinpath(dir, f)
        if f == "figures"
            mkpath(joinpath(DIR, f))
            for fig ∈ readdir(joinpath(dir,f))
                try
                    cp(joinpath(dir,f,fig), joinpath(DIR,f,fig))
                catch err
                end
            end
        elseif isdir(F)
            continue
        else
            fnm, ext = splitext(f)
            if ext == ".jmd"
                qmd_file = joinpath(DIR, fnm * ".qmd")
                jmd_file = joinpath(dir, f)
                if true || mtime(jmd_file) > mtime(qmd_file)
                    open(qmd_file, "w") do io
                        jmd2qmd(io, jmd_file)
                    end
                end
            else
                _, ext = splitext(f)
                ext == ".toml" && continue
                f == "process.jl" && continueg
                @show :cp, f
                try
                    force = isfile(joinpath(DIR, f))
                    cp(joinpath(dir,f), joinpath(DIR,f), force=force)
                catch err
                end
            end
        end
    end
end
