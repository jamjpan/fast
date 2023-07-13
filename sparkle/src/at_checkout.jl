macro checkout(ticket, sid, dbg)
    esc(quote
        Base.acquire(ticket_master)

        # if !isequal(ticket_queue[$sid][begin], $ticket)
        #     error("ticket out of order")
        # end

        # deleteat!(ticket_queue[$sid], 1)

        idx = findfirst(isequal($ticket), ticket_queue[$sid])

        deleteat!(ticket_queue[$sid], idx)

        if !isempty(ticket_queue[$sid]) && idx == 1
            next = ticket_queue[$sid][begin]
            notify(next[1])
            @debug $dbg*" poked '$(next[2])' ($(time()))"
        end

        Base.release(ticket_master)
    end)
end
