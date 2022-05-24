## container of points into vectors n vectors of length N
## N points, each of size n

## Lesson learned -- this is a very bad idea!
## better to handle the T a different way
evec(T,n) =  Tuple(T[] for _ in 1:n)
evec(T, N, n) =  Tuple(Vector{T}(undef, N) for _ in 1:n)


## julia> @btime xs_ys1(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   83.308 μs (1013 allocations: 172.67 KiB)

## julia> @btime xs_ys2(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   222.371 μs (2016 allocations: 180.72 KiB)

## julia> @btime xs_ys3(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   1.003 ms (1019 allocations: 165.20 KiB)

## julia> @btime xs_ys4(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   1.115 ms (5474 allocations: 210.95 KiB)

## julia> @btime xs_ys5(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   1.120 ms (5474 allocations: 210.95 KiB)

## julia> @btime xs_ys6(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   76.604 μs (1008 allocations: 164.63 KiB)

## julia> @btime xs_ys7(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   74.306 μs (1008 allocations: 164.63 KiB)

## julia> @btime xs_ys8(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   36.098 μs (2006 allocations: 94.25 KiB)

## julia> @btime xs_ys9(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   85.732 μs (3006 allocations: 203.63 KiB)

## ....

    ## THE WINNER, but we would use one with keywords
## julia> @btime xs_ys13a(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   62.768 μs (1003 allocations: 117.28 KiB)

## julia> @btime xs_ys13akw(vs) setup=(vs=[randn(1000) for i in 1:3]);
##   65.905 μs (1003 allocations: 117.28 KiB)


## make a matrix n x N, then go down 1:n
function xs_ys1(vs)
    A=hcat(vs...)
    Tuple([A[i,:] for i in eachindex(first(vs))])
end

## broadcast push!
function xs_ys2(vs)
    u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    v0 = evec(T,n)
    for v in vs
        push!.(v0, v)
    end
    v0
end


## broadcast push!
function xs_ys2a(vs)
    u = first(vs); N = length(vs)
    n = length(u)
    v0 = Tuple(eltype(u)[] for _ in eachindex(u))
    for v in vs
        push!.(v0, v)
    end
    v0
end

## broadcast setindex!
function xs_ys3(vs)
  u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    v0 = evec(T,N,n)
    for (i,v) in enumerate(vs)
        setindex!.(v0, v, i)
    end

    v0
end

## 10 times faster ~77mus avoiding passing T
function xs_ys3a(vs)
  u = first(vs); N = length(vs)
    n = length(u)
    v0 = Tuple(Vector{eltype(u)}(undef, N) for _ in eachindex(u))
    for (i,v) in enumerate(vs)
        setindex!.(v0, v, i)
    end

    v0
end


function xs_ys3b(vs)
  u = first(vs); N = length(vs)
    n = length(u)
    v0 = ntuple(_ -> Vector{eltype(u)}(undef, N), n)
    for (i,v) in enumerate(vs)
        setindex!.(v0, v, i)
    end

    v0
end

## loop N n
function xs_ys4(vs)
    u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    v0 = evec(T,N,n)

    for i in 1:N
        for j in 1:n
            v0[j][i] = vs[i][j]
        end
    end
    v0
end


## loop N n
function xs_ys4a(vs)
    u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    v0 = evec(T,N,n)

    for (i,v) in enumerate(vs)
        for j in 1:n
            v0[j][i] = v[j]
        end
    end
    v0
end

## fast 67mus
function xs_ys4b(vs)
    u = first(vs); N = length(vs)
    n = length(u)
    v0 = Tuple(Vector{eltype(u)}(undef, N) for _ in eachindex(u))

    for (i,v) in enumerate(vs)
        for j in 1:n
            v0[j][i] = v[j]
        end
    end
    v0
end

## loop n N
function xs_ys5(vs)
    u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    v0 = evec(T,N,n)

    for j in 1:n
        for i in 1:N
            v0[j][i] = vs[i][j]
        end
    end
    v0
end

function xs_ys6(vs)
    u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    A = Matrix{T}(undef, (N,n))
    for (i,v) in enumerate(vs)
        A[i,:] = v
    end
    Tuple(A[:,i] for i in 1:n)
end

function xs_ys7(vs)
    u = first(vs); N = length(vs)
    T = eltype(u); n = length(u)
    A = Matrix{T}(undef, (n, N))
    for (i,v) in enumerate(vs)
        A[:,i] = v
    end
    Tuple(A[i, :] for i in 1:n)
