macro inquire()
    esc(quote
        _ticket = "'$(tickets[sid][2])'"*
            " (head: '$(ticket_queue[sid][begin][2])')"

        if isequal(ticket_queue[sid][begin], tickets[sid])
            @debug _inner_dbg*" at head "*_ticket*" ($(time()))"
        else
            @debug _inner_dbg*" wait "*_ticket*" ($(time()))"
            wait(tickets[sid][1])
            @debug _inner_dbg*" notified "*_ticket*" ($(time()))"
        end
    end)
end
