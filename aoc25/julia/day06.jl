# Brady Elster
# Advent of Code 2025 - Day 06

function read_data(filename::String)::Tuple{Matrix{Int64},Vector{SubString{String}}}
    lines = collect(eachline(filename))            # read all lines
    data_lines = lines[1:end-1]                    # all except last
    last_line = lines[end]                         # the 4th line (last)

    # --- Parse the data lines into a matrix ---
    rows = [parse.(Int64, split(line)) for line in data_lines]
    data = permutedims(hcat(rows...))              # convert row vectors -> matrix

    # --- Parse operations from the last line ---
    operations = split(last_line)                  # vector of strings

    return data, operations
end

function part_one(datamat::Matrix{Int64}, ops::Vector{SubString{String}})::Int64
    col_totals = Vector{Int64}()

    for (i, op) in pairs(ops)
        if op == "+"
            push!(col_totals, sum(datamat[:, i]))
        else
            push!(col_totals, prod(datamat[:, i]))
        end
    end
    return Int64(sum(col_totals))
end

function part_two(filename)
    lines = readlines(filename)
    lines = [line for line in lines if !isempty(line)]

    max_len = maximum(length(line) for line in lines)
    padded_lines = [rpad(line, max_len) for line in lines]

    operator_line = padded_lines[end]
    number_lines = padded_lines[1:end-1]
    num_rows = length(number_lines)

    # Find problem boundaries (where all rows are spaces)
    problems = []
    col = 1
    while col <= max_len
        # Check if this column has content
        has_content = any(r -> number_lines[r][col] != ' ', 1:num_rows)

        if has_content
            # Start of a problem
            start_col = col

            # Find end of problem (next column that's all spaces)
            end_col = col
            while end_col < max_len && any(r -> number_lines[r][end_col+1] != ' ', 1:num_rows)
                end_col += 1
            end

            # Find the operator (should be in one of these columns)
            op_char = ' '
            for c in start_col:end_col
                if operator_line[c] != ' '
                    op_char = operator_line[c]
                    break
                end
            end

            push!(problems, (start_col, end_col, op_char))
            col = end_col + 1
        else
            col += 1
        end
    end

    grand_total = 0

    # Process each problem
    for (start_col, end_col, op_char) in problems

        # Process columns RIGHT-TO-LEFT within this problem
        # Each column produces ONE number
        numbers = Int[]

        for col in end_col:-1:start_col
            # Build a number from this column by reading rows top-to-bottom
            num_str = ""
            for r in 1:num_rows
                char = number_lines[r][col]
                if char != ' ' && isdigit(char)
                    num_str *= string(char)
                end
            end

            if !isempty(num_str)
                num = parse(Int, num_str)
                push!(numbers, num)
            end
        end

        # Apply operator
        if !isempty(numbers)
            result = numbers[1]
            for i in eachindex(numbers)
                result = op_char == '+' ? result + numbers[i] : result * numbers[i]
            end
            grand_total += result
        end
    end

    return grand_total
end

function main()
    filename = "input/day06.txt"
    mat, ops = read_data(filename)
    println("Part 1: ", part_one(mat, ops))
    println("Part 2: ", part_two(filename))
end

main()