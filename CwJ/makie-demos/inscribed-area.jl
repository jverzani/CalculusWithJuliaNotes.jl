using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

using Roots

## Assumes f(a), f(b) are zero
## only 1 or 2 solutions for f(x) = f(c) for any c in [a,b]
f(x) = 1 - x^4
a = -1
b = 1

    descr = """
Adjust the point (c, f(c)) with c > 0 to find the inscribed rectangle with maximal area
"""
    

function _inscribed_area(c)
    zs = fzeros(u -> f(u) - f(c), a, b)
    length(zs) <= 1 ? 0 : abs(zs[1] - zs[2]) * f(c)
end
D(f) = c -> (f(c + 1e-4) - f(c))/1e-4
function answer()
    h = 1e-4
    zs = fzeros(D(_inscribed_area), 0, b-h)
    a,i = findmax(_inscribed_area.(zs))
    a
end

Answer = answer()


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

                if idx[] == 3
                    pos = to_world(scene, Point2f0(scene.events.mouseposition[]))

                    # we work with components not vector
                    x,y = pos
                    c = clamp(x, a, b)
                    zs = fzeros(u -> f(u) - f(c), a , b)

                    if length(zs) == 1
                        c′ = c = first(zs)
                    else
                        c′, c = zs
                    end

                    
                    points[][1] = [c′, 0]
                    points[][2] = [c′, f(c′)]
                    points[][3] = [c, f(c)]
                    points[][4] = [c, 0]
                    points[] = points[]
                end
            end
        else
            dragstart[] = false
        end
        return
    end
end


c = b/2
c′ = first(fzeros(u -> f(u) - f(c), a , b))
area = round(abs(c - c′) * f(c), digits=4)

points = Node(Point2f0[(c′,0), (c′, f(c′)), (c, f(c)), (c, 0)])



# where we lay our scene:
scene, layout = layoutscene()
layout.halign = :left
layout.valign = :top

p = layout[0,0] = LScene(scene)

colsize!(layout, 1, Auto(1))
rowsize!(layout, 1, Auto(1))

label = layout[end, 1] = LText(scene, "Area = $area")
layout[end+1,1] = LText(scene, chomp(descr))

polycolor = lift(points) do pts
    c′ = pts[1][1]
    c = pts[3][1]
    area = round(abs(c - c′)*f(c), digits=4)

    lbl = "Area = $area"
    label.text[] = lbl

    if abs(area - Answer) <= 1e-4
        :green
    else
        :gray75
    end

    
    
end


lines!(p.scene, a..b, f, strokecolor=:red, strokewidth=15)
lines!(p.scene, a..b, zero, strokecolor=:black, strokewidth=10)
poly!(p.scene, points, color = polycolor)
scatter!(p.scene, points, color = :white, strokewidth = 10, markersize = 0.05, strokecolor = :black, raw = true)
xlims!(p.scene, (a, b))


add_move!(p.scene, points, p.scene[end])

    


scene
