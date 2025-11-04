# Day One - Advent of Code

function read_input(filepath::String)
    reports = Vector{Int}[]
    open(filepath, "r") do file
        for line in eachline(file)
            # Skip empty lines
            if isempty(strip(line))
                continue
            end

            # Split the line by whitespace and parse the number strings to Ints
            numbers = parse.(Int, split(strip(line)))
            push!(reports, numbers)
        end
    end
    return reports
end

function is_safe(levels::Vector{Int})::Symbol
    if length(levels) < 2
        return :safe
    end
    
    diffs = diff(levels)
    all_increasing = all(d -> d > 0, diffs)
    all_decreasing = all(d -> d < 0, diffs)
    valid_range = all(d -> 1 <= abs(d) <= 3, diffs)
    
    return (all_increasing || all_decreasing) && valid_range ? :safe : :unsafe
end

function is_safe_with_dampener(levels::Vector{Int})::Symbol
    if is_safe(levels) == :safe
        return :safe
    end
    
    for i in 1:length(levels)
        modified = deleteat!(copy(levels), i)
        if is_safe(modified) == :safe
            return :safe
        end
    end
    
    return :unsafe
end

function count_both_parts(filepath::String)
    reports = read_input(filepath)
    part1_count = 0
    part2_count = 0
    
    for report in reports
        if is_safe(report) == :safe
            part1_count += 1
            part2_count += 1
        elseif is_safe_with_dampener(report) == :safe
            part2_count += 1
        end
    end
    
    return (part1_count, part2_count)
end

filepath = joinpath("input", "dayTwo.txt")
part1, part2 = count_both_parts(filepath)
println("Part 1: $part1")
println("Correct? ", part1 == 356)
println("Part 2: $part2")
println("Correct? ", part2 == 413)