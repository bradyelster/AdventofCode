# Day One - Advent of Code
# Part 1: Calculate total distance between two sorted lists
# Part 2: Calculate similarity score

function solve_part_one(left_list::Vector{Int}, right_list::Vector{Int})
    # Sort both lists
    sorted_left = sort(left_list)
    sorted_right = sort(right_list)

    # Calculate the total distance
    total_distance = 0
    for i in eachindex(sorted_left)
        total_distance += abs(sorted_left[i] - sorted_right[i])
    end

    return total_distance
end

function solve_part_two(left_list::Vector{Int}, right_list::Vector{Int})
    # Count occurrences of each number in the right list
    right_counts = Dict{Int,Int}()
    for num in right_list
        right_counts[num] = get(right_counts, num, 0) + 1
    end

    # Calculate similarity score
    similarity_score = 0
    for num in left_list
        count = get(right_counts, num, 0)
        similarity_score += num * count
    end

    return similarity_score
end

function read_input(filepath::String)
    left_list = Int[]
    right_list = Int[]

    open(filepath, "r") do file
        for line in eachline(file)
            # Skip empty lines
            if isempty(strip(line))
                continue
            end

            # Split the line by whitespace and parse the two numbers
            numbers = split(strip(line))
            if length(numbers) == 2
                push!(left_list, parse(Int, numbers[1]))
                push!(right_list, parse(Int, numbers[2]))
            end
        end
    end

    return left_list, right_list
end

# Main execution
filepath = joinpath("julia/input", "dayOne.txt")
left_list, right_list = read_input(filepath)

# Part 1
part_one_result = solve_part_one(left_list, right_list)
println("Part 1 - Total distance between the lists: $part_one_result")
println("Correct? ", part_one_result == 2756096)

# Part 2
part_two_result = solve_part_two(left_list, right_list)
println("Part 2 - Similarity score: $part_two_result")
println("Correct? ", part_two_result == 23117829)