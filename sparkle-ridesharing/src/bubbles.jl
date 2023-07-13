"""
    bubbles(schedule, timesheet)

Returns the slack bubbles along every segment in `schedule`.
"""
function bubbles(schedule, timesheet, triplengths;
        edges, speed, cache=nothing, addtocache=false, cachesize=0)

    slack = zeros(length(schedule))

    for k ∈ eachindex(schedule)
        (t, v, rid, flag) = schedule[k]
        (e, l) = timesheet[rid]

        deadline = flag ? l - cld(triplengths[rid], speed) : l
        slack[k] = deadline - t
    end

    widths = zeros(length(schedule))

    if isempty(widths)
        return widths
    end

    # The first bubble is around the vehicle's location and its first
    # scheduled location. This "bubble" is already specified by the
    # proximity range during proximity pruning, so no need to
    # calculate it here.
    widths[1] = Inf

    for k ∈ 2:length(schedule)
        v1 = schedule[k-1][2]
        v2 = schedule[k-0][2]
        widths[k] = slack[k]*speed + @d sp v1 v2
    end

    widths
end
