## Header and footer code
## includes log and table of contents

# keep up to date with misc/toc.jmd
table_of_contents = [
    :precalc		:calculator;
    :precalc		:variables;
    :precalc		:numbers_types;
    :precalc		:logical_expressions;
    :precalc		:vectors;
    :precalc		:ranges;
    :precalc		:functions;
    :precalc		:plotting;
    :precalc		:transformations;
    :precalc		:inversefunctions;
    :precalc		:polynomial;
    :precalc		:polynomial_roots;
    :precalc		:polynomials_package;
    :precalc		:rational_functions;
    :precalc		:exp_log_functions;
    :precalc		:trig_functions;
    :precalc            :julia_overview;

    :limits		:limits;
    :limits		:limits_extensions;
    :limits		:continuity;
    :limits		:intermediate_value_theorem;

    :derivatives		:derivatives;
    :derivatives		:numeric_derivatives;
    :derivatives		:symbolic_derivatives;
    :derivatives		:mean_value_theorem;
    :derivatives		:optimization;
    :derivatives		:first_second_derivatives;
    :derivatives		:curve_sketching;
    :derivatives		:linearization;
    :derivatives		:newtons_method;
    :derivatives		:more_zeros;
    :derivatives		:lhospitals_rule;
    :derivatives		:implicit_differentiation;
    :derivatives		:related_rates;
    :derivatives		:taylor_series_polynomials;


    :integrals		:area;
    :integrals		:ftc;
    :integrals		:substitution;
    :integrals		:integration_by_parts;
    :integrals		:partial_fractions;
    :integrals		:improper_integrals;
    :integrals		:mean_value_theorem;
    :integrals		:area_between_curves;
    :integrals		:center_of_mass;
    :integrals		:volumes_slice;
    :integrals		:arc_length;
    :integrals		:surface_area;

    :ODEs		:odes;
    :ODEs		:euler;
    :ODEs		:solve;
    :ODEs		:differential_equations;

    :differentiable_vector_calculus		:polar_coordinates;
    :differentiable_vector_calculus		:vectors;
    :differentiable_vector_calculus		:vector_valued_functions;
    :differentiable_vector_calculus		:scalar_functions;
    :differentiable_vector_calculus		:scalar_functions_applications;
    :differentiable_vector_calculus		:vector_fields;
    :differentiable_vector_calculus		:plots_plotting;
    :alternatives		:makie_plotting;
    :alternatives		:plotly_plotting;

    :integral_vector_calculus		:double_triple_integrals;
    :integral_vector_calculus		:line_integrals;
    :integral_vector_calculus		:div_grad_curl;
    :integral_vector_calculus		:stokes_theorem;
    :integral_vector_calculus		:review;

    :alternatives   :symbolics;
    :misc           :getting_started_with_julia
    :misc           :bibliography;
    :misc           :quick_notes;
    :misc           :julia_interfaces;
    :misc           :calculus_with_julia;
    :misc           :unicode
]

struct Logo
    width::Int
end
Logo() = Logo(120)

const logo_url = "https://raw.githubusercontent.com/jverzani/CalculusWithJuliaNotes.jl/master/CwJ/misc/logo.png"

function Base.show(io::IO, ::MIME"text/html", l::Logo)
    show(io, "text/html", Markdown.HTML("""
<img src="$(logo_url)" alt="Calculus with Julia" width="$(l.width)" />
"""))
end



header_cmd =  """
HTML(\"\"\"
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="$(logo_url)" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
\"\"\")
"""



"""
    Footer(:file, :directory)

Footer object for HTML display
"""
struct Footer
    f
    d
end

# create footer from basename of file, folder name
function footer_cmd(bnm, folder)
    f = Footer(Symbol(bnm), Symbol(folder))
    out = sprint(io -> show(io, "text/html", f))
    "HTML(\"\"\"$(out)\"\"\")"
end


# compute from URL
file_dir(f::Symbol,d::Symbol) = (f,d)
function file_dir(f, d)
    f = Symbol(last(split(foot.f, "/"))[1:end-4])
    d = Symbol(split(foot.d, "/")[end])
    f,d
end

function previous_current_next(foot::Footer)
    f₀, d₀ = file_dir(foot.f, foot.d)

    toc_url = "../index.html"
    suggest_url = "https://github.com/jverzani/CalculusWithJuliaNotes.jl/edit/master/CwJ/$(d₀)/$(f₀).jmd"

    prev_url = "https://calculuswithjulia.github.io"
    next_url = "https://calculuswithjulia.github.io"

    prev,nxt = prev_next(d₀, f₀)

    if prev != nothing
        d,f = prev
        prev_url = "../$(d)/$(f).html"
    end

    if nxt != nothing
        d,f = nxt
        next_url = "../$(d)/$(f).html"
    end

    (base_url="https://calculuswithjulia.github.io",
     toc_url=toc_url,
     prev_url=prev_url,
     next_url = next_url,
     suggest_edit_url = suggest_url
     )
end

function Base.show(io::IO, ::MIME"text/html", x::Footer)
    home, toc, prev, next, suggest = previous_current_next(x)
    show(io, "text/html", Markdown.parse("""
>  [◅ previous]($prev)  [▻  next]($next)  [⌂ table of contents]($toc)  [✏ suggest an edit]($suggest)
"""))
end


# return :d,:f for previous and next
function prev_next(d,f)
    vals = [table_of_contents[i,:] for i ∈ 1:size(table_of_contents,1)]
    val = [d,f]
    i = findfirst(Ref(val,) .== vals)
    i == nothing && error(val)
    i == 1 && return (prev=nothing, next=vals[2])
    i == length(vals) && return (prev=vals[end-1], next=nothing)
    return (prev=vals[i-1], next=vals[i+1])
end
