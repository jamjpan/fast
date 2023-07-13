"""
    popcached!(v, u, cache)

Extracts and returns elements from vector `v` where `(u, elem)` is NOT
in `cache`. At the end of this operation, `v` contains only the unique
elements that ARE in the cache.
"""
function popcached!(v, u, cache)

    isnothing(cache) && return Vector{Int64}()

    unique!(v)

    done = fill(0, length(v))

    n = 0

    for i ∈ length(v):-1:1
        if haskey(cache, (u, v[i]))
            done[n+=1] = popat!(v, i)
        end
    end

    resize!(done, n)
end
