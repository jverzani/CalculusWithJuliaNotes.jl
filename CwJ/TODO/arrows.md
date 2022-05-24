This is really just

plot!([0,cos(θ)],[0,sin(θ)], arrow=true)


https://stackoverflow.com/questions/58219191/drawing-an-arrow-with-specified-direction-on-a-point-in-scatter-plot-in-julia

https://github.com/m3g/CKP/blob/master/disciplina/codes/velocities.jl




using Plots
using LaTeXStrings

function arch(θ₁,θ₂;radius=1.,Δθ=1.)
  θ₁ = π*θ₁/180
  θ₂ = π*θ₂/180
  Δθ = π*Δθ/180
  l = round(Int,(θ₂-θ₁)/Δθ)
  x = zeros(l)
  y = zeros(l)
  for i in 1:l
    θ = θ₁ + i*Δθ
    x[i] = radius*cos(θ) 
    y[i] = radius*sin(θ)
  end
  return x, y
end

plot()

x, y = arch(0,360)
plot(x,y,seriestype=:shape,label="",alpha=0.5)

x, y = arch(0,360,radius=0.95)
plot!(x,y,seriestype=:shape,label="",fillcolor=:white)

x, y = arch(0,360,radius=0.7)
plot!(x,y,seriestype=:shape,label="",alpha=0.5,fillcolor=:red)

x, y = arch(0,360,radius=0.65)
plot!(x,y,seriestype=:shape,label="",fillcolor=:white)

plot!([0,0],[0,1.1],arrow=true,color=:black,linewidth=2,label="")
plot!([0,1.1],[0,0],arrow=true,color=:black,linewidth=2,label="")

x, y = arch(15,16,radius=0.65)
plot!([0,x[1]],[0,y[1]],arrow=true,color=:black,linewidth=1,label="")

x, y = arch(35,36,radius=0.95)
plot!([0,x[1]],[0,y[1]],arrow=true,color=:black,linewidth=1,label="")

plot!(draw_arrow=true)
plot!(showaxis=:no,ticks=nothing,xlim=[-0.1,1.1],ylim=[-0.1,1.1],)
plot!(xlabel="x",ylabel="y",size=(400,400))

annotate!(0.58,-0.07,text(L"\Delta v_1",10))
annotate!(0.88,-0.07,text(L"\Delta v_2",10))

savefig("./velocities.pdf")
