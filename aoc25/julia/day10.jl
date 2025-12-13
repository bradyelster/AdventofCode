# Brady Elster
# Advent of Code 2025 - Day 10

# external libraries for part 2 :(
using JuMP
using HiGHS
using BenchmarkTools

function parse_part1(filename::String)
    target_all = Int[]
    buttons_all = Vector{Int}[]

    for line in eachline(filename)
        # Skip empty lines
        if isempty(strip(line))
            continue
        end

        # Extract the target pattern between brackets
        target_match = match(r"\[([.#]+)\]", line)
        if target_match === nothing
            continue  # Skip lines that don't match
        end

        # Convert target to binary number
        target_str = target_match.captures[1]
        target_binary = 0
        n = length(target_str)
        for (i, char) in enumerate(target_str)
            if char == '#'
                target_binary += 2^(i - 1)  # i=4 gives 2^3 = 8
            end
        end
        push!(target_all, target_binary)

        # Extract all button patterns (numbers in parentheses)
        buttons = Int[]
        for button_match in eachmatch(r"\(([0-9,]+)\)", line)
            # Parse the numbers in this button
            nums_str = button_match.captures[1]
            button_value = 0
            for num_str in split(nums_str, ',')
                num = parse(Int, num_str)
                button_value += 2^num
            end
            push!(buttons, button_value)
        end
        push!(buttons_all, buttons)
    end

    return target_all, buttons_all
end

function powerset(x::Vector{T}) where T
    result = Vector{T}[[]]
    for elem in x
        len = length(result)  # Capture current length
        for j in 1:len        # Only iterate over original elements
            push!(result, [result[j]; elem])
        end
    end
    popfirst!(result)
    return result
end

function find_minimum_buttons(target, buttons)
    min_length = typemax(Int)
    found = false

    ps = powerset(buttons)

    for subset in ps
        xor_result = reduce(⊻, subset)
        if xor_result == target
            min_length = min(min_length, length(subset))
            found = true
        end
    end

    return found ? min_length : -1
end

function part1(filename::String)
    target_all, buttons_all = parse_part1(filename)
    minima::Vector{Int64} = []

    for (i, (target, buttons)) in enumerate(zip(target_all, buttons_all))
        min_buttons = find_minimum_buttons(target, buttons)
        push!(minima, min_buttons)
    end
    return sum(minima)
end

function parse_line_part2(line)
    # Skip empty lines
    if isempty(strip(line))
        return nothing
    end

    # Extract indicator lights (not needed for part 2)
    lights_match = match(r"\[([.#]+)\]", line)
    if lights_match === nothing
        return nothing
    end

    # Extract button schematics
    buttons = []
    for m in eachmatch(r"\(([0-9,]+)\)", line)
        button = parse.(Int, split(m.captures[1], ','))
        push!(buttons, button)
    end

    # Extract joltage requirements
    joltage_match = match(r"\{([0-9,]+)\}", line)
    if joltage_match === nothing
        return nothing
    end
    joltages = parse.(Int, split(joltage_match.captures[1], ','))

    return buttons, joltages
end

function jumpcall(buttons, joltages)
    n_buttons = length(buttons)
    n_counters = length(joltages)

    # Create optimization model
    model = Model(HiGHS.Optimizer)
    set_silent(model)

    # Decision variables: number of times each button is pressed
    @variable(model, x[1:n_buttons] >= 0, Int)

    # Constraints: each counter must reach its target joltage
    for counter in 1:n_counters
        # Sum of presses for buttons that affect this counter
        @constraint(model,
            sum(x[b] for b in 1:n_buttons if (counter - 1) in buttons[b]) == joltages[counter]
        )
    end

    # Objective: minimize total button presses
    @objective(model, Min, sum(x))

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        return Int(objective_value(model))
    else
        error("No solution found for machine")
    end
end

function part2(filename::String)
    total_presses = 0
    machine_count = 0

    for line in eachline(filename)
        result = parse_line_part2(line)
        if result === nothing
            continue  # Skip invalid lines
        end

        buttons, joltages = result
        machine_count += 1
        presses = jumpcall(buttons, joltages)
        total_presses += presses
    end

    return total_presses
end

function main()
    println("Part 1: ", part1("input/day10.txt"))
    println("Part 2: ", part2("input/day10.txt"))

    # @btime part1("input/day10.txt")
    # @btime part2("input/day10.txt")
end

main()