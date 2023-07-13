macro cost_i_mid_j_mid(m)
     tp_i = :(schedule[i-1][1])
     vp_i = :(schedule[i-1][2])

     tn_i = :(schedule[i-0][1])
     vn_i = :(schedule[i-0][2])

     tp_j = :(schedule[j-1][1])
     vp_j = :(schedule[j-1][2])

     tn_j = :(schedule[j-0][1])
     vn_j = :(schedule[j-0][2])

    vp_ro = :(@d $m  $vp_i origin)
    ro_vn = :(@d $m origin  $vn_i)

    vp_rd = :(@d $m       $vp_j destination)
    rd_vn = :(@d $m destination       $vn_j)

    ro_rd = :(@d $m origin destination)

    esc(quote
        if i == j
            vp_ro = $vp_ro
            ro_rd = $ro_rd
            rd_vn = $rd_vn
            vp_vn = (@d $m schedule[i-1][2] schedule[i-0][2])
               tp = $tp_i
               tn = $tn_j

               ΔF = vp_ro + ro_rd + rd_vn - vp_vn

            if !isnan(ΔF) && !isinf(ΔF)
                  To = cld(vp_ro, speed) + tp
                ΔTij = 0

                  Td = cld(ro_rd, speed) + To
                ΔTjl = cld(rd_vn, speed) + Td - tn
            end
        else
            vp_ro = $vp_ro
            ro_vn = $ro_vn
          vp_vn_i = (@d $m schedule[i-1][2] schedule[i-0][2])
             tp_i = $tp_i
             tn_i = $tn_i

            vp_rd = $vp_rd
            rd_vn = $rd_vn
          vp_vn_j = (@d $m schedule[j-1][2] schedule[j-0][2])
             tp_j = $tp_j
             tn_j = $tn_j

              ΔFi = vp_ro + ro_vn - vp_vn_i
              ΔFj = vp_rd + rd_vn - vp_vn_j
               ΔF = ΔFi + ΔFj

            if !isnan(ΔF) && !isinf(ΔF)
                  To = cld(vp_ro, speed) + tp_i
                ΔTij = cld(ro_vn, speed) + To - tn_i

                  Td = cld(vp_rd, speed) + tp_j + ΔTij
                ΔTjl = cld(rd_vn, speed) + Td - tn_j
            end
        end
    end)
end
