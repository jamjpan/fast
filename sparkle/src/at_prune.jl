macro prune()
    esc(quote
        K = prune(S, R[rid,:], rid)
        @debug _dbg*" prune: $(length(K)) records"
    end)
end
