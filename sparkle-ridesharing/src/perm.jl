function perm(links, b, o, d, i, j, x)
    l = length(b) - 2

    # beg beg
    if i == j && i == 1 && l == 0
        return Dict(
            (x, o) => links[(x, o)],
            (o, d) => links[(o, d)])

    # beg beg
    elseif i == j && i == 1 && l > 0
        return Dict(
            (x, o)         => links[(x, o)],
            (o, d)         => links[(o, d)],
            (d, b[3][2])   => links[(d, b[3][2])])

    # beg mid
    elseif i ≠ j &&  i == 1 && i < j < l+1
        return Dict(
            (x, o)         => links[(x, o)],
            (o, b[2][2])   => links[(o, b[2][2])],
            (b[j][2], d)   => links[(b[j][2], d)],
            (d, b[j+2][2]) => links[(d, b[j+2][2])])

    # beg end
    elseif i ≠ j &&  i == 1 && j == l+1
        return Dict(
            (x, o)         => links[(x, o)],
            (o, b[2][2])   => links[(o, b[2][2])],
            (b[j][2], d)   => links[(b[j][2], d)])

    # mid mid
    elseif i == j && 1 < i < l+1
        return Dict(
            (o, d)         => links[(o, d)],
            (b[i-1][2], o) => links[(b[i-1][2], o)],
            (d, b[i+2][2]) => links[(d, b[i+2][2])])

    # mid mid
    elseif i ≠ j && 1 < i < l+1 && i < j < l+1
        return Dict(
            (b[i-1][2], o) => links[(b[i-1][2], o)],
            (o, b[i+1][2]) => links[(o, b[i+1][2])],
            (b[j][2], d)   => links[(b[j][2], d)],
            (d, b[j+2][2]) => links[(d, b[j+2][2])])

    # mid end
    elseif i ≠ j && 1 < i < l+1 && j == l+1
        return Dict(
            (b[i-1][2], o) => links[(b[i-1][2], o)],
            (o, b[i+1][2]) => links[(o, b[i+1][2])],
            (b[j][2], d)   => links[(b[j][2], d)])

    # end end
    elseif i == j && i == l+1
        return Dict(
            (o, d)         => links[(o, d)],
            (b[i-1][2], o) => links[(b[i-1][2], o)])

    else
        return nothing
    end
end
