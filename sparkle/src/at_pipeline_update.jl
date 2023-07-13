macro pipeline_update(s)

    update = quote
        S[sid′,:] = update(S[sid′,:], sid′, R[rid,:], rid, c′)
        @debug _dbg*" update S$sid′"
    end

    isequal(s, :mapr) ?
        esc(quote
            if !iszero(sid′)
                $update
                Base.release(slock[sid′])
                @debug _dbg*" released S$sid′ ($(time()))"
            end
        end) :

    isequal(s, :tick) ?
        esc(quote
            if !iszero(sid′)
                $update
                @checkout tickets[sid′] sid′ _dbg
            end
        end) :

   (isequal(s, :none) || isequal(s, :simp) || isequal(s, :excl)) ?
        esc(quote
            if !iszero(sid′)
                $update
            end
        end) :

    nothing
end
