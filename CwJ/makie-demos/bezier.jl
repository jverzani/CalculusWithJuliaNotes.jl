using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

using LinearAlgebra


function bezier()
descr = """
Bezier Curves: B(t) = ∑(binomial(n,i) * tⁱ * (1-t)⁽ⁿ⁻¹⁾ * Pᵢ)
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

                x = clamp(x, -1, 1)
                y = clamp(y, -1, 1)
                
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


p = layout[1, 1:2] = LScene(scene)
rowsize!(layout, 1, Auto(1))
colsize!(layout, 1, Auto(1))
colsize!(layout, 2, Auto(1))

npts = layout[2,1:2] = LSlider(scene, range=3:12, startvalue=4)
layout[3,1:2] = LText(scene, chomp(descr))

# points = Node(Point2f0[(-1/2, -1/2),
#                        (-1/2, 1/2),
#                        (1/2, 1/2),
#                        (1/2, -1/2)])

#npts = 6
#ts = range(3pi/2, -pi/2, length=npts+2)
#points = Node(Point2f0[(cos(t),sin(t)) for t in ts[2:end-1]])

points = lift(npts.value) do val
    ts = range(3pi/2, -pi/2, length=val+2)
    Point2f0[(cos(t),sin(t)) for t in ts[2:end-1]]
end
    





bcurve = lift(points) do pts
    n = length(pts) - 1
    B = t -> begin
        tot = 0.0
        for (i′, Pᵢ) in enumerate(pts)
            i = i′ - 1
            tot += binomial(n, i) * t^i * (1-t)^(n-i) * Pᵢ
        end
        tot
    end
    ts = range(0, 1, length=200)
    Point2f0[B(t) for t in ts]
end



lines!(p.scene, bcurve, strokecolor=:black, strokewidth=15)
lines!(p.scene, points, strokecolor=:gray90, strokewidth=5, linestyle=:dash)
scatter!(p.scene, points)
xlims!(p.scene, (-1,1))
ylims!(p.scene, (-1,1))
add_move!(p.scene, points, p.scene[end])



scene

end
