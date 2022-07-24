using Markdown

## override HTML esc of strings
Markdown.htmlinline(io::IO, md::AbstractString) = write(io, md)

Base.show(io::IO, ::MIME"text/qmd", content) = Markdown.plain(io, content)

## Hacky way to set *global* values for rendering
## Expects title to be very first thing in a jmd file
## Proper way would be to use https://quarto.org/docs/extensions/nbfilter.html
function inject_code(io::IO)
    println(io, """
```{julia}
#| echo: false

import Logging
Logging.disable_logging(Logging.Info) # or e.g. Logging.Info
Logging.disable_logging(Logging.Warn)

import SymPy
function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: SymPy.SymbolicObject}
    println(io, "<span class=\\"math-left-align\\" style=\\"padding-left: 4px; width:0; float:left;\\"> ")
    println(io, "\\\\[")
    println(io, sympy.latex(x))
    println(io, "\\\\]")
    println(io, "</span>")
end

# hack to work around issue
import Markdown
import CalculusWithJulia
function CalculusWithJulia.WeaveSupport.ImageFile(d::Symbol, f::AbstractString, caption; kwargs...)
    nm = joinpath("..", string(d), f)
    u = "![\$caption](\$nm)"
    Markdown.parse(u)
end

nothing
```
""")
end

## Main function to take a jmd file and turn into an HTML
function markdownToHTML(fname::AbstractString; TITLE="", kwargs...)

    dirnm, basenm = dirname(fname), basename(fname)
    newnm = replace(fname, r"[.].*" => ".html")
    out = jmd2qmd(fname; TITLE=TITLE, kwargs...)

    io = open(newnm, "w")
    write(io, out)
    close(io)
end


"""
    jmd2qmd(io, jmd_file)

Convert `.jmd` file in `jmd_file` to a `.qmd` file, write output to `io`.

## Rationale

`.jmd` files have a slightly different Markdown syntax than expected by `.qmd` files. In particular:

* code blocks use comments at the top of the file to add features like `echo=false`
* admonitions use "callout" syntax
* LaTeX uses dollar signs for delimeters, not double back tics or a `math` block

"""
function jmd2qmd(io::IO, jmd_file::AbstractString)
    out = Markdown.parse_file(jmd_file, flavor=Markdown.julia)

    for (i,content) in enumerate(out.content)
        i == 2 && inject_code(io) ## requires title to be *first*
        if isa(out.content[i], Markdown.Code)
            txt = content.code
            lang = content.language
            langs = filter(x -> length(x) > 0, (lstrip ∘ rstrip).(split(lang, ";")))

            if length(langs) > 0
                flavor = popfirst!(langs)
                println(io, "```{$flavor}")
                for option ∈ langs
                    k, v = split(option, "=")
                    println(io, "#| $k: $v")
                end
                println(io, txt)
                println(io, "```")
            else
                println(io, "```")
                println(io, txt)

                println(io, "```")
            end
        elseif isa(content, Markdown.LaTeX)
            println(io, '$', '$')
            println(io, content.formula)
            print(io, '$', '$')
            println(io)
        elseif isa(content, Markdown.Admonition)
            category = content.category
            if !(category ∈ ("note", "warning", "important", "tip", "caution"))
                category = "note"
            end
            println(io, ":::{.callout-$category}")
            println(io, "## $(content.title)")
            show(io, MIME("text/qmd"), content.content)
            println(io, "")
            println(io, ":::")
        else
            ## we drill down
            #Markdown.html(io, content)
            #show(io, MIME("text/qmd"), content)
            Markdown.plain(io, content)
            println(io, "")
        end
        println(io, "")
    end
end
