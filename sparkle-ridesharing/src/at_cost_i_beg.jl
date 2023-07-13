macro cost_i_beg(m)
       t1 = :(schedule[1][1])
       v1 = :(schedule[1][2])

    v0_ro = :(@d $m  vinit origin)
    v0_v1 = :(@d $m  vinit    $v1)
    ro_v1 = :(@d $m origin    $v1)

    esc(quote
        v0_ro = $v0_ro
        v0_v1 = isempty(schedule) ? 0 : $v0_v1
        ro_v1 = isempty(schedule) ? 0 : $ro_v1
           t1 = isempty(schedule) ? 0 : $t1

           ΔF = v0_ro + ro_v1 - v0_v1

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(v0_ro, speed) + tinit
            ΔTil = cld(ro_v1, speed) + To - t1
        end
    end)
end
