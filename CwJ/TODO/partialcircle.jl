plot([0,1,1,0], [0,0,1,0], aspect_ratio=:equal, legend=false)
    plot!(Plots.partialcircle(0, pi/4,100, 0.25), arrow=true)
	Δ = 0.05
	plot!([1-Δ, 1-Δ, 1], [0,Δ,Δ])
