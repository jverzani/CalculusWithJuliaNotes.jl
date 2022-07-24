using WeavePynb

using CwJWeaveTpl



fnames = [
          "derivatives", ## more questions
          "numeric_derivatives",

          "mean_value_theorem",
          "optimization",
          "curve_sketching",

          "linearization",
          "newtons_method",
          "lhopitals_rule",  ## Okay - -but could beef up questions..


          "implicit_differentiation", ## add more questions?
          "related_rates",
          "taylor_series_polynomials"
]


process_file(nm; cache=:off) = CwJWeaveTpl.mmd(nm * ".jmd", cache=cache)

function process_files(;cache=:user)
    for f in fnames
        @show f
        process_file(f, cache=cache)
    end
end




"""
## TODO derivatives

tangent lines intersect at avearge for a parabola

Should we have derivative results: inverse functions, logarithmic differentiation...
"""
