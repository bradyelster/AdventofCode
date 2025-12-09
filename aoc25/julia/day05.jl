# Brady Elster
# Advent of Code 2025 - Day 05

using Base: searchsortedlast

# Parse lines into ranges. Handles "a-b" and single numbers "x"
function read_ranges(lines)
    ranges = []
    for line in lines
        parts = split(line, "-")
        if length(parts) == 2
            a, b = parse.(Int, parts)
        elseif length(parts) == 1
            a = parse(Int, parts[1])
            b = a
        else
            error("Invalid line: $line")
        end
        push!(ranges, (a, b))
    end
    # println(ranges)
    return ranges
end

# Merge overlapping or contiguous ranges
function merge_ranges(ranges)
    sort!(ranges)
    merged = []
    s, e = ranges[1]

    for (a, b) in ranges[2:end]
        if a <= e + 1
            e = max(e, b)
        else
            push!(merged, (s, e))
            s, e = a, b
        end
    end
    push!(merged, (s, e))
    println(merged)
    return merged
end

# --- Part One: count how many available IDs are fresh ---
function count_fresh_ids(fresh_ranges, available_ids)
    # merge fresh ranges
    merged = merge_ranges(fresh_ranges)

    # Check membership using binary search
    function is_fresh(x)
        idx = searchsortedlast(first.(merged), x)
        idx == 0 && return false
        a, b = merged[idx]
        return x <= b
    end

    return count(is_fresh, available_ids)
end

# --- Part Two: count total number of IDs considered fresh ---
function total_fresh_ids(fresh_ranges)
    merged = merge_ranges(fresh_ranges)
    sum(b - a + 1 for (a, b) in merged)
end

# --- Main: read input ---
lines = readlines("input/day05.txt")
blank_line = findfirst(==(""), lines)

# fresh ranges: before blank line
fresh_lines = blank_line === nothing ? lines : lines[1:blank_line-1]
fresh_ranges = read_ranges(fresh_lines)

# available IDs: after blank line
available_lines = blank_line === nothing ? String[] : lines[blank_line+1:end]
available_ids = parse.(Int, available_lines)  # assumes only single numbers here

# --- Run Part One ---
part_one = count_fresh_ids(fresh_ranges, available_ids)
println("Part One: $part_one")

# --- Run Part Two ---
part_two = total_fresh_ids(fresh_ranges)
println("Part Two: $part_two")