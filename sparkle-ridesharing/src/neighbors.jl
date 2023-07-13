"""
    neighbors(V, p, ε)

Returns keys of `V` where the l2-norm between the point stored in the
key and the point `p` is less than or equal to `ε`.
"""
neighbors(V, p, ε) =
    findall(q -> hypot(q[1]-p[1], q[2]-p[2]) ≤ ε, eachrow(V))
