macro cost_i_mid_j_end(m)
       tp = :(schedule[i-1][1])
       vp = :(schedule[i-1][2])

       tn = :(schedule[i-0][1])
       vn = :(schedule[i-0][2])

       tl = :(schedule[end][1])
       vl = :(schedule[end][2])

    vp_ro = :(@d $m    $vp origin)
    ro_vn = :(@d $m origin    $vn)
    vp_vn = :(@d $m    $vp    $vn)

    vl_rd = :(@d $m $vl destination)

    esc(quote
        vp_ro = $vp_ro
        ro_vn = $ro_vn
        vp_vn = $vp_vn
        vl_rd = $vl_rd
           tp = $tp
           tn = $tn
           tl = $tl

          ΔFi = vp_ro + ro_vn - vp_vn
          ΔFj = vl_rd
           ΔF = ΔFi + ΔFj

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(vp_ro, speed) + tp
            ΔTij = cld(ro_vn, speed) + To - tn

              Td = cld(vl_rd, speed) + tl + ΔTij
            ΔTjl = 0
        end
    end)
end
