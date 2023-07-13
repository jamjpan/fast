macro cost_i_beg_j_mid(m)
       t1 = :(schedule[1][1])
       v1 = :(schedule[1][2])

       tp = :(schedule[j-1][1])
       vp = :(schedule[j-1][2])

       tn = :(schedule[j-0][1])
       vn = :(schedule[j-0][2])

    v0_ro = :(@d $m  vinit origin)
    v0_v1 = :(@d $m  vinit    $v1)
    ro_v1 = :(@d $m origin    $v1)

    vp_rd = :(@d $m         $vp destination)
    rd_vn = :(@d $m destination         $vn)
    vp_vn = :(@d $m         $vp         $vn)

    esc(quote
        v0_ro = $v0_ro
        v0_v1 = $v0_v1
        ro_v1 = $ro_v1
        vp_rd = $vp_rd
        rd_vn = $rd_vn
        vp_vn = $vp_vn
           t1 = $t1
           tp = $tp
           tn = $tn

          ΔFi = v0_ro + ro_v1 - v0_v1
          ΔFj = vp_rd + rd_vn - vp_vn
           ΔF = ΔFi + ΔFj

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(v0_ro, speed) + tinit
            ΔTij = cld(ro_v1, speed) + To - t1

              Td = cld(vp_rd, speed) + tp + ΔTij
            ΔTjl = cld(rd_vn, speed) + Td - tn
        end
    end)
end
