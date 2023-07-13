"""
    @broadcast_reduce

Expands into the reducer used with the broadcast engine.
"""
macro broadcast_reduce()
    esc(quote
        C′= filter(φ, C)
        (i′, c′) = reduce(
            (kv2, kv1) -> kv1.second < kv2.second ? kv1 : kv2, C′;
            init = (0 => cmax))
    end)
end
