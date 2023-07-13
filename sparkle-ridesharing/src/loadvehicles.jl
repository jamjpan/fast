"""
    loadvehicles(vehfile, V)

Returns the vehicles loaded from file `vehfile` and maps them to their
starting coordinates using `V`.
"""
function loadvehicles(vehfile, V)
    raw_S = readdlm(vehfile, ',', Int; skipstart=1)

    max_id = maximum(raw_S[:,1])

    S::Matrix{Union{Int64, Float64, Vector{Waypoint}}} =
        fill(0, (max_id, 4))

    for (sid, t, v) ∈ eachrow(raw_S)
        x = Integer(v)

        S[sid,  1] = x
        S[sid,2:3] = V[x,:]
        S[sid,  4] = Vector{Waypoint}()
    end

    S
end
