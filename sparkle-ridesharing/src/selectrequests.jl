"""
    selectrequests(schedule)

Returns the labels of the assigned requests in `schedule`.
"""
selectrequests(schedule) = unique([w[3] for w ∈ schedule])
