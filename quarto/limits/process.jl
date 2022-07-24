using CwJWeaveTpl

fnames = [
          "limits",
          "limits_extensions",
          #
          "continuity",
          "intermediate_value_theorem"
          ]


process_file(nm; cache=:off) = CwJWeaveTpl.mmd(nm * ".jmd", cache=cache)

function process_files(;cache=:user)
    for f in fnames
        @show f
        process_file(f, cache=cache)
    end
end



"""
## TODO limits

"""
