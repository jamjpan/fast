macro cost_i_end_j_end(m)
       tl = :(schedule[end][1])
       vl = :(schedule[end][2])

    vl_ro = :(@d $m    $vl      origin)
    ro_rd = :(@d $m origin destination)

    esc(quote
        vl_ro = $vl_ro
        ro_rd = $ro_rd
           tl = $tl

           ΔF = vl_ro + ro_rd

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(vl_ro, speed) + tl
            ΔTij = 0

              Td = cld(ro_rd, speed) + To
            ΔTjl = 0
        end
    end)
end
