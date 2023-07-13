"""
    @protect expr

Executes `expr`under a simple lock.
"""
macro protect(expr)
    esc(quote
        Base.acquire(master)
        $expr
        Base.release(master)
    end)
end