end

# faster but doesn't wotk with plot recipes
# and may be slower once realized
function xs_ys8(vs)
    N = length(vs)
    u = first(vs); T = eltype(u); n = length(u)
    Tuple((vs[j][i] for j in 1:N) for i in 1:n)
end

function xs_ys9(vs)
    N = length(vs)
    u = first(vs); T = eltype(u); n = length(u)
    Tuple(collect(vs[j][i] for j in 1:N) for i in 1:n)
end

function xs_ys10(vs)
    N = length(vs)
    u = first(vs); T = eltype(u); n = length(u)
    v0 = evec(T,N, n)
    for j in 1:n
        v0[j][:] .= (v[j] for v in vs)
    end
    v0
end

# mauro3 https://github.com/JuliaDiffEq/ODE.jl/issues/80
_pluck(y,i) =  eltype(first(y))[el[i] for el in y]
xs_ys11(vs) = Tuple(_pluck(vs, i) for i in eachindex(first(vs)))

# slower
xs_ys11a(vs) = ntuple(i->_pluck(vs, i), length(first(vs)))

# one liner
xs_ys11b(vs) = Tuple(eltype(first(vs))[el[i] for el in vs]  for i in eachindex(first(vs)))


function xs_ys11c(vs)
    u = first(vs)
    Tuple(eltype(u)[el[i] for el in vs] for i in eachindex(u))
end
xs_ys11d(vs) = (u=first(vs);  Tuple(eltype(u)[el[i] for el in vs] for i in eachindex(u)))
xs_ys11e(vs) = (u=first(vs);  ntuple(i->eltype(u)[v[i] for v in vs], length(u)))
xs_ys11f(vs) = (u=first(vs);n::Int=length(u);T::DataType=eltype(u);ntuple(i->eltype(u)[v[i] for v in vs], n))
xs_ys11g(vs::Vector{Vector{T}}) where {T} = (u=first(vs);n::Int=length(u);ntuple(i->T[v[i] for v in vs], n))


@inline _pluck(T, y, i) =  T[el[i] for el in y]
function xs_ys11b(vs)
    T = eltype(first(vs))
    Tuple(_pluck(T, vs, i) for i in eachindex(first(vs)))
end

function xs_ys12(vs)
    N = length(vs)
    u = first(vs); T = eltype(u); n = length(u)
    Tuple(T[el[i] for el in vs] for i in eachindex(first(vs)))
    end

function xs_ys12a(vs)
    N = length(vs)
    u = first(vs); T = eltype(u); n = length(u)
    ntuple( i -> T[el[i] for el in vs], n)
end



function xs_ys11h(vs)
    u = first(vs)
    T = eltype(u)
    Tuple(T[el[i] for el in vs] for i in eachindex(u))
    end

function xs_ys11i(vs)
    u = first(vs)
    Tuple(eltype(u)[el[i] for el in vs] for i in eachindex(u))
end


function _xs_ys12(vs, u::Vector{T}) where {T}
    Tuple(T[el[i] for el in vs] for i in eachindex(u))
end

xs_ys13(vs, u::Vector{T}=first(vs)) where {T} = Tuple(T[el[i] for el in vs] for i in eachindex(u))

xs_ys13a(vs, u::Vector{T}=first(vs), n::Val{N}=Val(length(u))) where {T,N} = ntuple(i -> T[el[i] for el in vs], n)


## cleaned up
function xs_ys13a(vs, u::Vector{T}=first(vs), n::Val{N}=Val(length(u))) where {T,N}
   plucki = i -> T[el[i] for el in vs]
   ntuple(plucki, n)
end


function xs_ys13akw(vs; u::Vector{T}=first(vs), n::Val{N}=Val(length(u))) where {T,N}
   plucki = i -> T[el[i] for el in vs]
   ntuple(plucki, n)
end

function xs_ys13b(vs, u::Vector{T}=first(vs), n::Val{N}=Val(length(u))) where {T,N}
    Tuple(T[el[i] for el in vs] for i in eachindex(u))
end


xs_ys14(vs) = Tuple(eltype(vs[1])[vs[i][j] for i in 1:length(vs)] for j in 1:length(vs[1]))

xs_ys14a(vs) = Tuple([vs[i][j] for i in 1:length(vs)] for j in 1:length(first(vs)))
