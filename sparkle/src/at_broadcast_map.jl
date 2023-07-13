"""
    @broadcast_map l

Expands into bulk-synchronous mapping if `l=λ` or bulk-parallel
mapping if `l=π`.
"""
macro broadcast_map(l)

    isequal(l, :λ) ?
        esc(quote
            C = Dict{Int64, ctype}(
                i => g(d[i,:], i, request, rid) for i ∈ K)
        end) :

    isequal(l, :π) ?
        esc(quote
            # Sometimes we get "UndefRefError". The issue is
            # inconsistent but each time it appears, the stack trace
            # points to C. Wrapping C inside a lock seems to prevent
            # the issue, but there is a performance hit. Preallocating
            # seems to be a workaround, but not sure if robust.
            C = Dict{Int64, ctype}(i => cmax for i ∈ K)
            #Clk = Base.Semaphore(1)
            Threads.@threads for i ∈ K
                gv = g(d[i,:], i, request, rid)
                #Base.acquire(Clk)
                C[i] = gv
                #Base.release(Clk)
            end
        end) :

    nothing
end
