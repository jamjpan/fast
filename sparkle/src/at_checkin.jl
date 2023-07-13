macro checkin()
    esc(quote
        Base.acquire(ticket_master)
        foreach(sid -> push!(ticket_queue[sid], tickets[sid]), K)
        Base.release(ticket_master)
    end)
end
