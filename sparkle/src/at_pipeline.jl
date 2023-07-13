macro pipeline(l1, l2, ls)

    innerbody = :(@pipeline_mapreduce $l1 $l2 $ls)

    innerloop =
        isequal(ls, :none) ? innerbody :
        isequal(ls, :simp) ? innerbody :
        isequal(ls, :excl) ? :(@exclusive $innerbody) :
        isequal(ls, :mapr) ? innerbody :
        isequal(ls, :tick) ? innerbody :
        nothing

    esc(quote
        n = size(R,1)
        m = size(S,1)

        # Latency per request
        # _ΔtR = Dict(i => 0.0 for i ∈ 1:n)
        _ΔtR = zeros(n)

        # Latency per request-record pair
        # _ΔtG = Dict((i,j) => [0.0,#=start=# 0.0#=end=#] for i ∈ 1:n, j ∈ 1:m)

        _n = Threads.Atomic{Int}(0)
        _ms = 1000000 # convert ns to ms

        @info "Stopwatch started"
        _t₀ = time_ns()

        try
            @pipeline_outer $l1 $ls begin
                _dbg = "[T$(Threads.threadid()) R$rid]"
                @prune
                if isempty(K)
                    @debug _dbg*" no candidates, nothing to do"
                else
                    $innerloop
                end
                _ΔtR[rid] = (time_ns()-_t₀)/_ms
            end
        catch e
            error(e)
        end

        _t₁ = time_ns()
        _elapsed = (_t₁-_t₀)/_ms

        @info "Stopwatch stopped (elapsed: $_elapsed ms)"
        # (_elapsed, _ΔtR, _ΔtG)
        (_elapsed, _ΔtR)
    end)
end
