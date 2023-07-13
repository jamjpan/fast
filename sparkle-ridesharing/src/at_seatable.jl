macro seatable(mode)

    i = :(k == i && (Q += -load))
    j = :(k == j && (Q += +load))

    Q = quote
        Q = min(capacity, Q + (schedule[k][4] ? -load : +load))
        Q < 0 && return false
    end

    body =
        isequal(mode, :none) ? :($Q) :
        isequal(mode, :one ) ? :($i; $Q) :
        isequal(mode, :both) ? :($i; $j; $Q) :
        nothing

    boundary =
       (isequal(mode, :one) || isequal(mode, :both)) ?
            quote
                if isequal(i, length(schedule)+1)
                    (Q -= load) < 0 && return false
                end
            end :
        nothing

    esc(quote
        Q = capacity
        for k ∈ eachindex(schedule)
            $body
        end
        $boundary
        true
    end)
end
