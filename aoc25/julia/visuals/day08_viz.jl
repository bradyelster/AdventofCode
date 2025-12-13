# Brady Elster  
# Advent of Code 2025 - Day 08

using Plots

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

        # Attempt to connect, whether it merges or not
        union!(uf, i, j)
        connections += 1
        connections == limit && break
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

function visualize_connections(pts, edges; limit=1000, skip_frames=1)
    pt_index = build_point_index(pts)
    n = length(pts)

    # Track all connections and circuit assignments at each step
    all_connections = []
    all_circuit_colors = []

    # Use Plots.jl color palette
    # Color index 0 = gray for unconnected points
    # Color indices 1-20 = distinct colors for circuits
    palette_colors = Plots.palette(:tab20)
    next_color_idx = 1
    circuit_to_color = Dict{Int,Int}()  # maps circuit root to color index (0 = gray, 1-20 = colors)

    # First pass: simulate all connections
    uf = UnionFind(n)
    for conn in 1:limit
        e = edges[conn]
        i = pt_index[e.p1]
        j = pt_index[e.p2]

        # Get roots before union
        root_i = find(uf, i)
        root_j = find(uf, j)

        # Assign colors to circuits being connected (if they don't have one)
        # Don't assign color 0 (gray) - start from 1
        if !haskey(circuit_to_color, root_i)
            circuit_to_color[root_i] = next_color_idx
            next_color_idx = mod1(next_color_idx + 1, 20) + 1  # cycle through 1-20
            if next_color_idx > 20
                next_color_idx = 1
            end
        end
        if !haskey(circuit_to_color, root_j)
            circuit_to_color[root_j] = next_color_idx
            next_color_idx = mod1(next_color_idx + 1, 20) + 1
            if next_color_idx > 20
                next_color_idx = 1
            end
        end

        # Perform union
        was_merged = union!(uf, i, j)

        # If merged, larger circuit keeps its color
        if was_merged
            new_root = find(uf, i)
            # Keep the color of the larger circuit
            if root_i == new_root
                circuit_to_color[new_root] = circuit_to_color[root_i]
            else
                circuit_to_color[new_root] = circuit_to_color[root_j]
            end
        end

        # Store connection
        push!(all_connections, (e, was_merged))

        # Store current color assignment for all points
        current_colors = Dict{Int,Int}()
        for pt_idx in 1:n
            root = find(uf, pt_idx)
            # If root has a color, use it; otherwise use 0 (gray for unconnected)
            if haskey(circuit_to_color, root)
                current_colors[pt_idx] = circuit_to_color[root]
            else
                current_colors[pt_idx] = 0  # gray for unconnected
            end
        end
        push!(all_circuit_colors, current_colors)
    end

    # Find points in circuits of size >= 10
    final_sizes = component_sizes(uf, n)
    points_in_large_circuits = Set{Int}()
    for pt_idx in 1:n
        root = find(uf, pt_idx)
        if uf.sz[root] >= 9
            push!(points_in_large_circuits, pt_idx)
        end
    end

    println("Found $(length(points_in_large_circuits)) points in circuits of size >= 9")

    # Second pass: create animation
    anim = @animate for conn in 1:skip_frames:limit
        # Get current state
        color_map = all_circuit_colors[conn]

        # Extract coordinates for ALL points
        xs = Float64[]
        ys = Float64[]
        zs = Float64[]
        cs = []  # Color array

        for pt_idx in 1:n
            push!(xs, pts[pt_idx][1])
            push!(ys, pts[pt_idx][2])
            push!(zs, pts[pt_idx][3])

            # Only color points that end up in circuits >= 10
            if pt_idx in points_in_large_circuits
                color_idx = color_map[pt_idx]
                if color_idx == 0
                    push!(cs, :gray)  # Not yet connected
                else
                    push!(cs, palette_colors[color_idx])
                end
            else
                push!(cs, :gray)  # Points not in large circuits stay gray
            end
        end

        # Create the plot
        p = scatter(xs, ys, zs,
            markersize=4,
            markercolor=cs,
            markerstrokewidth=0,
            label="",
            xlabel="",
            ylabel="",
            zlabel="",
            camera=(45, 30),
            legend=false,
            showaxis=false,
            grid=true,
            dpi=300)

        # Draw all connected edges up to this point
        for idx in 1:conn
            edge, _ = all_connections[idx]
            i = pt_index[edge.p1]
            j = pt_index[edge.p2]

            # Determine edge color based on whether points are in large circuits
            if i in points_in_large_circuits && j in points_in_large_circuits
                # Both points in large circuits - use circuit color
                edge_color_idx = color_map[i]
                edge_color = edge_color_idx == 0 ? :gray : palette_colors[edge_color_idx]
            else
                # At least one point not in large circuit - use gray
                edge_color = :lightgray
            end

            plot!(p, [edge.p1[1], edge.p2[1]],
                [edge.p1[2], edge.p2[2]],
                [edge.p1[3], edge.p2[3]],
                color=edge_color,
                alpha=0.3,
                linewidth=1.5,
                label="")
        end
    end

    return anim, uf
end

function main()
    pts = read_data_pts("input/day08.txt")
    edges = sort_edges(pts)

    println("Creating animation...")
    # skip_frames: only render every Nth frame to speed up animation
    # For 1000 connections, you might want skip_frames=10 to get ~100 frames
    anim, uf = visualize_connections(pts, edges, limit=1000, skip_frames=10)

    # Save animation as MP4
    mp4(anim, "circuit_connections.mp4", fps=15)
    println("Animation saved to circuit_connections.mp4")

    # Calculate answer
    sizes = component_sizes(uf, length(pts))
    println("Three largest circuits: ", sizes[1:3])
    answer = sizes[1] * sizes[2] * sizes[3]
    println("Answer: ", answer)
end

main()