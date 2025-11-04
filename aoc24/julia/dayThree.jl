# Day One - Advent of Code

function read_input(filepath::String)
    return read(filepath, String)
end

function solve_part1(memory::String)
    # Match mul(X,Y) where X and Y are 1-3 digit numbers
    pattern = r"mul\((\d{1,3}),(\d{1,3})\)"

    total = 0
    for m in eachmatch(pattern, memory)
        x = parse(Int, m.captures[1])
        y = parse(Int, m.captures[2])
        total += x * y
    end

    return total
end

function solve_part2(memory::String)
    # Match mul(X,Y), do(), or don't()
    pattern = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

    enabled = true
    total = 0

    for m in eachmatch(pattern, memory)
        instruction = m.match

        if instruction == "do()"
            enabled = true
        elseif instruction == "don't()"
            enabled = false
        elseif startswith(instruction, "mul(") && enabled
            x = parse(Int, m.captures[1])
            y = parse(Int, m.captures[2])
            total += x * y
        end
    end

    return total
end

# Main execution
filepath = joinpath("input", "dayThree.txt")
memory = read_input(filepath)

part1 = solve_part1(memory)
part2 = solve_part2(memory)

println("Part 1: $part1")
println("Part 2: $part2")

# Test with examples
test_memory1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
println("\nTest Part 1: $(solve_part1(test_memory1)) (expected 161)")

test_memory2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
println("Test Part 2: $(solve_part2(test_memory2)) (expected 48)")