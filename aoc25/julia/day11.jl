# Brady Elster
# Advent of Code 2025 - Day 11

struct Device
    name::String
    children::Vector{Device}
end

function parse_part1(filename::String)
    raw = Dict{String,Vector{String}}()

    # First pass: read lines, store raw children names
    for line in eachline(filename)
        name, rhs = split(line, ":")
        raw[strip(name)] = split(strip(rhs))
    end

    # Collect all names (parents + children), so "out" gets included
    allnames = Set(keys(raw))
    foreach(v -> union!(allnames, v), values(raw))

    # Create empty devices for all names
    devices = Dict(name => Device(name, Device[]) for name in allnames)

    # Second pass: populate children
    for (name, outs) in raw
        for child in outs
            push!(devices[name].children, devices[child])
        end
    end

    return devices
end

# Memory-efficient version: only count paths, don't store them
function count_paths(start::Device, target::String; required::Vector{String}=String[])
    # Memoization cache: maps (node_name, remaining_required_set) -> count of paths
    memo = Dict{Tuple{String,Set{String}},Int}()
    required_set = Set(required)

    function dfs(node::Device, remaining_required::Set{String})
        # Create cache key
        cache_key = (node.name, remaining_required)

        # Check if we've already computed this
        if haskey(memo, cache_key)
            return memo[cache_key]
        end

        # Update remaining required nodes if we've found one
        new_remaining = copy(remaining_required)
        delete!(new_remaining, node.name)

        # Base case: reached target
        if node.name == target
            # Only valid if we've collected all required nodes
            if isempty(new_remaining)
                memo[cache_key] = 1
                return 1
            else
                # Haven't collected all required nodes yet
                memo[cache_key] = 0
                return 0
            end
        end

        # Recursive case: sum counts from all children
        total_count = 0
        for child in node.children
            total_count += dfs(child, new_remaining)
        end

        memo[cache_key] = total_count
        return total_count
    end

    return dfs(start, required_set)
end

# Keep this for Part 1 if you need the actual paths
function all_paths(start::Device, target::String; required::Vector{String}=String[])
    # Memoization cache: maps (node_name, remaining_required_set) -> list of path suffixes
    memo = Dict{Tuple{String,Set{String}},Vector{Vector{String}}}()
    required_set = Set(required)

    function dfs(node::Device, remaining_required::Set{String})
        # Create cache key
        cache_key = (node.name, remaining_required)

        # Check if we've already computed this
        if haskey(memo, cache_key)
            return memo[cache_key]
        end

        # Update remaining required nodes if we've found one
        new_remaining = copy(remaining_required)
        delete!(new_remaining, node.name)

        # Base case: reached target
        if node.name == target
            # Only valid if we've collected all required nodes
            if isempty(new_remaining)
                memo[cache_key] = [[node.name]]
                return [[node.name]]
            else
                # Haven't collected all required nodes yet
                memo[cache_key] = Vector{Vector{String}}()
                return Vector{Vector{String}}()
            end
        end

        # Recursive case: explore children
        all_suffixes = Vector{Vector{String}}()
        for child in node.children
            child_paths = dfs(child, new_remaining)
            for path in child_paths
                push!(all_suffixes, vcat([node.name], path))
            end
        end

        memo[cache_key] = all_suffixes
        return all_suffixes
    end

    return dfs(start, required_set)
end

function part1(filename::String)
    input = parse_part1(filename)
    # Part 1 just needs the count
    num_paths = count_paths(input["you"], "out")
    return num_paths
end

function part2(filename::String)
    input = parse_part1(filename)

    # Find count of all paths from svr to out which include both dac and fft
    paths = count_paths(input["svr"], "out"; required=["dac", "fft"])
    return paths
end

function main()
    println("Part 1: ", part1("input/day11.txt"))
    println("Part 2: ", part2("input/day11.txt"))
end

main()