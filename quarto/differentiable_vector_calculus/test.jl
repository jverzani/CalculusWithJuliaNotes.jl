@show 4
using QuizQuestions
using LaTeXStrings
using CalculusWithJulia
using Plots
plotly()
using SymPy
using Roots
@show 6
import Contour: contours, levels, level, lines, coordinates
@show 15
@syms f_x f_y
n = [1, 0, f_x] × [0, 1, f_y]
@show 27
#| hold: true
f(x,y) = 6 - x^2 -y^2
f(x)= f(x...)

a,b = 1, -1/2


# draw surface
xr = 7/4
xs = ys = range(-xr, xr, length=100)
surface(xs, ys, f, legend=false)

# visualize tangent plane as 3d polygon
pt = [a,b]
tplane(x) = f(pt) + gradient(f)(pt) ⋅ (x - [a,b])

pts = [[a-1,b-1], [a+1, b-1], [a+1, b+1], [a-1, b+1], [a-1, b-1]]
plot!(unzip([[pt..., tplane(pt)] for pt in pts])...)

# plot paths in x and y direction through (a,b)
γ_x(t) = pt + t*[1,0]
γ_y(t) = pt + t*[0,1]

plot_parametric!((-xr-a)..(xr-a), t -> [γ_x(t)..., (f∘γ_x)(t)],  linewidth=3)
plot_parametric!((-xr-b)..(xr-b), t -> [γ_y(t)..., (f∘γ_y)(t)],  linewidth=3)

# draw directional derivatives in 3d and normal
pt = [a, b, f(a,b)]
fx, fy = gradient(f)(a,b)
arrow!(pt, [1, 0, fx], linewidth=3)
arrow!(pt, [0, 1, fy], linewidth=3)
arrow!(pt, [-fx, -fy, 1], linewidth=3) # normal

# draw point in base, x-y, plane
pt = [a, b, 0]
scatter!(unzip([pt])...)
arrow!(pt, [1,0,0], linestyle=:dash)
arrow!(pt, [0,1,0], linestyle=:dash)
@show 33
function tangent_plane_1st_crack(f, pt)
  fx, fy = ForwardDiff.gradient(f, pt)
  x -> f(x...) + fx * (x[1]-pt[1]) + fy * (x[2]-pt[2])
end
@show 35
function tangent_plane(f, pt)
  ∇f = ForwardDiff.gradient(f, pt) # using a variable ∇f
  x -> f(pt) + ∇f ⋅ (x - pt)
end
@show 46
@syms x, y
@show 47
#| hold: true
f(x,y) = sin(x) * cos(x-y)
f(x) = f(x...)
vars = [x, y]

gradf = diff.(f(x,y), vars)  # or use gradient(f, vars) or ∇((f,vars))

pt = [PI/4, PI/3]
gradfa = subs.(gradf, x=>pt[1], y=>pt[2])

f(pt) + gradfa ⋅ (vars - pt)
@show 55
#| hold: true
a = 1
gamma(t) = a * [1 + cos(t), sin(t), 2sin(t/2) ]
P = gamma(1/2)
n1(x,y,z)= [2*(x-a), 2y, 0]
n2(x,y,z) = [2x,2y,2z]
n1(x) = n1(x...)
n2(x) = n2(x...)

t = 1/2
(n1(gamma(t)) × n2(gamma(t))) × gamma'(t)
@show 60
#| hold: true
a, b = 1, 3
f(x,y,z) = (x^2 + ((1+b) * y)^2 + z^2 - 1)^3 - x^2 * z^3 - a * y^2 * z^3

CalculusWithJulia.plot_implicit_surface(f, xlim=-2..2, ylim=-1..1, zlim=-1..2)
@show 71
V(r, h) = pi * r^2 * h
V(v) = V(v...)
a₁ = [1,2]
dx₁ = [0.01, 0.01]
ForwardDiff.gradient(V, a₁) ⋅ dx₁   # or use ∇(V)(a)
@show 73
V(a₁ + dx₁) - V(a₁)
@show 85
#| hold: true
f(x,y,z) = x^4 -x^3 + y^2 + z^2
f(v) = f(v...)
a, b,c = ∇(f)(2,2,2)
"$a x + $b y  + $c z = $([a,b,c] ⋅ [2,2,2])"
#@show 92
#| hold: true
@syms a b c d u v
M = [a b; c d]
B = [u, v]
M \ B .|> simplify
@show 96
#| hold: true
#| echo: false
f(x,y) = 2 - x^2 - y^2
g(x,y) = 3 - 2x^2 - (1/3)y^2
xs = ys = range(-3, stop=3, length=100)
zfs = [f(x,y) for x in xs, y in ys]
zgs = [g(x,y) for x in xs, y in ys]


