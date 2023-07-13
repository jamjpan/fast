macro pipeline_inner(l2, ls, expr)

   (isequal(l2, :λ) && !isequal(ls, :tick)) ?
        esc(quote
            for sid ∈ K
                $expr
            end
        end) :

   (isequal(l2, :λ) && isequal(ls, :tick)) ?
        esc(quote
            tickets = Dict(sid =>
              ( Threads.Event(),
                "T$(Threads.threadid())-R$rid" ) for sid ∈ K)
            @checkin
            for sid ∈ K
                $expr
            end
        end) :

   (isequal(l2, :π) && (isequal(ls, :simp) || isequal(ls, :excl))) ?
        esc(quote
            master = Base.Semaphore(1)
            Threads.@threads for sid ∈ K
                $expr
            end
        end) :

   (isequal(l2, :π) && isequal(ls, :mapr)) ?
        esc(quote
            master = Base.Semaphore(1)
            # Need to access candidates in order, so we use
            # `@sync for` instead of `@threads for`.
            @sync for sid ∈ K
                $expr
            end
        end) :

   (isequal(l2, :π) && isequal(ls, :tick)) ?
        esc(quote
            master = Base.Semaphore(1)
            tickets = Dict(sid =>
              ( Threads.Event(),
                "T$(Threads.threadid())-R$rid" ) for sid ∈ K)
            @checkin
            Threads.@threads for sid ∈ K
                $expr
            end
        end) :

    nothing
end
