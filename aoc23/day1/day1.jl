# Brady Elster - AOC 2023 attempt in Julia
# November 2, 2024



# f = open("absolute path of the file", "r")
# few file operations 
# close(f)


#=
Sketch:
1. read file
2. loop through lines
3. try to convert each character to int(), else move onto next
4. start at either end of the list and go towards the middle
5. return number for each line which is int("num1"*"num2") - this is the "calibration value"
6. sum up all calibration values and return result
=# 

# global path = "day1/test1.txt"

try 
    open("test1.txt", "r") do s
        # perform desired operations if file exists
    end
catch
    # either warn or print that the file doesn't exist
    println("file doesn't exist")
end

#=
f = open(path, "r")
 
    # line_number
    line = 0  
 
    # read till end of file
    while ! eof(f)  
 
    # read a new / next line for every iteration           
    s = readline(f)          
    line += 1
    println("$line, $s")
    end

close(f)
=#