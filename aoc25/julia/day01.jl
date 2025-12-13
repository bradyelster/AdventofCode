# Brady Elster
# Advent of Code 2025 - Day 01

const MOD = 100

# Parse input file
function parse_instructions(filename)
    instructions = Tuple{Char,Int}[]
    for line in eachline(filename)
        if !isempty(line)
            letter = line[1]
            number = parse(Int, line[2:end])
            push!(instructions, (letter, number))
        end
    end
    return instructions
end

# Part 1: Count only when landing exactly on zero
function part_one(instructions, start_pos=50)
    pos = start_pos
    count = 0

    for (direction, steps) in instructions
        # Update position
        if direction == 'L'
            pos = mod(pos - steps, MOD)
        else  # 'R'
            pos = mod(pos + steps, MOD)
        end

        # Check if we landed on zero
        if pos == 0
            count += 1
        end
    end

    return count
end

# Part 2: Count all zero crossings (including when passing through)
function part_two(instructions, start_pos=50)
    pos = start_pos
    count = 0

    for (direction, steps) in instructions
        if direction == 'L'
            # Moving left: we cross zero if steps >= current position
            steps_to_zero = pos

            if steps >= steps_to_zero
                # Prevent double counting when pointer is already at 0
                if pos != 0
                    count += 1
                end
                count += (steps - steps_to_zero) ÷ MOD
            end

            pos = mod(pos - steps, MOD)
        else  # 'R'
            # Moving right: we cross zero if pos + steps >= MOD
            if pos == 0
                steps_to_zero = 0
            else
                steps_to_zero = MOD - pos
            end

            if steps >= steps_to_zero
                # Prevent double counting when pointer is already at 0
                if pos != 0
                    count += 1
                end
                count += (steps - steps_to_zero) ÷ MOD
            end

            pos = mod(pos + steps, MOD)
        end
    end

    return count
end

# Main function
function main()
    instructions = parse_instructions("input/day01_noah.txt")

    println("Part 1: ", part_one(instructions))
    println("Part 2: ", part_two(instructions))
end

main()