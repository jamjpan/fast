macro pipeline_release()
    esc(quote
        @debug _inner_dbg*" map onto (S$sid, $c) incumbent=(S$sid′, $c′)"
        if c < c′ && f
            if !iszero(sid′)
                Base.release(slock[sid′])
                @debug _inner_dbg*" released S$sid′ ($(time()))"
            end
            (sid′, c′) = (sid, c)
            @debug _inner_dbg*" reduce into (S$sid′, $c′)"
        else
            Base.release(slock[sid])
            @debug _inner_dbg*" released S$sid ($(time()))"
        end
    end)
end
