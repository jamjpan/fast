"""
    l2norm(p, [q])

Calculates the l2-norm between points `p` and `q`, if given, or the
origin, (0,0), if not given.
"""
l2norm(p) = hypot(p[1], p[2])
l2norm(p, q) = hypot(p[1] - q[1], p[2] - q[2])
