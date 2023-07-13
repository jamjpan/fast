broadcast!(d, R, L1::Level{:λ}, L2::Level{:λ};
    g, φ, prune, update, ctype=Float64, cmax=Inf,
    hook_request_setup, hook_request_teardown) = @broadcast λ λ

broadcast!(d, R, L1::Level{:λ}, L2::Level{:π};
    g, φ, prune, update, ctype=Float64, cmax=Inf,
    hook_request_setup, hook_request_teardown) = @broadcast λ π

broadcast!(d, R, L1::Level{:π}, L2::Level{:λ};
    g, φ, prune, update, ctype=Float64, cmax=Inf,
    hook_request_setup, hook_request_teardown) = @broadcast π λ

broadcast!(d, R, L1::Level{:π}, L2::Level{:π};
    g, φ, prune, update, ctype=Float64, cmax=Inf,
    hook_request_setup, hook_request_teardown) = @broadcast π π
