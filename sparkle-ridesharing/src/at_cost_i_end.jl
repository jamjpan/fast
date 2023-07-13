macro cost_i_end(m)
       tl = :(schedule[end][1])
       vl = :(schedule[end][2])

    vl_ro = :(@d $m $vl origin)

    esc(quote
        vl_ro = $vl_ro
           tl = $tl

           ΔF = vl_ro

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(vl_ro, speed) + tl
            ΔTil = 0
        end
    end)
end
