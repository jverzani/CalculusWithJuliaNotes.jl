using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

# GUI for spirograph
# https://en.wikipedia.org/wiki/Spirograph

function x(t; R=1, k=1/4, l=1/4)
    R*[(1-k)*cos(t) + l*k*cos((1-k)/k*t), (1-k)*sin(t) - l*k*sin((1-k)/k*t)]
end

# where we lay our scene:
scene, layout = layoutscene()

flyt = GridLayout()
flyt.halign[] = :left # fails?
flyt.valign[] = :top

layout[1,1] = flyt
p = layout[1,2] = LAxis(scene)
rowsize!(layout, 1, Relative(1))
colsize!(layout, 2, Relative(2/3))

flyt[1,1] = LText(scene, "t")
ts = flyt[1,2] = LSlider(scene, range = 2pi:pi/8:40pi)

flyt[2, 1] = LText(scene, "k = r/R")
k = flyt[2,2] = LSlider(scene, range = 0.01:0.01:1.0, startvalue=1/4)

flyt[3,1] = LText(scene, "l=ρ/r")
l = flyt[3,2] = LSlider(scene,  range = 0.01:0.01:1.0, startvalue=1/4)


data = lift(ts.value, k.value, l.value) do ts,k,l
    
    ts′ = range(0, ts, length=1000)
    xys = Point2f0.(x.(ts′, R=1, k=k, l=l))
    
end

lines!(p, data)
xlims!(p, (-1, 1))
ylims!(p, (-1, 1))




scene

