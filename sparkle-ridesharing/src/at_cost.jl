macro cost(mode, m)
    l = :(length(schedule) + 1)

    head_i = :(i ==  1)
    tail_i = :(i == $l)
     mid_i = :(1 < i && i < $l)

    head_j = :(j ==  1)
    tail_j = :(j == $l)
     mid_j = :(i ≤ j && j < $l)

    isequal(mode, :i)  ?
        esc(quote
                if $head_i @cost_i_beg $m
            elseif $tail_i @cost_i_end $m
            elseif  $mid_i @cost_i_mid $m
            else
                error("bounds error, i=", i, ", l=", $l)
            end
        end) :

    isequal(mode, :ij) ?
        esc(quote
                if ($head_i && $head_j &&  i==j) @cost_i_beg_j_beg $m
            elseif ($head_i &&  $mid_j &&  i ≠j) @cost_i_beg_j_mid $m
            elseif ($head_i && $tail_j &&  i ≠j) @cost_i_beg_j_end $m
            elseif ( $mid_i &&  $mid_j &&  i==j) @cost_i_mid_j_mid $m
            elseif ( $mid_i &&  $mid_j &&  i ≠j) @cost_i_mid_j_mid $m
            elseif ( $mid_i && $tail_j &&  i ≠j) @cost_i_mid_j_end $m
            elseif ($tail_i && $tail_j &&  i==j) @cost_i_end_j_end $m
            else
                error("bounds error, i=", i, ", j=", j, ", l=", $l)
            end
        end) :

    nothing
end
