# Brady Elster
# Advent of Code 2025 - Day 02

function parse_instructions(filename::String)::Vector{Tuple{Int64,Int64}}
    # Read the line and split by commas
    line = readline(filename)
    ranges = split(line, ",")

    # Parse each range into (start, end) tuples
    parsed_ranges = Vector{Tuple{Int64,Int64}}()
    for range_str in ranges
        if isempty(range_str)
            continue
        end
        # Split by dash and parse to Int64
        parts = split(range_str, "-")
        start_id = parse(Int64, parts[1])
        end_id = parse(Int64, parts[2])
        push!(parsed_ranges, (start_id, end_id))
    end
    return parsed_ranges
end

function is_invalid_id_part1(n::Int64)::Bool
    # Convert to string
    s = string(n)
    len = length(s)

    # Must have even number of digits
    if len % 2 != 0
        return false
    end

    # Split into two halves
    half = len ÷ 2
    first_half = s[1:half]
    second_half = s[half+1:end]

    # Check if they're equal
    return first_half == second_half
end

function is_invalid_id_part2(n::Int64)::Bool
    s = string(n)
    len::Int64 = length(s)

    # Need at least 2 digits to repeat at least twice
    if len < 2
        return false
    end

    # Try all possible k ≥ 2 where len % k == 0
    # Only need to check up to len/2 since k > len/2 would mean part_len = 1
    # But k = len is valid (all digits identical)
    max_k = len
    for k::Int64 in 2:max_k
        if len % k != 0
            continue
        end
        part_len::Int64 = len ÷ k
        # Check if all k parts are equal
        valid::Bool = true
        first_part = s[1:part_len]
        for i::Int64 in 1:k-1
            if s[i*part_len+1:(i+1)*part_len] != first_part
                valid = false
                break
            end
        end
        if valid
            return true
        end
    end

    return false
end

function part_one(ranges::Vector{Tuple{Int64,Int64}})::Int64
    total_sum::Int64 = 0

    for (start_id, end_id) in ranges
        # Check each ID in the range
        for n::Int64 in start_id:end_id
            if is_invalid_id_part1(n)
                total_sum += n
            end
        end
    end

    return total_sum
end

function part_two(ranges::Vector{Tuple{Int64,Int64}})::Int64
    total_sum::Int64 = 0

    for (start_id, end_id) in ranges
        # Check each ID in the range
        for n::Int64 in start_id:end_id
            if is_invalid_id_part2(n)
                total_sum += n
            end
        end
    end

    return total_sum
end

# Main execution
instructions::Vector{Tuple{Int64,Int64}} = parse_instructions("input/day02.txt")
println("Part 1: ", part_one(instructions))
println("Part 2: ", part_two(instructions))