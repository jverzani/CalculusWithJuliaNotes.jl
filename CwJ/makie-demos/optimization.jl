using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

using LinearAlgebra
using Roots
using ForwardDiff
D(f) = x -> ForwardDiff.derivative(f, float(x))

descr = """
An old optimization problem is to find the shortest distance between two
points when the rate of travel differs due to some medium (darker means slower). 
In this example, the relative rate can be adjusted (with the slider), and the 
various points  (by clicking on and dragging a point). From there, the
user can adjust the crossing point to identify the time. 
"""

## From http://juliaplots.org/MakieReferenceImages/gallery//edit_polygon/index.html:
function add_move!(scene, points, pplot)
    idx = Ref(0); dragstart = Ref(false); startpos = Base.RefValue(Point2f0(0))
    on(events(scene).mousedrag) do drag
        if ispressed(scene, Mouse.left)
            if drag == Mouse.down
                plot, _idx = mouse_selection(scene)
                if plot == pplot
                    idx[] = _idx; dragstart[] = true
                    startpos[] = to_world(scene, Point2f0(scene.events.mouseposition[]))
                end
            elseif drag == Mouse.pressed && dragstart[] && checkbounds(Bool, points[], idx[])
                pos = to_world(scene, Point2f0(scene.events.mouseposition[]))

                # very wierd, but we work with components
                # not vector
                z = zero(eltype(pos))
                x,y = pos

                ptidx = idx[]

                x = clamp(x, 0, 5)
                
                if ptidx == 1
                    y = clamp(y, z, 5)
                elseif ptidx == 2
                    y = z
                elseif ptidx == 3
                    y = clamp(y, -5, z)
                end

                points[][idx[]] = [x,y]
                points[] = points[]
            end
        else
            dragstart[] = false
        end
        return
    end
end

upperpoints = Point2f0[(0,0), (5, 0), (5, 5), (0,5)]
lowerpoints = (Point2f0[(0,0), (5, 0), (5, -5), (0,-5)])

points = Node(Point2f0[(1, 4), (3, 0), (4,-4.0)])

# where we lay our scene:
scene, layout = layoutscene()
layout.halign = :left
layout.valign = :top


p = layout[1:3, 1] = LScene(scene)
rowsize!(layout, 1, Auto(1))
colsize!(layout, 1, Auto(1))


flayout = GridLayout()
layout[1,2] = flayout

flayout[1,1] = LText(scene, chomp(descr))

details = flayout[2, 1] = LText(scene, "...")

λᵣ = flayout[3,1] =  LText(scene, "λ = v₁/v₂ = 1")
λ = flayout[4,1] = LSlider(scene, range = -3:0.2:3, startvalue = 0.0)




tm = lift(λ.value, points) do λ, pts
    x0,y0 = pts[1]
    x, y = pts[2]
    x1, y1 = pts[3]

    v1 = 1
    v2 = v1/2.0^λ

    t(x) = sqrt((x-x0)^2 + y0^2)/v1 + sqrt((x1-x)^2 + y1^2)/v2
    val = t(x)

    details.text[] = "Time: $(round(val, digits=2)) units"

    val
    
end

a = lift(λ.value, points) do λ, pts
    x0,y0 = pts[1]
    x1, y1 = pts[3]
    v1 = 1
    v2 = v1/2.0^λ

    t(x) = sqrt((x-x0)^2 + y0^2)/v1 + sqrt((x1-x)^2 + y1^2)/v2
    x′ = fzero(D(t), x0, x1)
    t(x′)
end

λcolor = lift(λ.value) do val
    # val = v1/v2 ∈ [1/8, 8]
    n = floor(Int, 50 - val/3 * 25)
    Symbol("gray" * string(n))
end

linecolor = lift(a) do val
    abs(val - tm[]) <= 1e-2 ? :green : :white
end


on(λ.value) do val
    v = round(2.0^(val), digits=2)
    txt = "λ = v₁/v₂ = $v"
    λᵣ.text[] = txt

    
end
    


poly!(p.scene, upperpoints, color = :gray50) # neutral color
poly!(p.scene, lowerpoints, color = λcolor) # color depends on λ

lines!(p.scene, Point2f0[(0,0), (5, 0)], color=:black, strokewidth=5, strokecolor=:black, raw=true)
lines!(p.scene, points, color = linecolor, strokewidth = 10, markersize = 0.05, strokecolor = :black, raw = true)
scatter!(p.scene, points, color = linecolor, strokewidth = 10, markersize = 0.05, strokecolor = :black, raw = true)
xlims!(p.scene, (0,5))
ylims!(p.scene, (-5,5))

add_move!(p.scene, points, p.scene[end])



scene

