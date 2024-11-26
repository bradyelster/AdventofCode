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

try 
    open("input1.txt", "r") do s
        # perform desired operations if file exists
        file_exists::Bool = true
    end
catch
    # either warn or print that the file doesn't exist
    println("file doesn't exist")
end

function file_existence(file_exists)
    if file_exists == true
        println("file exists 🤩")
    else 
        println("file doesn't exist")
    end
end
