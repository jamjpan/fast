macro exclusive(expr)
    esc(quote
        for sid ∈ K
            @debug _dbg*" acquiring S$sid ($(time()))"
            Base.acquire(slock[sid])
            @debug _dbg*" acquired S$sid ($(time()))"
        end
        $expr
        for sid ∈ K
            Base.release(slock[sid])
            @debug _dbg*" released S$sid ($(time()))"
        end
    end)
end
