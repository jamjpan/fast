function capprune(cands, captab, load, capacity)
    filter(p -> captab[p] + load ≤ capacity, cands)
end
