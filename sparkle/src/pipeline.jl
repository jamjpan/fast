pipeline!(S, R, L1::Level{:λ}, L2::Level{:λ};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline λ λ none

pipeline!(S, R, L1::Level{:λ}, L2::Level{:π};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline λ π simp

pipeline!(S, R, L1::Level{:π}, L2::Level{:λ}, LS::LockScheme{:none};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @error "Not supported"

pipeline!(S, R, L1::Level{:π}, L2::Level{:λ}, LS::LockScheme{:simp};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @error "Not supported"

pipeline!(S, R, L1::Level{:π}, L2::Level{:λ}, LS::LockScheme{:excl};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline π λ excl

pipeline!(S, R, L1::Level{:π}, L2::Level{:λ}, LS::LockScheme{:mapr};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline π λ mapr

pipeline!(S, R, L1::Level{:π}, L2::Level{:λ}, LS::LockScheme{:tick};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline π λ tick

pipeline!(S, R, L1::Level{:π}, L2::Level{:π}, LS::LockScheme{:none};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @error "Not supported"

pipeline!(S, R, L1::Level{:π}, L2::Level{:π}, LS::LockScheme{:simp};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @error "Not supported"

pipeline!(S, R, L1::Level{:π}, L2::Level{:π}, LS::LockScheme{:excl};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline π π excl

pipeline!(S, R, L1::Level{:π}, L2::Level{:π}, LS::LockScheme{:mapr};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline π π mapr

pipeline!(S, R, L1::Level{:π}, L2::Level{:π}, LS::LockScheme{:tick};
    g, φ, prune, update, cmax=Inf, g′=nothing) =
        @pipeline π π tick
