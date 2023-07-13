"""
    @broadcast_outer l expr

Expands into a sequential request loop if `l=λ` or a concurrent
request loop if `l=π`. The `expr` is executed within the loop body.
"""
macro broadcast_outer(l, expr)

    isequal(l, :λ) ?
        esc(quote
            @debug "λ-broadcast" Threads.nthreads()
            for rid ∈ 1:size(R,1)
                request = R[rid,:]
                $expr
            end
        end) :

    isequal(l, :π) ?
        esc(quote
            @debug "π-broadcast" Threads.nthreads()
            L = [ Base.Semaphore(1) for _ ∈ 1:size(d,1) ]
            Threads.@threads for rid ∈ 1:size(R,1)
                request = R[rid,:]
                $expr
            end
        end) :

    nothing
end