ps = Any[]
pf = surface(xs, ys, f, alpha=0.5, legend=false)

for cl in levels(contours(xs, ys, zfs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pf, _xs, _ys, 0*_xs, linewidth=3, color=:blue)
    end
end


pg = surface(xs, ys, g, alpha=0.5, legend=false)
for cl in levels(contours(xs, ys, zgs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pg, _xs, _ys, 0*_xs, linewidth=3, color=:red)
    end
end

pcnt = plot(legend=false)
for cl in levels(contours(xs, ys, zfs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pcnt, _xs, _ys, linewidth=3, color=:blue)
    end
end

for cl in levels(contours(xs, ys, zgs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pcnt, _xs, _ys, linewidth=3, color=:red)
    end
end

l = @layout([a b c])
plot(pf, pg, pcnt, layout=l)
@show 106
function newton_step(f, g, xn)
    M = [ForwardDiff.gradient(f, xn)'; ForwardDiff.gradient(g, xn)']
    b = -[f(xn), g(xn)]
    Delta = M \ b
    xn + Delta
end
@show 108
𝒇(x,y) = 2 - x^2 - y^2
𝒈(x,y) = 3 - 2x^2 - (1/3)y^2
𝒇(v) = 𝒇(v...); 𝒈(v) = 𝒈(v...)
𝒙₀ = [1,1]
𝒙₁ = newton_step(𝒇, 𝒈, 𝒙₀)
@show 110
𝒇(𝒙₁), 𝒈(𝒙₁)
@show 112
𝒙₂ = newton_step(𝒇, 𝒈, 𝒙₁)
𝒙₃ = newton_step(𝒇, 𝒈, 𝒙₂)
𝒙₄ = newton_step(𝒇, 𝒈, 𝒙₃)
𝒙₅ = newton_step(𝒇, 𝒈, 𝒙₄)
𝒙₅, 𝒇(𝒙₅), 𝒈(𝒙₅)
@show 116
function nm(f, g, x, n=5)
    for i in 1:n
      x = newton_step(f, g, x)
    end
    x
end
@show 123
#| hold: true
c = 1/2
f(x,y) = 1 - y^2 - c^2
g(x,y) = (1 - x^2) - c^2
f(v) = f(v...); g(v) = g(v...)
nm(f, g, [1/2, 1/3])
@show 148
#| hold: true
@syms x, y, Z()
∂x = solve(diff(x^4 -x^3 + y^2 + Z(x,y)^2, x), diff(Z(x,y),x))
∂y = solve(diff(x^4 -x^3 + y^2 + Z(x,y)^2, y), diff(Z(x,y),y))
∂x, ∂y
@show 158
f(x, p) = cos(x) - p*x
p = 2
xᵅ = find_zero(f, (0, pi/2), p)
@show 160
p = 2
xᵅ =  find_zero(f, (0, pi/2), p)
fₓ = ForwardDiff.derivative(x -> f(x,p), xᵅ)
fₚ = ForwardDiff.derivative(p -> f(xᵅ, p), p)
- fₚ / fₓ
@show 163
function find_zero_derivative(f, x₀, p)
    xᵅ =  find_zero(f, x₀, p)
    fₓ = ForwardDiff.derivative(x -> f(x,p), xᵅ)
    fₚ = ForwardDiff.derivative(p -> f(xᵅ, p), p)
    - fₚ / fₓ
end
F(p) = find_zero_derivative(f, (0, pi/2), p)
plot(F, 0.01, 5)  # p > 0
@show 183
#| hold: true
f(x,y)= exp(-(x^2 + y^2)/5) * cos(x^2 + y^2)
xs = ys = range(-4, 4, length=100)
surface(xs, ys, f, legend=false)
@show 190
#| hold: true
f(x,y) = x*y
xs = ys = range(-3, 3, length=100)
surface(xs, ys, f, legend=false)

plot_parametric!(-4..4, t -> [t, 0, f(t, 0)], linewidth=5)
plot_parametric!(-4..4, t -> [0, t, f(0, t)], linewidth=5)
@show 203
fₖ(x,y) =  exp(-(x^2 + y^2)/5) * cos(x^2 + y^2)
Hₖ = sympy.hessian(fₖ(x,y), (x,y))
@show 205
H₀₀ = subs.(Hₖ, x=>0, y=>0)
@show 207
H₀₀[1,1] < 0 && det(H₀₀) > 0
@show 209
#| hold: true
gradfₖ = diff.(fₖ(x,y), [x,y])
a = [sqrt(2PI + atan(-Sym(1)//5)), 0]
subs.(gradfₖ, x => a[1], y => a[2])
@show 211
#| hold: true
a = [sqrt(PI + atan(-Sym(1)//5)), 0]
H_a = subs.(Hₖ, x => a[1], y => a[2])
det(H_a)
@show 216
fⱼ(x,y) = 4x*y - x^4 - y^4
gradfⱼ = diff.(fⱼ(x,y), [x,y])
@show 217
all_ptsⱼ = solve(gradfⱼ, [x,y])
ptsⱼ = filter(u -> all(isreal.(u)), all_ptsⱼ)
@show 219
Hⱼ = sympy.hessian(fⱼ(x,y), (x,y))
function classify(H, pt)
  Ha = subs.(H, x => pt[1], y => pt[2])
  (det=det(Ha), f_xx=Ha[1,1])
end
[classify(Hⱼ, pt) for pt in ptsⱼ]
@show 221
#| hold: true
xs = ys = range(-3/2, 3/2, length=100)
p = surface(xs, ys, fⱼ, legend=false)
for pt ∈ ptsⱼ
    scatter!(p, unzip([N.([pt...,fⱼ(pt...)])])...,
             markercolor=:black, markersize=5)  # add each pt on surface
end
p
@show 228
fₗ(x,y) = x^2 + 2y^2 - x
fₗ(v) = fₗ(v...)
gammaₗ(t) = [cos(t), sin(t)]  # traces out x^2 + y^2 = 1 over [0, 2pi]
gₗ = fₗ ∘ gammaₗ

cpsₗ = find_zeros(gₗ', 0, 2pi) # critical points of g
append!(cpsₗ, [0, 2pi])
unique!(cpsₗ)
gₗ.(cpsₗ)
@show 230
inds = [2,4]
cpsₗ[inds]
@show 232
cpsₗ[inds]/pi
@show 234
hₗ(x,y) = fₗ(x,y) * (x^2 + y^2 <= 1 ? 1 : NaN)
@show 235
#| hold: true
xs = ys = range(-1,1, length=100)
surface(xs, ys, hₗ)

ts = cpsₗ  # 2pi/3 and 4pi/3 by above
xs, ys = cos.(ts), sin.(ts)
zs = fₗ.(xs, ys)
scatter3d!(xs, ys, zs)
@show 237
#| hold: true
xs = ys = range(-1,1, length=100)
contour(xs, ys, hₗ)
@show 243
@syms x1 y1 x2 y2 x3 y3
d2(p,x) = (p[1] - x[1])^2 + (p[2]-x[2])^2
d2_1, d2_2, d2_3 = d2((x,y), (x1, y1)), d2((x,y), (x2, y2)), d2((x,y), (x3, y3))
exₛ = d2_1 + d2_2 + d2_3
@show 245
gradfₛ = diff.(exₛ, [x,y])
xstarₛ = solve(gradfₛ, [x,y])
@show 248
Hₛ = subs.(hessian(exₛ, [x,y]), x=>xstarₛ[x], y=>xstarₛ[y])
@show 259
usₛ = [[cos(t), sin(t)] for t in (0, 2pi/3, 4pi/3)]
polygon(ps) = unzip(vcat(ps, ps[1:1])) # easier way to plot a polygon

pₛ = scatter([0],[0], markersize=2, legend=false, aspect_ratio=:equal)

asₛ = (1,2,3)
plot!(polygon([a*u for (a,u) in zip(asₛ, usₛ)])...)
[arrow!([0,0], a*u, alpha=0.5) for (a,u) in zip(asₛ, usₛ)]
pₛ
@show 261
asₛ₁ = (1, -1, 3)
scatter([0],[0], markersize=2, legend=false)
psₛₗ = [a*u for (a,u) in zip(asₛ₁, usₛ)]
plot!(polygon(psₛₗ)...)
@show 263
euclid_dist(x; ps=psₛₗ) = sum(norm(x-p) for p in ps)
euclid_dist(x,y; ps=psₛₗ) = euclid_dist([x,y]; ps=ps)
@show 264
#| hold: true
xs = range(-1.5, 1.5, length=100)
ys = range(-3, 1.0, length=100)

p = plot(polygon(psₛₗ)..., linewidth=3, legend=false)
scatter!(p, unzip(psₛₗ)..., markersize=3)
contour!(p, xs, ys, euclid_dist)

# add some gradients along boundary
li(t, p1, p2) = p1 + t*(p2-p1)  # t in [0,1]
for t in range(1/100, 1/2, length=3)
    pt = li(t, psₛₗ[2], psₛₗ[3])
    arrow!(pt, ForwardDiff.gradient(euclid_dist, pt))
    pt = li(t, psₛₗ[2], psₛₗ[1])
    arrow!(pt, ForwardDiff.gradient(euclid_dist, pt))
end

p
@show 266
#| hold :  true
li(t, p1, p2) = p1 + t*(p2-p1)
p = plot(legend=false)
for i in 1:2, j in (i+1):3
  plot!(p, t -> euclid_dist(li(t, psₛₗ[i], psₛₗ[j]); ps=psₛₗ), 0, 1)
end
p
@show 280
@syms xₗₛ[1:3] yₗₛ[1:3] α β
li(x, alpha, beta) =  alpha + beta * x
d₂(alpha, beta) = sum((y - li(x, alpha, beta))^2 for (y,x) in zip(yₗₛ, xₗₛ))
d₂(α, β)
@show 282
grad_d₂ = diff.(d₂(α, β), [α, β])
@show 283
outₗₛ = solve(grad_d₂, [α, β])
@show 285
subs(outₗₛ[β], sum(xₗₛ) => 0)
@show 292
[k => subs(v, xₗₛ[1]=>1, yₗₛ[1]=>1, xₗₛ[2]=>2, yₗₛ[2]=>3,
           xₗₛ[3]=>5, yₗₛ[3]=>8) for (k,v) in outₗₛ]
@show 302
f₂(x,y) = -exp(-((x-1)^2 + 2(y-1/2)^2))
f₂(x) = f₂(x...)

xs₂ = [[0.0, 0.0]] # we store a vector
gammas₂ = [1.0]

for n in 1:5
    xn = xs₂[end]
    gamma₀ = gammas₂[end]
    xn1 = xn - gamma₀ * gradient(f₂)(xn)
    dx, dy = xn1 - xn, gradient(f₂)(xn1) - gradient(f₂)(xn)
    gamman1 = abs( (dx ⋅ dy) / (dy ⋅ dy) )

    push!(xs₂, xn1)
    push!(gammas₂, gamman1)
end

[(x, f₂(x)) for x in xs₂]
@show 304
#| hold: true
function surface_contour(xs, ys, f; offset=0)
  p = surface(xs, ys, f, legend=false, fillalpha=0.5)

  ## we add to the graphic p, then plot
  zs = [f(x,y) for x in xs, y in ys]  # reverse order for use with Contour package
  for cl in levels(contours(xs, ys, zs))
    lvl = level(cl) # the z-value of this contour level
    for line in lines(cl)
        _xs, _ys = coordinates(line) # coordinates of this line segment
        _zs = offset * _xs
        plot!(p, _xs, _ys, _zs, alpha=0.5)        # add curve on x-y plane
    end
  end
  p
end


offset = 0
us = vs = range(-1, 2, length=100)
surface_contour(us, vs, f₂, offset=offset)
pts = [[pt..., offset] for pt in xs₂]
scatter3d!(unzip(pts)...)
plot!(unzip(pts)..., linewidth=3)
@show 314
function peaks(x, y)
    z = 3 * (1 - x)^2 * exp(-x^2 - (y + 1)^2)
    z += -10 * (x / 5 - x^3 - y^5) * exp(-x^2 - y^2)
    z += -1/3 * exp(-(x+1)^2 - y^2)
    return z
end
peaks(v) = peaks(v...)
@show 315
#| hold: true
xs = range(-3, stop=3, length=100)
ys = range(-2, stop=2, length=100)
Ps = surface(xs, ys, peaks, legend=false)
Pc = contour(xs, ys, peaks, legend=false)
plot(Ps, Pc, layout=2) # combine plots
@show 319
function newton_stepₚ(f, x)
  M = ForwardDiff.hessian(f, x)
  b = ForwardDiff.gradient(f, x)
  x - M \ b
end
@show 321
xₚ = [0, 1.5]
xₚ = newton_stepₚ(peaks, xₚ)
xₚ = newton_stepₚ(peaks, xₚ)
xₚ = newton_stepₚ(peaks, xₚ)
xₚ, ForwardDiff.gradient(peaks, xₚ)
@show 323
Hₚ = ForwardDiff.hessian(peaks, xₚ)
@show 325
#| hold: true
fxx = Hₚ[1,1]
d = det(Hₚ)
fxx, d
@show 335
#| hold: true
g(x,y) = x^2 + 2y^2 -1
g(v) = g(v...)

xs = range(-3, 3, length=100)
ys = range(-1, 4, length=100)

p = plot(aspect_ratio=:equal, legend=false)
contour!(xs, ys, g, levels=[0])

gi(x) = sqrt(1/2*(1-x^2)) # solve for y in terms of x
pts = [[x, gi(x)] for x in (-3/4, -1/4, 1/4, 3/4)]

for pt in pts
  arrow!(pt, ForwardDiff.gradient(g, pt) )
end

p
@show 338
#| hold: true
#| echo: false
r(t) = [cos(t), sin(t)/2]
plot_parametric(pi/12..pi/3, r, legend=false, aspect_ratio=true, linewidth=3)
T(t) = -r'(t) / norm(r'(t))
No(t) = T'(t) / norm(T'(t))
t = pi/4
lambda=1/10
scatter!(unzip([r(t)])...)
arrow!(r(t), T(t)*lambda)
arrow!(r(t), No(t)* lambda)

f(x,y)= x^2 + y^2
f(v) = f(v...)
arrow!(r(t), lambda*ForwardDiff.gradient(f, r(t)))

xs = range(0.5,1, length=100)
ys = range(0.1, 0.5, length=100)
contour!(xs, ys, f)
@show 344
#| hold: true
#| echo: false
r(t) = [cos(t), sin(t)/2]
plot_parametric(-pi/6..pi/6,r, legend=false, aspect_ratio=true, linewidth=3)
T(t) = -r'(t) / norm(r'(t))
No(t) = T'(t) / norm(T'(t))
t = 0
lambda=1/10
scatter!(unzip([r(t)])...)
arrow!(r(t), T(t)*lambda)
arrow!(r(t), No(t)* lambda)

f(x,y)= x^2 + y^2
f(v) = f(v...)
arrow!(r(t), lambda*ForwardDiff.gradient(f, r(t)))

xs = range(0.5,1.5, length=100)
ys = range(-0.5, 0.5, length=100)
contour!(xs, ys, f,  levels = [.7, .85, 1, 1.15, 1.3])
@show 381
@syms lambda
fₗₐ(x, y) = x^2 - y^2
gₗₐ(x, y) = x^2 + y^2
Lₗₐ(x, y, lambda) = fₗₐ(x,y) - lambda * (gₗₐ(x,y) - 1)
dsₗₐ = solve(diff.(Lₗₐ(x, y, lambda), [x, y, lambda]))
@show 383
[fₗₐ(d[x], d[y]) for d in dsₗₐ]
@show 432
#| hold: true
@syms y y′ λ C
ex = Eq(-λ*y′^2/sqrt(1 + y′^2) + λ*sqrt(1 + y′^2), y - C)
Δ = sqrt(1 + y′^2) / (y - C)
ex1 = Eq(simplify(ex.lhs()*Δ), simplify(ex.rhs() * Δ))
ex2 = Eq(ex1.lhs()^2 - 1, simplify(ex1.rhs()^2) - 1)
@show 457
@syms z lambda1 lambda2
g1(x, y, z) = x^2 + y^2 - z^2
g2(x, y, z) = x - 2z - 3
fₘ(x,y,z)= x^2 + y^2 + z^2
Lₘ(x,y,z,lambda1, lambda2) = fₘ(x,y,z) - lambda1*(g1(x,y,z) - 0) - lambda2*(g2(x,y,z) - 0)

∇Lₘ = diff.(Lₘ(x,y,z,lambda1, lambda2), [x, y, z,lambda1, lambda2])
@show 459
solve(subs.(∇Lₘ, lambda1 .=> 1))
@show 461
outₘ = solve(subs.(∇Lₘ, y .=> 0))
@show 463
[fₘ(d[x], 0, d[z]) for d in outₘ]
@show 498
struct MultiIndex
  alpha::Vector{Int}
  end
Base.show(io::IO, α::MultiIndex) = println(io, "α = ($(join(α.alpha, ", ")))")

## |α| = α_1 + ... + α_m
Base.length(α::MultiIndex) = sum(α.alpha)

## factorial(α) computes α!
Base.factorial(α::MultiIndex) = prod(factorial(Sym(a)) for a in α.alpha)

## x^α = x_1^α_1 * x_2^α^2 * ... * x_n^α_n
import Base: ^
^(x, α::MultiIndex) = prod(u^a for (u,a) in zip(x, α.alpha))

## ∂^α(ex) = ∂_1^α_1 ∘ ∂_2^α_2 ∘ ... ∘ ∂_n^α_n (ex)
partial(ex::SymPy.SymbolicObject, α::MultiIndex, vars=free_symbols(ex)) = diff(ex, zip(vars, α.alpha)...)
@show 499
@syms w
alpha = MultiIndex([1,2,1,3])
length(alpha)  # 1 + 2 + 1 + 3=7
[1,2,3,4]^alpha
exₜ = x^3 * cos(w*y*z)
partial(exₜ, alpha, [w,x,y,z])
@show 501
struct MultiIndices
    n::Int
    k::Int
end

function Base.length(as::MultiIndices)
  n,k = as.n, as.k
  n == 1 && return 1
  sum(length(MultiIndices(n-1, j)) for j in 0:k)  # recursively identify length
end

function Base.iterate(alphas::MultiIndices)
    k, n = alphas.k, alphas.n
    n == 1 && return ([k],(0, MultiIndices(0,0), nothing))

    m = zeros(Int, n)
    m[1] = k
    betas = MultiIndices(n-1, 0)
    stb = iterate(betas)
    st = (k, MultiIndices(n-1, 0), stb)
    return (m, st)
end

function Base.iterate(alphas::MultiIndices, st)

    st == nothing && return nothing
    k,n = alphas.k, alphas.n
    k == 0 && return nothing
    n == 1 && return nothing

    # can we iterate the next on
    bk, bs, stb = st

    if stb==nothing
        bk = bk-1
        bk < 0 && return nothing
        bs = MultiIndices(bs.n, bs.k+1)
        val, stb = iterate(bs)
        return (vcat(bk,val), (bk, bs, stb))
    end

    resp = iterate(bs, stb)
    if resp == nothing
        bk = bk-1
        bk < 0 && return nothing
        bs = MultiIndices(bs.n, bs.k+1)
        val, stb = iterate(bs)
        return (vcat(bk, val), (bk, bs, stb))
    end

    val, stb = resp
    return (vcat(bk, val), (bk, bs, stb))

end
@show 503
collect(MultiIndices(2, 3))
@show 505
union((collect(MultiIndices(2, i)) for i in 0:3)...)
@show 507
k = 4
length(MultiIndices(3, k+1))
@show 509
#| hold: true
@syms 𝐅() a[1:3] dx[1:3]

sum(partial(𝐅(a...), α, a) / factorial(α) * dx^α for k in 0:3 for α in MultiIndex.(MultiIndices(3, k)))  # 3rd order
@show 513
#| hold: true
#| echo: false
f(x,y) = sqrt(x + y)
f(v) = f(v...)
pt = [2,2]
dxdy = [.1, .2]
val = f(pt) + dot(ForwardDiff.gradient(f, pt), dxdy)
numericq(val)
@show 516
#| hold: true
#| echo: false
f(x,y,z) = x*y + y*z + z*x
f(v) = f(v...)
pt = [1,1,1]
dx = [0.1, 0.0, -0.1]
val = f(pt) + ∇(f)(pt) ⋅ dx
numericq(val)
@show 519
#| hold: true
#| echo: false
f(x,y,z) = x*y + y*z + z*x - 8
f(v) = f(v...)
pt = [1,1,1]
n = ∇(f)(pt)
d = dot(n, pt)
choices = [
    raw"`` x + y + z = 3``",
    raw"`` 2x + y - 2z = 1``",
    raw"`` x + 2y + 3z = 6``"
]
answ = 1
radioq(choices, answ)
@show 523
#| hold: true
#| echo: false
choices = [
    raw"`` \langle 2xy + y^2 + y, 2xy + x^2 + x\rangle``",
    raw"`` y^2 + y, x^2 + x``",
    raw"`` \langle 2y + y^2, 2x + x^2``"
]
answ = 1
radioq(choices, answ)
@show 527
#| hold: true
#| echo: false
yesnoq(true)
@show 529
#| hold: true
#| echo: false
f(x,y) = x*y + x*y^2 + x^2 * y
f(v) = f(v...)
val = det(ForwardDiff.hessian(f, [-1/3, -1/3]))
numericq(val)
@show 531
#| hold: true
#| echo: false
choices = [
    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
    L"The function $f$ has a saddle point, as $d  < 0$",
    L"Nothing can be said, as $d=0$"
]
answ = 2
radioq(choices, answ, keep_order=true)
@show 535
#| hold: true
#| results: "hidden"
f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
@syms x::real y::real
gradf = gradient(f(x,y), [x,y])
@show 536
#| hold: true
#| echo: false
yesnoq(true)
@show 538
#| hold: true
#| results: "hidden"
f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
@syms x::real y::real
gradf = gradient(f(x,y), [x,y])

solve(gradf, [x,y])
@show 539
#| hold: true
#| echo: false
numericq(2)
@show 541
#| hold: true
f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
@syms x::real y::real
gradf = gradient(f(x,y), [x,y])

sympy.hessian(f(x,y), [x,y])
@show 543
#| hold: true
#| echo: false
choices = [
    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
    L"The function $f$ has a saddle point, as $d  < 0$",
    L"Nothing can be said, as $d=0$",
    L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
]
answ = 3
radioq(choices, answ, keep_order=true)
@show 545
#| hold: true
#| echo: false
choices = [
    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
    L"The function $f$ has a saddle point, as $d  < 0$",
    L"Nothing can be said, as $d=0$",
    L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
]
answ = 1
radioq(choices, answ, keep_order=true)
@show 547
#| hold: true
#| echo: false
choices = [
    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
    L"The function $f$ has a saddle point, as $d  < 0$",
    L"Nothing can be said, as $d=0$",
    L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
]
answ = 5
radioq(choices, answ, keep_order=true)
@show 553
#| hold: true
#| echo: false
yesnoq(true)
@show 557
#| hold: true
#| echo: false
yesnoq(false)
@show 559
#| hold: true
#| echo: false
choices =[
    "It is the determinant of the Hessian",
    L"It isn't, $b^2-4ac$ is from the quadratic formula"
]
answ = 1
radioq(choices, answ)
@show 561
#| hold: true
#| echo: false
choices = [
    L"That $a>0$ and $4ac-b^2 > 0$",
    L"That $a<0$ and $4ac-b^2 > 0$",
    L"That $4ac-b^2 < 0$"
]
answ = 2
radioq(choices, answ, keep_order=true)
@show 563
#| hold: true
#| echo: false
choices = [
    L"That $a>0$ and $4ac-b^2 > 0$",
    L"That $a<0$ and $4ac-b^2 > 0$",
    L"That $4ac-b^2 < 0$"
]
answ = 3
radioq(choices, answ, keep_order=true)
@show 569
#| hold: true
#| echo: false
yesnoq(true)
@show 571
#| echo: false
choices = [
    raw"`` \langle 2x, 2y\rangle``",
    raw"`` \langle 2x, y^2\rangle``",
    raw"`` \langle x^2, 2y \rangle``"
]
answ = 1
radioq(choices, answ)
@show 573
f(x,y) = exp(-x^2-y^2) * (2x^2 + y^2)
f(v) = f(v...)
r(t) = sqrt(3)*[cos(t), sin(t)]
rat(x) = abs(x[1]/x[2]) - 1
fn = rat ∘ ∇(f) ∘ r
ts = fzeros(fn, 0, 2pi)
@show 575
#| eval: false
#| echo: false
f(x,y) = exp(-x^2-y^2) * (2x^2 + y^2)
r(t) = sqrt(3)*[cos(t), sin(t)]
rat(x) = abs(x[1]/x[2]) - 1
fn = rat ∘ ∇(splat(f)) ∘ r
ts = fzeros(fn, 0, 2pi)

val = maximum((splat(u)∘r).(ts))
numericq(val)
