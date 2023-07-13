function bubbleprune(cands, bubbles, schedule, origin, destination;
        nodes)

    i_cands = [1, length(schedule)+1]

    for i ∈ 2:length(schedule)
        a1 = @d l2 schedule[i-1][2] origin
        a2 = @d l2 origin schedule[i-0][2]
        if a1 + a2 ≤ bubbles[i]
            push!(i_cands, i)
        end
    end

    j_cands = [1, length(schedule)+1]

    for j ∈ 2:length(schedule)
        a1 = @d l2 schedule[j-1][2] destination
        a2 = @d l2 destination schedule[j-0][2]
        if a1 + a2 ≤ bubbles[j]
            push!(j_cands, j)
        end
    end

    filter(p -> p[1] ∈ i_cands && p[2] ∈ j_cands, cands)
end
