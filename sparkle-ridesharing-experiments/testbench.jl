using DataStructures
using DelimitedFiles
using Statistics
using Logging

# global_logger(ConsoleLogger(Debug))

_path_to_sparkle,
_path_to_sparkle_ridesharing,
_mode,         # ll, lp, pl, or pp
_lockscheme,   # excl, mapr, tick, nolock
_cache,        # icache, lru, nocache
_bubbles,      # slack, nobubbles
_nrequests,    # e.g. 100
_nvehicles,    # e.g. 100
_tau,          # e.g. 1.2
_kappa,        # e.g. 3
_load,         # e.g. 1
_processors =  # e.g. 4
    ARGS

@info ARGS

include(_path_to_sparkle)
include(_path_to_sparkle_ridesharing)

using .Ridesharing
using .Sparkle

const edgelist =
    "/home/james/data/road/chengdu.csv"

const vehicles =
    "/home/james/data/sets/vehicles/chengdu_20140815_0600_$(_nvehicles).csv"

const requests =
    "/home/james/data/sets/requests/chengdu_20140815_0600_$(_nrequests).csv"

const κ = parse(Int64, _kappa)
const q = parse(Int64,  _load)
const τ = parse(Float64, _tau)
const ν = 10.0  # meters per sec

# Typedefs ############################################################

const Bubbles           = Vector{Float64}
const CandidateCount    = Int64
const Capacity          = Int64
const Coordinate        = Float64
const Distance          = Union{Float64,Int64}
const Link              = Tuple{Int64, Int64}
const Neighbor          = Tuple{Int64, Float64}
const Neighbors         = Vector{Neighbor}
const NodeId            = Int64
const RequestId         = Int64
const Schedule          = Vector{Waypoint}
const ScheduleLength    = Int64
const Time              = Int64
const VehicleId         = Int64

const cmax =
    (Inf, Schedule(), 0, 0)

# State Containers ###################################################

const V::Matrix{Coordinate}, E::Dict{NodeId, Neighbors} =
    loadgraph(edgelist)

const R::Matrix{Union{Time, NodeId, Distance}} =
    loadrequests(requests)

const S::Matrix{Union{NodeId, Coordinate, Schedule}} =
    loadvehicles(vehicles, V)

const n::Int64 = size(R, 1)
const m::Int64 = size(S, 1)

scaletimewindows!(R, τ, ν)

const timesheet::Dict{RequestId, NTuple{2, Time}} =
    Dict(i => (R[i,1], R[i,2]) for i ∈ 1:n)

const tripsheet::Dict{RequestId, Distance} =
    Dict(i => R[i,5] for i ∈ 1:n)

const B::Dict{VehicleId, Bubbles} =
    Dict(i => Bubbles() for i ∈ 1:m)

const G::Dict{VehicleId, Dict{Link, Distance}} =
    Dict(i => Dict() for i ∈ 1:m)

const H::Dict{VehicleId, Dict{Link, Distance}} =
    Dict(i => Dict() for i ∈ 1:m)

# LRU Caches
const LRU::Dict{VehicleId, OrderedDict{Link, Distance}} =
    Dict(i => OrderedDict() for i ∈ 1:m)

# Statistics Containers ##############################################

const _M::Dict{RequestId, CandidateCount} =
    Dict(i => 0 for i ∈ 1:n)

const _L::Dict{RequestId, Dict{VehicleId, ScheduleLength}} =
    Dict(i => Dict(j => -1 for j ∈ 1:m) for i ∈ 1:n)

# Administrative #####################################################

function reset()
    for i ∈ 1:m
        B[i] = Bubbles()
        G[i] = Dict()
        H[i] = Dict()
      LRU[i] = OrderedDict()
    end
    for i ∈ 1:n
        _M[i] = 0
        _L[i] = Dict(j => -1 for j ∈ 1:m)
    end
    GC.gc()
end

function print()
    mean_candidates = mean(values(_M))

    mean_lengths = []
    for rid ∈ 1:n
        lengths = []
        for sid ∈ 1:m
            l = _L[rid][sid]
            if l != -1
                push!(lengths, l)
            end
        end
        if !isempty(lengths)
            push!(mean_lengths, mean(lengths))
        end
    end

    mean_mean_lengths = isempty(mean_lengths) ? 0 : mean(mean_lengths)

    @info "Hardness" mean_candidates mean_mean_lengths
end

# function write(elapsed, R_samples, G_samples)
function write(elapsed, R_samples)
    fout = _mode*
        "-$_lockscheme"*
        "-$_cache"*
        "-$_bubbles"*
        "-n$n"*
        "-m$m"*
        "-t$τ"*
        "-k$κ"*
        "-q$q"*
        "-p$_processors.csv"

    rows = []

    # for (rid,sid) ∈ keys(G_samples)
    #     l = _L[rid][sid]
    #     if l != -1
    #         (G_ts, G_te) = G_samples[(rid,sid)]
    #         (R_ts, R_te) = R_samples[rid]
    #         push!(rows, [ rid, sid, G_ts, G_te, l, R_ts, R_te, _M[rid], elapsed ])
    #     end
    # end

    for rid ∈ 1:n
        R_te = R_samples[rid]
        push!(rows, [ rid, R_te, elapsed ])
    end

    out = zeros(length(rows), 3)
    for i ∈ 1:size(out,1)
        for col ∈ 1:3
            out[i,col] = rows[i][col]
        end
    end

    # header = ["#RID" "SID" "UntilGStart(ms)" "UntilGEnd(ms)" "Length" "UntilRStart(ms)" "UntilREnd(ms)" "Cands" "TotalElapsed(ms)" ]
    # open(fout, "w") do io writedlm(io, [header; out], ',') end
    header = ["#RID" "UntilREnd(ms)" "TotalElapsed(ms)" ]
    open(fout, "w") do io writedlm(io, [header; out], ',') end
