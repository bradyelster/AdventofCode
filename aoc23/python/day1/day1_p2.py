import re
# Brady Elster - Advent of Code 2023
# Day 1, part 2

def read_file(path):
    with open(path) as f:
        lines = f.read().splitlines()
    return lines

def enum(string):
    list1 = []
    for i in enumerate(string):
        if i[1].isdigit():
            list1.append(int(i[1]))
        else:
            pass
    #print(list1)
    return list1

def valpick(list1):
    if len(list1) > 0:
        first = list1[0]
        last = list1[-1]
        return first, last
    else: 
        return -1, -1
    
def blarg(s):
    num_dict = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9, "eightwo": 82, "eighthree": 83, "sevenine": 79, "nineight": 98, "twone": 21, "fiveight": 58}
    result = ""
    s_new = s
    for start in range(len(s_new)):
        for word, num in num_dict.items():
            if s_new[start:start+len(word)] == word:
                result += str(num)
                s_new = s_new.replace(word, str(num),1)  # Replace only the first occurrence
    return s_new if result else s

def run_program(path):
    sum = 0
    lines = read_file(path)
    for i in range(len(lines)):
        digitized = blarg(lines[i]) 
        cleanlist = enum(digitized)
        first, last = valpick(cleanlist)
        if first and last == -1:
            linetotal = 0 
            sum += linetotal
            print("error: no digits found in line: ", i) 
        else: 
            linetotal = int(str(first)+str(last))
            #print(linetotal)
            sum += linetotal
    return sum


def main(relpath):
    sum = run_program(relpath)
    print('Sum: ', sum)
main('day1/input1.txt')

# ans: 56324, my result: 56322
# i need to solve the problem of the examples below:

#print(blarg('sevenine'))
#print(blarg('1eightwo7three'))

# then it wil return what i need.
# sucks that im failing on like only 1 line though!