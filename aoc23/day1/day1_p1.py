# Brady Elster - Advent of Code 2023
# Day 1, part 1 (attempt 2, trying new approach)

# from icecream import ic


def read_file(path):
    with open(path) as f:
        lines = f.read().splitlines()
    return lines


def enum(string):
    dists = {"number": [], "Dist2End": []}
    for i in enumerate(string):
        if i[1].isdigit():
            dists["number"].append(int(i[1]))
            dists["Dist2End"].append((len(string) - i[0]))
        else:
            pass
    return dists


def valpick(dict):
    first = dict["number"][0]
    last = dict["number"][-1]
    return first, last


def run_program(path):
    sum = 0
    lines = read_file(path)
    for i in range(len(lines)):
        dict = enum(lines[i])
        first, last = valpick(dict)
        linetotal = int(str(first) + str(last))
        sum += linetotal
    return sum


def main(relpath):
    sum = run_program(relpath)
    return print("Sum: ", sum)


main("day1/input1.txt")
