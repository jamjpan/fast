macro cost_i_beg_j_end(m)
       t1 = :(schedule[1][1])
       v1 = :(schedule[1][2])

       tl = :(schedule[end][1])
       vl = :(schedule[end][2])

    v0_ro = :(@d $m  vinit origin)
    v0_v1 = :(@d $m  vinit    $v1)
    ro_v1 = :(@d $m origin    $v1)

    vl_rd = :(@d $m $vl destination)

    esc(quote
        v0_ro = $v0_ro
        v0_v1 = $v0_v1
        ro_v1 = $ro_v1
        vl_rd = $vl_rd
           t1 = $t1
           tl = $tl

          ΔFi = v0_ro + ro_v1 - v0_v1
          ΔFj = vl_rd
           ΔF = ΔFi + ΔFj

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(v0_ro, speed) + tinit
            ΔTij = cld(ro_v1, speed) + To - t1

              Td = cld(vl_rd, speed) + tl + ΔTij
            ΔTjl = 0
        end
    end)
end
