"""
    findinsertion(schedule, origin, destination, timesheet, mode;
        label, nodes, edges, capacity, load, tinit, vinit, speed,
        cache=nothing, addtocache=false, cachesize=0,
        captab=nothing, bubbles=nothing)

Returns the minimum change in distance of inserting `origin` and
`destination` into `schedule`, along with the new schedule and the
insertion positions that yield the minimum.

If `mode` is an instance of `Mode{:dp}`, the dynamic-programming
implementation is used; otherwise if an instance of `Mode{:nv}`, the
"naive" scanning implementation is used.

If no insertion positions yield a feasible schedule based on
`timesheet`, `capacity`, and `load`, then this function returns `(Inf,
schedule, 0, 0)`.

The newly inserted origin and destination waypoints are labeled using
`label`. The starting time of the schedule is given by `tinit`, and
the starting location by `vinit`. The vehicle `speed` is used to
calculate arrival times. A `cache` can be provided to speed up
distance calculations. The `nodes` and `edges` are used for distance
calculations.
"""
findinsertion(schedule, origin, destination, timesheet,
        mode::Mode{:dp}, metric::Metric{:sp};
        label, nodes, edges, capacity, load, tinit, vinit, speed,
        cache=nothing, addtocache=false, cachesize=0,
        captab=nothing, bubbles=nothing) =
    @findinsertion dp :sp

findinsertion(schedule, origin, destination, timesheet,
        mode::Mode{:dp}, metric::Metric{:l2};
        label, nodes, edges, capacity, load, tinit, vinit, speed,
        cache=nothing, addtocache=false, cachesize=0,
        captab=nothing, bubbles=nothing) =
    @findinsertion dp :l2

findinsertion(schedule, origin, destination, timesheet,
        mode::Mode{:nv}, metric::Metric{:sp};
        label, nodes, edges, capacity, load, tinit, vinit, speed,
        cache=nothing, addtocache=false, cachesize=0,
        captab=nothing, bubbles=nothing) =
    @findinsertion nv :sp

findinsertion(schedule, origin, destination, timesheet,
        mode::Mode{:nv}, metric::Metric{:l2};
        label, nodes, edges, capacity, load, tinit, vinit, speed,
        cache=nothing, addtocache=false, cachesize=0,
        captab=nothing, bubbles=nothing) =
    @findinsertion nv :l2
