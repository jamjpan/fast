"""
    dijkstra(E, u, v=[]; cache=nothing, addtocache=false, cachesize=0)

Find the shortest-path distances from `u` to each of the `v` through
the edges `E`. The returned dict maps each target to its distance.

If a `cache` is provided, the cached values will be used.  If
`addtocache` is `true`, then any source-target pairs that are not in
the cache will be added to the cache. If the number of entries exceeds
`cachesize`, entries are popped from the front of the cache until
there are exactly `cachesize` entries. The cache MUST be acceptable by
`popfirst!` for this feature to be used.
"""
function dijkstra(E, u, v::Vector{Int64};
        cache=nothing, addtocache=false, cachesize=0)

    D = Dict{Int64,Float64}()
    isempty(v) && return D

    todo = deepcopy(v)
    done = popcached!(todo, u, cache)

    @debug "dijkstra: $(length(todo)) todo, $(length(done)) done"

    q = PriorityQueue{Int64,Float64}()

    foreach(k -> q[k] = D[k] = cache[(u,k)], done)
    isempty(todo) && return D

    for k ∈ keys(E)
        if !haskey(D, k)
            q[k] = D[k] = isequal(k, u) ? 0 : Inf
        end
    end

    n = length(todo)

    # If a target is not in E, the above loop will not set D[target],
    # leading to key-not-found error later on. So set it manually.
    for k ∈ todo
        if !haskey(E, k)
            q[k] = D[k] = Inf;
            n -= 1
        end
    end

    while n > 0 && !isempty(q)
        next = dequeue!(q)
        for (neighbor, w) ∈ E[next]
            if haskey(q, neighbor) && (alt = D[next]+w) < D[neighbor]
                q[neighbor] = D[neighbor] = alt
            end
        end
        if next ∈ todo
            n -= 1
        end
    end

    if addtocache
        for k ∈ todo
            cache[(u,k)] = D[k]

            # REMOVE THIS. This is for testing symmetric dists.
            cache[(k,u)] = D[k]

            @debug "dijkstra: added ($u, $k) to cache"
            if length(cache) > cachesize
                _removed = popfirst!(cache)
                @debug "dijkstra: removed $_removed"
            end
        end
    end

    filter(kv -> kv.first ∈ todo, D)
end

dijkstra(E, u, v::Int; cache=nothing, addtocache=false, cachesize=0) =
    dijkstra(E, u, [v];
        cache=cache, addtocache=addtocache, cachesize=cachesize)[v]
