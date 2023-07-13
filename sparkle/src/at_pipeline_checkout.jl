macro pipeline_checkout()
    esc(quote
        @debug _inner_dbg*" map onto (S$sid, $c) incumbent=(S$sid′, $c′)"
        if c < c′ && f
            if !iszero(sid′)
                @checkout tickets[sid′] sid′ _inner_dbg
                @debug _inner_dbg*" released S$sid′ ($(time()))"
            end
            (sid′, c′) = (sid, c)
            @debug _inner_dbg*" reduce into (S$sid′, $c′)"
        else
            @checkout tickets[sid] sid _inner_dbg
            @debug _inner_dbg*" released S$sid ($(time()))"
        end
    end)
end
