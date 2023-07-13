macro broadcast(l1, l2)

    innerbody = quote
        @broadcast_map $l2
        @broadcast_reduce
        @broadcast_update
    end

    innerloop =
        isequal(l1, :λ) ? innerbody :
        isequal(l1, :π) ? :(@exclusive $innerbody) :
        nothing

    esc(quote
        @broadcast_outer $l1 begin
            hook_request_setup(request, rid)
            @prune
            isempty(K) && continue
            $innerloop
            hook_request_teardown(request, rid)
        end
    end)
end
