macro cost_i_mid(m)
       tp = :(schedule[i-1][1])
       vp = :(schedule[i-1][2])

       tn = :(schedule[i-0][1])
       vn = :(schedule[i-0][2])

    vp_ro = :(@d $m    $vp  origin)
    ro_vn = :(@d $m origin     $vn)
    vp_vn = :(@d $m    $vp     $vn)

    esc(quote
        vp_ro = $vp_ro
        ro_vn = $ro_vn
        vp_vn = $vp_vn
           tp = $tp
           tn = $tn

           ΔF = vp_ro + ro_vn - vp_vn

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(vp_ro, speed) + tp
            ΔTil = cld(ro_vn, speed) + To - tn
        end
    end)
end
