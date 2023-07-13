macro insert(mode)
    copy_i_l = quote
        for k = l:-1:i+1
            b[k] =
                (b[k-1][1] + ΔTil,
                 b[k-1][2],
                 b[k-1][3],
                 b[k-1][4])
        end
    end

    copy_j_l = quote
        for k = l:-1:j+2
            b[k] =
               (b[k-2][1] + ΔTjl,
                b[k-2][2],
                b[k-2][3],
                b[k-2][4])
        end
    end

    copy_i_j = quote
        for k = j:-1:i+1
            b[k] =
                (b[k-1][1] + ΔTij,
                 b[k-1][2],
                 b[k-1][3],
                 b[k-1][4])
        end
    end

    ins_o = :(b[i+0] = (To, origin, label, true))
    ins_d = :(b[j+1] = (Td, destination, label, false))

    isequal(mode,  :i) ?
        esc(quote
            b = deepcopy(schedule)
            l = length(schedule) + 1
            resize!(b, l)
            $copy_i_l
            $ins_o
        end) :

    isequal(mode, :ij) ?
        esc(quote
            b = deepcopy(schedule)
            l = length(schedule) + 2
            resize!(b, l)
            $copy_j_l
            $ins_d
            $copy_i_j
            $ins_o
        end) :

    nothing
end
