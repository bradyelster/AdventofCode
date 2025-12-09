# Brady Elster
# Advent of Code 2025 - Day 03

function parse_line(line, k::Integer)::Integer
    arr = [parse(Int, ch) for ch in strip(line) if isdigit(ch)]
    max_joltage = ""

    for iter in 1:k
        max, index = maxLeaveSpace(arr, k - iter)
        arr = arr[index+1:end]
        max_joltage *= string(max)
    end

    return parse(Int64, max_joltage)
end

function maxLeaveSpace(array, m::Integer)
    return findmax(array[begin:length(array)-m])
end

function main()
    total_sum = 0

    open("input/day03.txt", "r") do file
        for line in eachline(file)
            max_joltage = parse_line(line, 12) # set k=2 for part_one, k=12 for part_two
            total_sum += max_joltage
        end
    end
    println("Total output joltage: $total_sum")

    return total_sum
end

# Run main program
main()