###### Question (Ladder [questions](http://www.mathematische-basteleien.de/ladder.htm))


A ``7``meter ladder leans against wall with the base ``1.5``meters from wall at its base. At which height does the ladder touch the wall?

```julia; hold=true; echo=false
l = 7
adj = 1.5
opp = sqrt(l^2 - adj^2)
numericq(opp, 1e-3)
```


----

A ``7``meter ladder leans against the wall. Between the ladder and the wall is a ``1``m cube box. The ladder touches the wall, the box and the ground. There are two such positions, what is the height of the ladder of the more upright position?

You might find this code of help:

```julia; eval=false
@syms x y
l, b = 7, 1
eq = (b+x)^2 + (b+y)^2
eq = subs(eq, x=> b*(b/y)) # x/b = b/y
solve(eq ~ l^2, y)
```

What is the value `b+y` in the above?

```julia; echo=false
radioq(("The height of the ladder",
        "The height of the box plus ladder",
        "The distance from the base of the ladder to the box,"
        "The distance from the base of the ladder to the base of the wall"
        ),1)
```


What is the height of the ladder

```julia; hold=true; echo=false
numericq(6.90162289514212, 1e-3)
```


----

A ladder of length ``c`` is to moved through a 2-dimensional hallway of width ``b`` which has a right angled bend. If ``4b=c``, when will the ladder get stuck?

Consider this picture

```julia; hold=true; echo=false
p = plot(; axis=nothing, legend=false, aspect_ratio=:equal)
x,y=1,2
b = sqrt(x*y)
plot!(p, [0,0,b+x], [b+y,0,0], linestyle=:dot)
plot!(p, [0,b+x],[b,b], color=:black, linestyle=:dash)
plot!(p, [b,b],[0,b+y], color=:black, linestyle=:dash)
plot!(p, [b+x,0], [0, b+y], color=:black)
```


Suppose ``b=5``, then with ``b+x`` and ``b+y``  being the lengths on the walls where it is stuck *and* by similar triangles ``b/x = y/b`` we can solve for ``x``. (In the case take the largest positive value. The answer would be the angle ``\theta`` with ``\tan(\theta) = (b+y)/(b+x)``.

```julia; hold=true; echo=false
b = 5
l = 4*b
@syms x y
eq = (b+x)^2 + (b+y)^2
eq =subs(eq, y=> b^2/x)
x₀ = N(maximum(filter(>(0), solve(eq ~ l^2, x))))
y₀ = b^2/x₀
θ₀ = Float64(atan((b+y₀)/(b+x₀)))
numericq(θ₀, 1e-2)
```


-----

Two ladders of length ``a`` and ``b`` criss-cross between two walls of width ``x``. They meet at a height of ``c``.

```julia; hold=true; echo=false
p = plot(; legend=false, axis=nothing, aspect_ratio=:equal)
ya,yb,x = 2,3,1
plot!(p, [0,x],[ya,0], color=:black)
plot!(p, [0,x],[0, yb], color=:black)
plot!(p, [0,0], [0,yb], color=:blue, linewidth=5)
plot!(p, [x,x], [0,yb], color=:blue, linewidth=5)
plot!(p, [0,x], [0,0], color=:blue, linewidth=5)
xc = ya/(ya+yb)
c = yb*xc
plot!(p, [xc,xc],[0,c])
p
```

Suppose ``c=1``, ``b=3``, and ``a=5``. Find ``x``.

Introduce ``x = z + y``, and ``h`` and ``k`` the heights of the ladders along the left wall and the right wall.

The ``z/c = x/k`` and ``y/c = x/h`` by similar triangles. As ``z + y`` is ``x`` we can solve to get

```math
x = z + y = \frac{xc}{k} + \frac{xc}{h}
 = \frac{xc}{\sqrt{b^2 - x^2}} + \frac{xc}{\sqrt{a^2 - x^2}}
```

With ``a,b,c`` as given, this can be solved with

```julia; hold=true; echo=false
a,b,c =  5, 3, 1
f(x) = x*c/sqrt(b^2 - x^2) + x*c/sqrt(a^2 - x^2) - x
find_zero(f, (0, b))
```

The answer is ``2.69\dots``.
