# Brady Elster
# Advent of Code 2025 - Day 12

struct Shape
    id::Int
    pattern::Vector{String}
end

struct Problem
    width::Int
    height::Int
    shape_counts::Vector{Int}
end

function parse_input(filename::String)
    shapes = Shape[]
    problems = Problem[]
    lines = readlines(filename)
    i = 1

    while i <= length(lines)
        line = strip(lines[i])

        if occursin(r"^\d+:$", line)
            shape_id = parse(Int, replace(line, ":" => ""))
            pattern = String[]
            i += 1
            while i <= length(lines) && !isempty(strip(lines[i])) && !occursin(':', lines[i])
                push!(pattern, strip(lines[i]))
                i += 1
            end
            push!(shapes, Shape(shape_id, pattern))

        elseif occursin(r"^\d+x\d+:", line)
            parts = split(line, ':')
            dims = split(parts[1], 'x')
            counts = [parse(Int, x) for x in split(strip(parts[2]))]
            push!(problems, Problem(parse(Int, dims[1]), parse(Int, dims[2]), counts))
            i += 1
        else
            i += 1
        end
    end

    return (shapes, problems)
end

function part1(filename::String)
    shapes, problems = parse_input(filename)
    shape_areas = [count(c -> c == '#', join(s.pattern)) for s in shapes]
    # rule out regions with less area than total shape area 
    return count(p -> p.width * p.height >= sum(shape_areas[i] * p.shape_counts[i] for i in 1:length(p.shape_counts)), problems)
end

function main()
    println("Part 1: ", part1("input/day12.txt"))
    # println("Part 2: ", part2("input/day12.txt"))
end

main()