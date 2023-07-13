"""
    captab!(tab, schedule, load, init=0)

Returns the maximum seating load between every range of waypoints in
`schedule`.
"""
function captab!(tab, schedule, load, init=0)

    l = length(schedule)
    Q = zeros(l)

    for k ∈ eachindex(schedule)
        Q[k] = max(0, Q[(k == 1 ? k : k-1)] +
            (schedule[k][4] ? load : -load))
    end

    for i ∈ 1:l+1, j ∈ i:l+1
        tab[(i,j)] =
            maximum((i > 1 ? Q[i-1:j-1] : vcat(init, Q[i:j-1])))
    end
end
