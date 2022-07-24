using Plots

# https://github.com/JuliaLang/julia-logo-graphics
blue, green, purple, red = :royalblue, :forestgreen, :mediumorchid3, :brown3


function archimedes!(p, n, xy=(0,0), radius=1; color=blue)

    x₀,y₀=xy
    ts = range(0, 2pi, length=100)

    plot!(p, x₀ .+ sin.(ts), y₀ .+ cos.(ts), linewidth=2)

    α = ((2π)/n)/2
    αs = (-pi/2 + α):2α:(3pi/2 + α)
    r = radius/cos(α)

    xs = x₀ .+ r*cos.(αs)
    ys = y₀ .+ r*sin.(αs)

    plot!(p, xs, ys,
          fill=true,
          fillcolor=color,
          alpha=0.4)

    r = radius
    xs = x₀ .+ r*cos.(αs)
    ys = y₀ .+ r*sin.(αs)

    plot!(p, xs, ys,
          fill=true,
          fillcolor=color,
          alpha=0.8)

    p
end

gr()
Δ = 2.75
p = plot(;xlims=(-Δ,Δ), ylims=(-Δ,Δ),
         axis=nothing,
         xaxis=false,
         yaxis=false,
         legend=false,
         padding = (0.0, 0.0),
         background_color = :transparent,
         foreground_color = :black,
         aspect_ratio=:equal)
archimedes!(p, 5, (-1.5, -1); color=red )
archimedes!(p, 8, (0,   1); color=green )
archimedes!(p, 13, (1.5, -1); color=purple )

savefig(p, "logo.png")
