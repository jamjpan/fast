"""
    loadrequests(reqfile)

Returns the requests loaded from `reqfile`.

In the returned requests, late times are set to 0 and are NOT read
from the file. Change using `scaletimewindows` or some other means.
"""
function loadrequests(reqfile)
    raw_R = readdlm(reqfile, ',', Int; skipstart=1)

    max_id = maximum(raw_R[:,1])

    R = fill(0, (max_id, 5))

    for row ∈ eachrow(raw_R)
        rid, re, ro, rd, rL = row
        R[rid,:] = [re, 0, ro, rd, rL]
    end

    R
end
