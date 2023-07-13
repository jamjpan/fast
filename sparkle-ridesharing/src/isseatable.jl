"""
    isseatable(schedule, capacity, load, [i, j])

Returns `true` if the passengers in `schedule` are able to be seated,
given `capacity` initial seats, and each passenger requires `load`
seats.

If `i` is given, an additional pick-up is added at location i. If `i`
and `j` are both given, an additional pick-up is added at location i
and an additional drop-off at location j.
"""
isseatable(schedule, capacity, load) =       @seatable none
isseatable(schedule, capacity, load, i) =    @seatable  one
isseatable(schedule, capacity, load, i, j) = @seatable both
