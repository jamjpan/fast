macro pipeline_mapreduce(L1, L2, LS)

    innerloop =

      ((isequal(L1, :λ) && isequal(L2, :λ) && isequal(LS, :none)) ||
       (isequal(L1, :π) && isequal(L2, :λ) && isequal(LS, :excl))) ?
            quote
                _inner_dbg = _dbg*"[S$sid]"
                @pipeline_gtest unprotected
                if (!h)
                    @pipeline_map
                    @pipeline_reduce unprotected
                end
            end :

      ((isequal(L1, :λ) && isequal(L2, :π) && isequal(LS, :simp)) ||
       (isequal(L1, :π) && isequal(L2, :π) && isequal(LS, :excl))) ?
            quote
                _inner_dbg = _dbg*"[T$(Threads.threadid()) S$sid]"
                @pipeline_gtest protected
                if (!h)
                    @pipeline_map
                    @pipeline_reduce protected
                end
            end :

       (isequal(L1, :π) && isequal(L2, :λ) && isequal(LS, :mapr)) ?
            quote
                _inner_dbg = _dbg*"[S$sid]"
                @pipeline_gtest unprotected
                if (!h)
                    @debug _inner_dbg*" acquiring S$sid ($(time()))"
                    Base.acquire(slock[sid])
                    @pipeline_map
                    @pipeline_release
                end
            end :

       (isequal(L1, :π) && isequal(L2, :λ) && isequal(LS, :tick)) ?
            quote
                _inner_dbg = _dbg*"[S$sid]"
                @pipeline_gtest unprotected
                if (!h)
                    @inquire
                    @pipeline_map
                    @pipeline_checkout
                else
                    @checkout tickets[sid] sid _inner_dbg
                end
            end :

       (isequal(L1, :π) && isequal(L2, :π) && isequal(LS, :mapr)) ?
            quote
                @debug _dbg*" acquiring S$sid ($(time()))"
                # needs to respect the order so it must wait to acquire
                Base.acquire(slock[sid])
                @debug _dbg*" acquired S$sid ($(time()))"
                @async begin
                    _inner_dbg = _dbg*"[T$(Threads.threadid()) S$sid]"
                    @pipeline_gtest protected
                    if (h)
                        Base.release(slock[sid])
                        @debug _inner_dbg*" released S$sid ($(time()))"
                    else
                        @pipeline_map
                        @protect @pipeline_release
                    end
                end
            end :

       (isequal(L1, :π) && isequal(L2, :π) && isequal(LS, :tick)) ?
            quote
                _inner_dbg = _dbg*"[T$(Threads.threadid()) S$sid]"
                @pipeline_gtest protected
                if (!h)
                    @inquire
                    @pipeline_map
                    @protect @pipeline_checkout
                else
                    @checkout tickets[sid] sid _inner_dbg
                end
            end :

            nothing

    esc(quote
        (sid′, c′) = (0, cmax)
        @pipeline_inner $L2 $LS begin
            # _ΔtG[(rid,sid)][1] = (time_ns()-_t₀)/_ms
            $innerloop
            # _ΔtG[(rid,sid)][2] = (time_ns()-_t₀)/_ms
        end
        @pipeline_update $LS
    end)
end
