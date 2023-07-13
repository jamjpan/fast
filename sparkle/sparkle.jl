module Sparkle

using Statistics

export Level
export LockScheme
export @broadcast
export @broadcast_map
export @broadcast_outer
export @broadcast_reduce
export @broadcast_update
export @checkin
export @checkout
export @exclusive
export @inquire
export @pipeline
export @pipeline_checkout
export @pipeline_gtest
export @pipeline_inner
export @pipeline_map
export @pipeline_mapreduce
export @pipeline_outer
export @pipeline_reduce
export @pipeline_release
export @pipeline_update
export @protect
export @prune
export broadcast!
export pipeline!

include("src/level.jl")
include("src/lockscheme.jl")
include("src/at_broadcast.jl")
include("src/at_broadcast_map.jl")
include("src/at_broadcast_outer.jl")
include("src/at_broadcast_reduce.jl")
include("src/at_broadcast_update.jl")
include("src/at_checkin.jl")
include("src/at_checkout.jl")
include("src/at_exclusive.jl")
include("src/at_inquire.jl")
include("src/at_pipeline.jl")
include("src/at_pipeline_checkout.jl")
include("src/at_pipeline_gtest.jl")
include("src/at_pipeline_inner.jl")
include("src/at_pipeline_map.jl")
include("src/at_pipeline_mapreduce.jl")
include("src/at_pipeline_outer.jl")
include("src/at_pipeline_reduce.jl")
include("src/at_pipeline_release.jl")
include("src/at_pipeline_update.jl")
include("src/at_protect.jl")
include("src/at_prune.jl")
include("src/broadcast.jl")
include("src/pipeline.jl")

end
