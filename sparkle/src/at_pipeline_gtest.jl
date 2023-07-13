macro pipeline_gtest(l)

    comparison =
        isequal(l, :unprotected) ? :(h = (hv > c′)) :
        isequal(l, :protected)   ? :(@protect h = (hv > c′)) :
        nothing

    esc(quote
        h = false
        if isnothing(g′)
            @debug _inner_dbg*" no heuristic available"
        else
            hv = g′(S[sid,:], sid, R[rid,:], rid)
            $comparison
            @debug _inner_dbg*" heuristic skip: $h (value=$hv, c′=$c′)"
        end
    end)
end
