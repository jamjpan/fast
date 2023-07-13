"""
    tripstoreqs!(reqfile, tripfile, V, E; ts, te)

Reads `tripfile` and writes requests into `reqfile`.

Trips are sampled starting from `ts` (inclusive) and ending at `te`
(exclusive). Both `ts` and `te` should be time strings in "HH:MM:SS"
format.

For each sampled trip, the departure and arrival coordinates are
aligned to nodes in the Nodes matrix, `V`, to serve as origin and
destination nodes. Trip length is calculated using shortest-path
distances based on the Edges dict, `E`, then rounding up to the
nearest integer.

Not all trips within the timeframe are sampled. A trip is not sampled
if the origin and destination are the same after alignment, or there
is no path from the origin to the destination.

# Examples
```julia-repl
julia> tripstoreqs!("f.csv", "t.csv", V, E, "8:00:00", "9:00:00")
```
"""
function tripstoreqs!(reqfile, tripfile, V, E; ts, te)
    fmt = DateFormat("H:M:S")
     st = Time(ts, fmt)
     et = Time(te, fmt)

      R = zeros(Integer, 0, 5)
    rid = 0

    for row ∈ eachrow(readdlm(tripfile, ',', String; skipstart=1))
        t = Time(row[1], fmt)

        # File must be sorted by time (column 1), otherwise this loop
        # will break early
        t < st && continue; et ≤ t && break

        ox = parse(Float64, row[2])
        oy = parse(Float64, row[3])
        dx = parse(Float64, row[5])
        dy = parse(Float64, row[6])

        o = align(V, (ox, oy))[2]
        d = align(V, (dx, dy))[2]
        isequal(o, d) && continue

        D = dijkstra(E, o, d)
        isequal(Inf, D) && continue

        R = [R; [rid+=1 Second(t-st).value o d Integer(ceil(D))]]
    end

    hdr = ["RID" "T-"*ts "ORIGIN" "DESTINATION" "TRIP_LENGTH"]
    open(reqfile, "w") do io writedlm(io, [hdr; R], ',') end

    R
end
