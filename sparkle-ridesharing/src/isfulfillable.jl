"""
    isfulfillable(schedule, timesheet)

Returns `true` if all the waypoints in `schedule` have departure and
arrival times satisfying the `timesheet`, or `false` otherwise.
"""
function isfulfillable(schedule, timesheet)
    for (t, v, rid, flag) ∈ schedule
        (e, l) = timesheet[rid]

        if flag && t < e
            return false
        end

        if !flag && t > l
            return false
        end

    end
    true
end
