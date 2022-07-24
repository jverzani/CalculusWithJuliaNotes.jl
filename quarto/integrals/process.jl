
fnames = [
          "area",
          "ftc",

          "substitution",
          "integration_by_parts",
          "partial_fractions", # XX add in trig integrals (cos()sin() stuff? mx or ^m... XXX
          "improper_integrals", ##

          "mean_value_theorem",
          "area_between_curves",
          "center_of_mass",
          "volumes_slice",
          #"volumes_shell", ## XXX add this in if needed, but not really that excited to now XXX
          "arc_length",
          "surface_area"
]



function process_file(nm, twice=false)
    include("$nm.jl")
    mmd_to_md("$nm.mmd")
    markdownToHTML("$nm.md")
    twice && markdownToHTML("$nm.md")
end

process_files(twice=false) = [process_file(nm, twice) for nm in fnames]




"""
## TODO integrals

* add in volumes shell???
* mean value theorem is light?
* could add surface area problems

"""
