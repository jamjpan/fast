macro d(m, u, v)
    body =
        isequal(m, :l2) ? :(l2norm(nodes[$u,:], nodes[$v,:])) :
        isequal(m, :sp) ?
            :(dijkstra(edges, $u, $v; cache=cache,
                addtocache=addtocache, cachesize=cachesize)) :
        Inf

    esc(:($body))
end
