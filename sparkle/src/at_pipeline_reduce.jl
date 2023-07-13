macro pipeline_reduce(l)

    innerbody = quote
        @debug _inner_dbg*" map onto (S$sid, $c) incumbent=(S$sid′, $c′)"
        if c < c′ && f
            (sid′, c′) = (sid, c)
        end
        @debug _inner_dbg*" reduce into (S$sid′, $c′)"
    end

    isequal(l, :unprotected) ? esc(innerbody) :
    isequal(l, :protected  ) ? esc(:(@protect $innerbody)) :
    nothing
end
