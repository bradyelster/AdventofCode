def create_left_right(file_path: str):
    left = []
    right = []

    with open(file_path, 'r') as file:
        for line in file:
            nums = line.split()
            if len(nums) == 2:  # Ensure there are exactly two numbers
                left.append(int(nums[0]))
                right.append(int(nums[1]))
    return left, right

def part_one(file_path: str):
    l, r = create_left_right(file_path)
    l.sort(reverse=True)
    r.sort(reverse=True)

    total = 0
    for i in range(len(l)):
        total += abs(l[i] - r[i])

    return l, r, total

def part_two(left, right):
    total = 0

    # Iterate through `left` and consider only elements also in `right`
    for number in left:
        if number in right:
            if number in freq_dict:
                freq_dict[number] += 1
            else:
                # freq_dict[number] = 1

    # Calculate the total sum of key * value
    total = sum(key * value for key, value in freq_dict.items())
    return total

def main():
    path = "input/day01.txt"
    l, r, p1 = part_one(path)
    p2 = part_two(l, r)
    print("(Part One):", p1)
    print("(Part Two):", p2)

main()


