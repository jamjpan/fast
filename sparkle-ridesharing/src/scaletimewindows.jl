"""
    scaletimewindows!(R, scale, speed)

Sets the "late" time on all requests in `R` to the scaled travel
duration plus the "early" time, rounded up to the nearest integer.
"""
scaletimewindows!(R, scale, speed) =
    foreach(r -> r[2] = ceil(r[1] + r[5]/speed*scale), eachrow(R))
