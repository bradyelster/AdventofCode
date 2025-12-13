# Brady Elster
# Advent of Code 2025 - Day XX

function parse_part1(filename::String)
    for line in eachline(filename)
    end
end

function part1(filename::String)
    input = parse_part1(filename)
end

function parse_part2(filename::String)
    parse_part1(filename)
end

function part2(filename::String)
    input = parse_part1(filename)
end

function main()
    println("Part 1: ", part1("input/dayXX.txt"))
    println("Part 2: ", part2("input/dayXX.txt"))
end

function __init__()
    if abspath(PROGRAM_FILE) == @__FILE__
        main()
    end
end