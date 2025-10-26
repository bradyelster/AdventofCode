# Brady Elster - AOC 2023 attempt in Julia
# November 2, 2024

#=
Sketch:
1. read file
2. loop through lines
3. try to convert each character to int(), else move onto next
4. start at either end of the list and go towards the middle
5. return number for each line which is int("num1"*"num2") - this is the "calibration value"
6. sum up all calibration values and return result
=#

function partone(path)
    total = 0
    for line in readlines(path)
        digits = [c for c in line if isdigit(c)]
        total += parse(Int, string(digits[1], digits[end]))
    end
    return total
end

function parttwo(path)
    d = Dict("one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5",
        "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9")
    pattern = r"(?=(\d|one|two|three|four|five|six|seven|eight|nine))"

    total = 0
    for line in readlines(path)
        matches = [get(d, m.captures[1], m.captures[1]) for m in eachmatch(pattern, line)]
        total += parse(Int, matches[1] * matches[end])
    end
    return total
end

function main()
    # First check if the file exists for this given input path
    input_path = "input1.txt"

    return try
        open(input_path, "r") do s
            # begin program if file exists
            println("part one answer: ", partone(input_path))
            println("part two answer: ", parttwo(input_path))
        end
    catch
        # print that the file doesn't exist
        println("file doesn't exist")
    end
end

main()