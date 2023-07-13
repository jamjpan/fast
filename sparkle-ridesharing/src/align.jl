"""
    align(V, p)

Returns (distance, row-index) of the point in `V` that is nearest to
point `p`, based on l2-norm.
"""
align(V, p) = findmin(q -> hypot(q[1] - p[1], q[2] - p[2]), eachrow(V))
