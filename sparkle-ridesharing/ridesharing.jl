module Ridesharing

using Dates
using DataStructures
using DelimitedFiles
using Random

include("src/metric.jl")
include("src/mode.jl")
include("src/waypoint.jl")

export Metric
export Mode
export Waypoint
export @cost
export @cost_i_beg
export @cost_i_beg_j_beg
export @cost_i_beg_j_end
export @cost_i_beg_j_mid
export @cost_i_end
export @cost_i_end_j_end
export @cost_i_mid
export @cost_i_mid_j_end
export @cost_i_mid_j_mid
export @d
export @findinsertion
export @insert
export @reduce
export @seatable
export align
export bubbleprune
export bubbles
export capprune
export captab!
export dijkstra
export findinsertion
export insert
export isfulfillable
export isseatable
export l2norm
export loadgraph
export loadrequests
export loadvehicles
export neighbors
export perm
export popcached!
export prime!
export randvehs!
export scaletimewindows!
export selectrequests
export tripstoreqs!

include("src/align.jl")
include("src/at_cost.jl")
include("src/at_cost_i_beg.jl")
include("src/at_cost_i_beg_j_beg.jl")
include("src/at_cost_i_beg_j_end.jl")
include("src/at_cost_i_beg_j_mid.jl")
include("src/at_cost_i_end.jl")
include("src/at_cost_i_end_j_end.jl")
include("src/at_cost_i_mid.jl")
include("src/at_cost_i_mid_j_end.jl")
include("src/at_cost_i_mid_j_mid.jl")
include("src/at_d.jl")
include("src/at_findinsertion.jl")
include("src/at_insert.jl")
include("src/at_reduce.jl")
include("src/at_seatable.jl")
include("src/bubbleprune.jl")
include("src/bubbles.jl")
include("src/capprune.jl")
include("src/captab.jl")
include("src/dijkstra.jl")
include("src/findinsertion.jl")
include("src/insert.jl")
include("src/isfulfillable.jl")
include("src/isseatable.jl")
include("src/l2norm.jl")
include("src/loadgraph.jl")
include("src/loadrequests.jl")
include("src/loadvehicles.jl")
include("src/neighbors.jl")
include("src/perm.jl")
include("src/popcached.jl")
include("src/prime.jl")
include("src/randvehs.jl")
include("src/scaletimewindows.jl")
include("src/selectrequests.jl")
include("src/tripstoreqs.jl")

end
