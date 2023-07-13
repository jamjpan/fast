macro pipeline_map()
    esc(quote
        c = g(S[sid,:], sid, R[rid,:], rid)
        f = φ((sid, c))
    end)
end
