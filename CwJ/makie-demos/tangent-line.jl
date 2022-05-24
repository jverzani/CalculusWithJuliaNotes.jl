using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

using ForwardDiff
Base.adjoint(f::Function) = x -> ForwardDiff.derivative(f, float(x))


function tangent_line(f=nothing, a=0, b=pi)

    if f == nothing
        f = x -> sin(x)
    end

descr = """
The tangent line has a slope approximated by the slope of secant lines. 
This demo allows the points c and c+h to be adjusted to see the two lines"""

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

                # we work with components not vector
                x,y = pos

                x = clamp(x, a, b)
                y = f(x)

                points[][idx[]] = [x,y]
                points[] = points[]
            end
        else
            dragstart[] = false
        end
        return
    end
end


c, h = pi/4, .5
points = Node(Point2f0[(c, f(c)), (c+h, f(c+h))])


# where we lay our scene:
scene, layout = layoutscene()
layout.halign = :left
layout.valign = :top

p = layout[1,1:2] = LScene(scene)

rowsize!(layout, 1, Auto(1))
colsize!(layout, 1, Auto(1))

layout[2,1:2] = LText(scene, descr)


secline = lift(points) do pts
    c, ch = pts
    x0, y0 = c
    x1, y1 = ch
    m = (y1 - y0)/(x1 - x0)
    sl = x -> y0 + m * (x - x0)
    Point2f0[(a, sl(a)), (b, sl(b))]
end

tangentline = lift(points) do pts
    c, ch = pts
    x0, y0 = c
    m = f'(x0)
    tl = x -> y0 + m * (x - x0)
    Point2f0[(a, tl(a)), (b, tl(b))]
end
    

lines!(p.scene, a..b, f, strokecolor=:red, strokewidth=15)
lines!(p.scene, secline, color = :blue, strokewidth = 10, raw=true)
lines!(p.scene, tangentline, color = :red, strokewidth = 10, raw=true)
scatter!(p.scene, points, color = :white, strokewidth = 10, markersize = 0.05, strokecolor = :black, raw = true)
xlims!(p.scene, (a, b))
#ylims!(p.scene, (0, 1.5))


add_move!(p.scene, points, p.scene[end])



scene

    end


tangent_line()
