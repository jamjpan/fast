macro pipeline_outer(l1, ls, expr)

    exec = quote
        $expr
        Threads.atomic_add!(_n, 1)
        @info "Progress: $(_n[])/$n ($(round(Int64, _n[]/n*100))%)"
    end

   (isequal(l1, :λ) && (isequal(ls, :none) || isequal(ls, :simp))) ?
        esc(quote
            for rid ∈ 1:n
                $exec
            end
        end) :

   (isequal(l1, :π) && (isequal(ls, :excl) || isequal(ls, :mapr))) ?
        esc(quote
            slock = [ Base.Semaphore(1) for sid ∈ 1:m ]
            Threads.@threads for rid ∈ 1:n
                $exec
            end
        end) :

   (isequal(l1, :π) && (isequal(ls, :tick))) ?
        esc(quote
            ticket_master = Base.Semaphore(1)
            ticket_queue = [
                Vector{Tuple{Threads.Event,String}}()
                for sid ∈ 1:m
            ]
            Threads.@threads for rid ∈ 1:n
                $exec
            end
        end) :

    nothing
end
