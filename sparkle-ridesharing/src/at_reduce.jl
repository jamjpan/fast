macro reduce(m, i, j...)

    ins = isempty(j) ?
    :(insert(schedule, origin, $i, Metric{$m}();
            nodes=nodes, edges=edges, tinit=tinit, vinit=vinit,
            speed=speed, cache=cache, addtocache=addtocache,
            cachesize=cachesize, label=label)) :

    :(insert(schedule, origin, $i, destination, $(j[1]), Metric{$m}();
            nodes=nodes, edges=edges, tinit=tinit, vinit=vinit,
            speed=speed, cache=cache, addtocache=addtocache,
            cachesize=cachesize, label=label))

    # If captab is used, there is no need need for isseatable!
    cap = isempty(j) ?
        :(isseatable(schedule, capacity, load, $i)) :
        :(isseatable(schedule, capacity, load, $i, $(j[1])))

    map = isempty(j) ?
        :((α, b) = $ins) :
        :((c, b) = $ins)

    ddl = isempty(j) ?
        :(isfulfillable(b, timesheet) && α < α′) :
        :(isfulfillable(b, timesheet) && c < c′)

    # red = isempty(j) ?
    #     :((α′, i′) = (α, $i)) :
    #     :((c′, b′, i′, j′) = (c, b, $i, $(j[1])))

    red = isempty(j) ?
        quote
            # @debug "Reduce i" old_α=α′ old_β=β′ new_α=α new_i=$i
            (α′, β′) = (α, $i)
        end :
        quote
            # @debug "Reduce ij" old_c=c′ old_b=b′ old_i=i′ old_j=j′ new_c=c new_b=b new_i=$i new_j=$(j[1])
            (c′, b′, i′, j′) = (c, b, $i, $(j[1]))
        end

    esc(quote
        if $cap
            $map
            if $ddl
                $red
            end
        end
    end)
end
