# Brady Elster  
# Advent of Code 2025 - Day 08

function read_data_pts(filename::String)::Vector{Tuple{Int,Int,Int}}
    pts = Tuple{Int,Int,Int}[]   # vector of 3-int tuples
    for line in eachline(filename)
        nums = parse.(Int, split(line, ","))
        push!(pts, tuple(nums...))
    end
    return pts
end

function calc_dist(pt1::Tuple{Int64,Int64,Int64}, pt2::Tuple{Int64,Int64,Int64})::Float64
    Δx² = (pt2[1] - pt1[1])^2
    Δy² = (pt2[2] - pt1[2])^2
    Δz² = (pt2[3] - pt1[3])^2
    return sqrt(Δx² + Δy² + Δz²)
end

struct Edge
    p1::Tuple{Int,Int,Int}
    p2::Tuple{Int,Int,Int}
    distance::Float64
end

function sort_edges(vec_pts::Vector{Tuple{Int,Int,Int}})
    n = length(vec_pts)
    edges = Edge[]

    for i in 1:n-1
        for j in i+1:n
            p1 = vec_pts[i]
            p2 = vec_pts[j]
            d = calc_dist(p1, p2)
            push!(edges, Edge(p1, p2, d))
        end
    end

    # Sort by distance ascending:
    sort!(edges, by=e -> e.distance)

    return edges
end

function build_point_index(pts)
    d = Dict{Tuple{Int,Int,Int},Int}()
    for (i, p) in enumerate(pts)
        d[p] = i
    end
    return d
end

function run_connections(edges, pt_index, n; limit=1000)
    uf = UnionFind(n)
    connections = 0

    for e in edges
        i = pt_index[e.p1]
        j = pt_index[e.p2]

        # Attempt to connect
        # whether it merges or not, increment by 1
        # stop at 1000 (for part one)
        union!(uf, i, j)
        connections += 1
        if connections == limit
            break
        end
    end
    return uf
end

function component_sizes(uf, n)
    sizes = Int[]
    for i in 1:n
        if find(uf, i) == i
            push!(sizes, uf.sz[i])
        end
    end
    sort!(sizes, rev=true)
    return sizes
end

struct UnionFind
    parent::Vector{Int}
    sz::Vector{Int}
end

function UnionFind(n::Int)
    parent = collect(1:n)
    sz = ones(Int, n)
    return UnionFind(parent, sz)
end

# Find with path compression
function find(uf::UnionFind, x::Int)
    while uf.parent[x] != x
        uf.parent[x] = uf.parent[uf.parent[x]]  # path compression
        x = uf.parent[x]
    end
    return x
end

# Union by size; returns true if merge happened
function union!(uf::UnionFind, a::Int, b::Int)
    ra = find(uf, a)
    rb = find(uf, b)
    ra == rb && return false   # already in same component

    # attach smaller tree to larger
    if uf.sz[ra] < uf.sz[rb]
        ra, rb = rb, ra
    end

    uf.parent[rb] = ra
    uf.sz[ra] += uf.sz[rb]

    return true
end

function num_components(uf::UnionFind, n::Int)
    count = 0
    for i in 1:n
        if find(uf, i) == i
            count += 1
        end
    end
    return count
end

function find_last_merge_edge(edges, pt_index, n)
    uf = UnionFind(n)
    
    for e in edges
        i = pt_index[e.p1]
        j = pt_index[e.p2]
        
        was_merged = union!(uf, i, j)
        
        if was_merged && num_components(uf, n) == 1
            return e
        end
    end
    
    return nothing
end

function calculate_x_product(edge::Edge)
    return edge.p1[1] * edge.p2[1]
end

function part_one(pts)
    # note: i only need 1000 smallest edges, not all 48_000+
    # so there is room for optimization here using a heap/priority queue
    edges = sort_edges(pts)
    pt_index = build_point_index(pts)
    uf = run_connections(edges, pt_index, length(pts), limit=1000) 
    sizes = component_sizes(uf, length(pts))
    return prod(sizes[1:3])
end

function part_two(pts)
    edges = sort_edges(pts)
    pt_index = build_point_index(pts)
    
    last_edge = find_last_merge_edge(edges, pt_index, length(pts))
    
    return last_edge !== nothing ? calculate_x_product(last_edge) : 0
end

function main()
    pts = read_data_pts("input/day08.txt")
    println("Part 1: ", part_one(pts))
    println("Part 2: ", part_two(pts))
end

main()