using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

using QuadGK

function riemann(f::Function, a::Real, b::Real, n::Int; method="right")
    if method == "right"
        meth = f -> (lr -> begin l,r = lr; f(r) * (r-l) end)
    elseif method == "left"
        meth = f -> (lr -> begin l,r = lr; f(l) * (r-l) end)
    elseif method == "trapezoid"
        meth = f -> (lr -> begin l,r = lr; (1/2) * (f(l) + f(r)) * (r-l) end)
    elseif method == "simpsons"
        meth = f -> (lr -> begin l,r=lr; (1/6) * (f(l) + 4*(f((l+r)/2)) + f(r)) * (r-l) end)
    end

    xs = a .+ (0:n) * (b-a)/n

    sum(meth(f), zip(xs[1:end-1], xs[2:end]))
end


"""
    integration(f)

Show graphically the left Riemann approximation, the trapezoid approximation, and Simpson's approximation to the integral of `f` over [-1,1].

Assumes `f` is non-negative.
"""
function integration(f=nothing)
    if f == nothing
        f = x -> x^2*exp(-x/3)
    end

    a, b = -1, 1


function left_riemann_pts(n)
    xs = range(a, b, length=n+1)
    pts = Point2f0[(xs[1], 0)]
    for i in 1:n
        xᵢ, xᵢ₊₁ = xs[i], xs[i+1]
        fᵢ = f(xᵢ)
        push!(pts, (xᵢ, fᵢ))
        push!(pts, (xᵢ₊₁, fᵢ))
    end
    push!(pts, (xs[end], 0))
    pts
end
        

function trapezoid_pts(n)
    xs = range(a, b, length=n+1)
    pts = Point2f0[(xs[1], 0)]
    for i in 1:n
        xᵢ, xᵢ₊₁ = xs[i], xs[i+1]
        fᵢ = f(xᵢ)
        push!(pts, (xᵢ, f(xᵢ)))
    end
    push!(pts, (xs[end], f(xs[end])))
    push!(pts, (xs[end], 0))
    pts
end

function simpsons_pts(n)
    xs = range(a, b, length=n+1)
    pts = Point2f0[(xs[1], 0), (xs[1], f(xs[1]))]
    
    for i in 1:n
        xi, xi1 = xs[i], xs[i+1]
        m = xi/2 + xi1/2
        p = x -> f(xi)*(x-m)*(x - xi1)/(xi-m)/(xi-xi1) + f(m) * (x-xi)*(x-xi1)/(m-xi)/(m-xi1) + f(xi1) * (x-xi)*(x-m) / (xi1-xi) / (xi1-m)

        xs′ = range(xi, xi1, length=10)
        for j in 2:10
            x = xs′[j]
            push!(pts, (x, p(x)))
        end
    end
    push!(pts, (xs[end], 0))
    pts
end


# where we lay our scene:
scene, layout = layoutscene()
layout.halign = :left
layout.valign = :top


p1 = layout[1,1] = LScene(scene)
p2 = layout[1,2] = LScene(scene)
p3 = layout[1,3] = LScene(scene)

n = layout[2,1] = LSlider(scene, range=2:25, startvalue=2)
output = layout[2, 2:3] = LText(scene, "...")

lpts = lift(n.value) do n
    left_riemann_pts(n)
end

poly!(p1.scene, lpts, color=:gray75)
lines!(p1.scene, a..b, f, color=:black, strokewidth=10)
title(p1.scene, "Left Riemann")


tpts = lift(n.value) do n
    trapezoid_pts(n)
end
poly!(p2.scene, tpts, color=:gray75)
lines!(p2.scene, a..b, f, color=:black, strokewidth=10)
title(p2.scene, "Trapezoid")

spts = lift(n.value) do n
    simpsons_pts(n)
end
poly!(p3.scene, spts, color=:gray75)
lines!(p3.scene, a..b, f, color=:black, strokewidth=10)
title(p3.scene, "Simpson's")

on(n.value) do n
    actual,err = quadgk(f, -1, 1)
    lrr  = riemann(f, -1, 1, n, method="left")
    trap = riemann(f, -1, 1, n, method="trapezoid")
    simp = riemann(f, -1, 1, n, method="simpsons")

    Δleft = round(abs(lrr - actual), digits=8)
    Δtrap = round(abs(trap - actual), digits=8)
    Δsimp = round(abs(simp - actual), digits=8)

    txt = "Riemann: $Δleft, Trapezoid: $Δtrap, Simpson's: $Δsimp"
    output.text[] = txt
end
n.value[] = n.value[]





scene
end