end

# Functions ##########################################################

function prune(d, request, rid)
    locations = convert(Array{Float64,2}, d[:,2:3])
       origin = request[3]
       reqlen = request[5]
            K = neighbors(locations, V[origin,:], reqlen*(τ - 1))
    _M[rid] = length(K)
    K
end

function g(record, record_id, request, rid)
          vinit = record[1]
       schedule = record[4]
         origin = request[3]
    destination = request[4]

    _L[rid][record_id] = length(schedule)

    ### Cache Control #####
    if isequal(_cache, "icache")
        prime!(H[record_id], schedule, origin, destination, record[1]; edges=E)
        H[record_id][(origin, destination)] = request[5]
    end
    cache =
        isequal(_cache, "icache") ? merge(G[record_id], H[record_id]) :
        isequal(_cache, "lru"   ) ? LRU[record_id] :
        nothing
    addtocache = isequal(_cache, "lru") ? true : false
     cachesize = isequal(_cache, "lru") ? 1000000 : 0
    #######################

    ### Bubbles Control ###
    bubs =
        isequal(_bubbles, "slack") ? B[record_id] : nothing
    #######################

    (c′, b′, i′, j′) = findinsertion(
        schedule, origin, destination, timesheet,
        Mode{:dp}(), Metric{:sp}();
            label = rid,
            nodes = V,
            edges = E,
         capacity = κ,
             load = q,
            tinit = 0,
            vinit = vinit,
            speed = ν,
            cache = cache,
       addtocache = addtocache,
        cachesize = cachesize,
          bubbles = bubs)

    (c′, b′, i′, j′)
end

function φ(_)
    true
end

function g′(record, record_id, request, rid)
       schedule = record[4]
          vinit = record[1]
         origin = request[3]
    destination = request[4]

    ### Bubbles Control ###
    bubs =
        isequal(_bubbles, "slack") ? B[record_id] : nothing
    #######################

    (c′, b′, i′, j′) = findinsertion(
        schedule, origin, destination, timesheet,
        Mode{:dp}(), Metric{:l2}();
            label = rid,
            nodes = V,
            edges = E,
         capacity = κ,
             load = q,
            tinit = 0,
            vinit = vinit,
            speed = ν,
          bubbles = bubs)

    (c′, b′, i′, j′)
end

function update(record, record_id, request, rid, cost)
         origin = request[3]
    destination = request[4]
       schedule = cost[2]
             i′ = cost[3]
             j′ = cost[4]

    ### Bubbles Control ###
    if isequal(_bubbles, "slack")
        B[record_id] = bubbles(schedule, timesheet, tripsheet;
            edges = E,
            speed = ν,
            cache = merge(G[record_id], H[record_id])) # Will be empty if no cache
    end
    #######################

    ### Cache Control #####
    if isequal(_cache, "icache")
        links = perm(H[record_id], schedule, origin, destination, i′, j′, record[1])
        G[record_id] = merge(G[record_id], links)
        H[record_id] = Dict()
    end
    #######################

    r = [ record[1], record[2], record[3], schedule ]
end

# Pre-Run ############################################################

isequal(_mode, "ll") ?
    Sparkle.pipeline!(deepcopy(S), R, Level{:λ}(), Level{:λ}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

isequal(_mode, "lp") ?
    Sparkle.pipeline!(deepcopy(S), R, Level{:λ}(), Level{:π}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

isequal(_mode, "pl") ?
    Sparkle.pipeline!(deepcopy(S), R, Level{:π}(), Level{:λ}(),
        LockScheme{Symbol(_lockscheme)}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

isequal(_mode, "pp") ?
    Sparkle.pipeline!(deepcopy(S), R, Level{:π}(), Level{:π}(),
        LockScheme{Symbol(_lockscheme)}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

println("Mode '$_mode' not supported")

# Test Run ###########################################################

reset()

# (elapsed, R_samples, G_samples) =
(elapsed, R_samples) =

isequal(_mode, "ll") ?
    Sparkle.pipeline!(S, R, Level{:λ}(), Level{:λ}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

isequal(_mode, "lp") ?
    Sparkle.pipeline!(S, R, Level{:λ}(), Level{:π}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

isequal(_mode, "pl") ?
    Sparkle.pipeline!(S, R, Level{:π}(), Level{:λ}(),
        LockScheme{Symbol(_lockscheme)}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

isequal(_mode, "pp") ?
    Sparkle.pipeline!(S, R, Level{:π}(), Level{:π}(),
        LockScheme{Symbol(_lockscheme)}();
        g=g, φ=φ, prune=prune, update=update, cmax=cmax, g′=g′) :

# (0, Dict(), Dict(), Dict())
0

# write(elapsed, R_samples, G_samples)
write(elapsed, R_samples)
print()
