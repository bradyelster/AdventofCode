# Brady Elster
# Advent of Code 2025 - Day 09

function parse_part1(filename::String)::Vector{Tuple{Int64,Int64}}
    # Read all red tile coordinates and convert to 1-based (row, col) format
    coords::Vector{Tuple{Int64,Int64}} = []
    for line in eachline(filename)
        v = parse.(Int64, split(line, ","))
        push!(coords, (v[2] + 1, v[1] + 1))
    end
    return coords
end

function part1(filename::String)::Int64
    coords = parse_part1(filename)

    # Find maximum area between any two points
    max_area::Int64 = 0
    n::Int64 = length(coords)

    for i in 1:n
        for j in (i+1):n
            r1, c1 = coords[i]
            r2, c2 = coords[j]
            # area must include both corners (hence the +1)
            area = (abs(r2 - r1) + 1) * (abs(c2 - c1) + 1)
            max_area = max(max_area, area)
        end
    end

    return max_area
end

function part2(filename::String)
    puzzle_input = read(filename, String)
    corners = [tuple(parse.(Int, split(line, ','))...) for line in split(strip(puzzle_input), '\n')]
    n = length(corners)

    function get_size(x1, y1, x2, y2)
        x = abs(x1 - x2) + 1
        y = abs(y1 - y2) + 1
        return x * y
    end

    edges = []
    sizes = []

    for i in 1:n
        push!(edges, sort([corners[i], corners[i == 1 ? n : i - 1]]))
        for j in (i+1):n
            c1, c2 = sort([corners[i], corners[j]])
            push!(sizes, (get_size(c1..., c2...), c1, c2))
        end
    end

    sort!(edges, by=e -> get_size(e[1]..., e[2]...), rev=true)
    sort!(sizes, rev=true)

    for (size, (x1, y1), (x2, y2)) in sizes
        y1, y2 = extrema([y1, y2])

        if !any(
            (x4 > x1 && x3 < x2 && y4 > y1 && y3 < y2)
            for ((x3, y3), (x4, y4)) in edges
        )
            return size
        end
    end

    return 0
end

function main()
    input = "input/day09.txt"
    @time println("Part 1: ", part1(input))
    @time println("Part 2: ", part2(input))
end

main()