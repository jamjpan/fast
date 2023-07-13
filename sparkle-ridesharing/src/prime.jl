function prime!(cache, schedule, origin, destination, startloc; edges=edges)

    targets = [ w[2] for w ∈ schedule ]
    od_pair = [ origin, destination ]

    d1 = dijkstra(edges, origin,      targets)
    d2 = dijkstra(edges, destination, targets)

    for v ∈ targets
        # UNCOMMENT THESE.
        # d3 = dijkstra(edges, v, od_pair)
        # cache[(origin,      v)] = d1[v]
        # cache[(destination, v)] = d2[v]
        # cache[(v, origin     )] = d3[origin]
        # cache[(v, destination)] = d3[destination]

        # REMOVE THIS. This is for testing symmetric dists.
        cache[(origin,      v)] = cache[(v, origin     )] = d1[v]
        cache[(destination, v)] = cache[(v, destination)] = d2[v]
    end

    cache[(startloc, origin)] = dijkstra(edges, startloc, origin)
end
