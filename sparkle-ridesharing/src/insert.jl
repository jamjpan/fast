"""
    insert(schedule, origin, i, [destination, j], metric;
        label, tinit, vinit, speed, cache)

Returns (ΔF, b) where ΔF is the change in distance of `schedule` after
inserting `origin` and `destination` at positions `i` and `j`,
respectively, and b is the new schedule. If `destination` and `j` are
not given, only `origin` is inserted.

To calculate ΔF, if `metric` is an instance of `Metric{:sp}`,
shortest-path distance is used; otherwise if an instance of
`Metric{:l2}`, the l2-norm is used.

The newly inserted origin and/or destination waypoints are labeled
using `label`. The starting time of the schedule is given by `tinit`,
and the starting location by `vinit`. The vehicle `speed` is used to
calculate arrival times. A `cache` can be provided to speed up
distance calculations.
"""
function insert(schedule, origin, i, metric::Metric{:sp};
       label, nodes, edges, tinit, vinit, speed, cache,
       addtocache, cachesize)
    @cost i sp
    (isinf(ΔF) || isnan(ΔF)) && return (Inf, schedule)

    @insert i
    # The lowest possible value for ΔF is 0. But sometimes due to
    # rounding, it can be less than 0. On the rare occasion when ΔF <
    # 0, but there is already an i′ with α′ = 0, the reducer will
    # replace i′ with this i. Not exactly an error, but good to be
    # aware.
    (ΔF, b)
end

function insert(schedule, origin, i, metric::Metric{:l2};
       label, nodes, edges, tinit, vinit, speed, cache,
       addtocache, cachesize)
    @cost i l2
    (isinf(ΔF) || isnan(ΔF)) && return (Inf, schedule)

    @insert i
    (ΔF, b)
end

function insert(schedule, origin, i, destination, j, metric::Metric{:sp};
       label, nodes, edges, tinit, vinit, speed, cache,
       addtocache, cachesize)
    @cost   ij sp
    (isinf(ΔF) || isnan(ΔF)) && return (Inf, schedule)

    @insert ij
    (ΔF, b)
end

function insert(schedule, origin, i, destination, j, metric::Metric{:l2};
       label, nodes, edges, tinit, vinit, speed, cache,
       addtocache, cachesize)
    @cost   ij l2
    (isinf(ΔF) || isnan(ΔF)) && return (Inf, schedule)

    @insert ij
    (ΔF, b)
end
