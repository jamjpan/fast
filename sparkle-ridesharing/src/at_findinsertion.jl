macro findinsertion(mode, metric)

    l = :(length(schedule) + 1)

    cands = :(cands = [(i,j) for i ∈ 1:$l for j ∈ i:$l])

    capprune = quote
        if !isnothing(captab)
            cands = capprune(cands, captab, load, capacity)
        end
    end

    bubprune = quote
        if !isnothing(bubbles)
            cands = bubbleprune(cands, bubbles, schedule,
                origin, destination; nodes = nodes)
        end
    end

    do_11  = :((            (  1,1) ∈ cands) && @reduce $metric   1 1)
    do_bpj = :((β′ ≠   0 && ( β′,j) ∈ cands) && @reduce $metric  β′ j)
    do_j1j = :((β′ ≠ j-1 && (j-1,j) ∈ cands) && @reduce $metric j-1 j)
    do_jj  = :((            (  j,j) ∈ cands) && @reduce $metric   j j)
    do_ij  = :((            (  i,j) ∈ cands) && @reduce $metric   i j)

    body =
        isequal(mode, :dp) ?
            quote
                $cands
                $capprune
                $bubprune
                α′ = Inf    # Min cost of i when inserted alone
                β′ = 0      # Min val  of i when inserted alone
                $do_11
                for j ∈ 2:$l
                    if !isempty(filter(p -> p[1] == j-1, cands))
                        @reduce $metric j-1
                    end
                    $do_bpj
                    $do_j1j
                    $do_jj
                end
            end :

        isequal(mode, :nv) ?
            quote
                $cands
                $capprune
                $bubprune
                for i=1:$l, j=i:$l
                    $do_ij
                end
            end :

        nothing

    esc(quote
        c′ = Inf
        b′ = schedule
        i′ = 0
        j′ = 0
        $body
        (c′, b′, i′, j′)
    end)
end
