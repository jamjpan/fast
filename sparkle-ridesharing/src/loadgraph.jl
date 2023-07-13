"""
    loadgraph(edgelist)

Returns (nodes, edges) containing the road network stored in the
`edgelist`.
"""
function loadgraph(edgelist)
    raw_E = readdlm(edgelist, ',', skipstart=1)
    raw_V = unique(sortslices(raw_E[:,[3,1,2]], dims=1), dims=1)

    max_id = Integer(maximum(raw_V[:,1]))

    V = fill(0.0, (max_id, 2))

    foreach(row -> V[Integer(row[1]),:] = row[2:3], eachrow(raw_V))

    E = Dict{Int64, Vector{Tuple{Int64,Float64}}}()

    for row ∈ eachrow(raw_E)
        u = convert(Int64,   row[3])
        v = convert(Int64,   row[4])
        w = convert(Float64, row[6])
        push!(get!(E, u, []), (v, w))
    end

    (V, E)
end
