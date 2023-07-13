"""
    randvehs!(vehfile, R; ts, n=100)

Writes a random sample of `n` vehicles to file `vehfile`.

Random nodes are selected from request origins to serve as starting
locations. Vehicle start times, which are always 0, are interpreted as
seconds relative to `ts`, which should be a time string in the form
HH:MM:SS.
"""
function randvehs!(vehfile, R; ts, n=100)
    S = zeros(Integer, n, 3)

    for i ∈ 1:n
        S[i,1] = i
        S[i,2] = 0
        S[i,3] = rand(R[:,3])
    end

    hdr = ["SID" "T-"*ts "NODE"]
    open(vehfile, "w") do io writedlm(io, [hdr; S], ',') end

    S
end
