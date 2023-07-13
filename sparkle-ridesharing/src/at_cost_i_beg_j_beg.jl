macro cost_i_beg_j_beg(m)
       t1 = :(schedule[1][1])
       v1 = :(schedule[1][2])

    v0_ro = :(@d $m       vinit      origin)
    v0_v1 = :(@d $m       vinit         $v1)
    rd_v1 = :(@d $m destination         $v1)
    ro_rd = :(@d $m      origin destination)

    esc(quote
        v0_ro = $v0_ro
        ro_rd = $ro_rd
        v0_v1 = isempty(schedule) ? 0 : $v0_v1
        rd_v1 = isempty(schedule) ? 0 : $rd_v1
           t1 = isempty(schedule) ? 0 : $t1

           ΔF = v0_ro + ro_rd + rd_v1 - v0_v1

        if !isnan(ΔF) && !isinf(ΔF)
              To = cld(v0_ro, speed) + tinit
            ΔTij = 0

              Td = cld(ro_rd, speed) + To
            ΔTjl = cld(rd_v1, speed) + Td - t1
        end
    end)
end
