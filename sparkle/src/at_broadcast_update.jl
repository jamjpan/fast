"""
    @broadcast_update

Expands into the record updater used with the broadcast engine.
"""
macro broadcast_update()
    esc(quote
        if !iszero(i′)
            d[i′,:] = update(d[i′,:], i′, request, rid, c′)
        end
    end)
end
