def parse_file(file_path):
    """
    Parses the input file into rules and number sets.
    Returns a tuple of (rules, number_sets).
    """
    rules = []
    number_sets = []

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if '|' in line:
                rules.append(line)
            elif ',' in line:
                number_sets.append([int(num) for num in line.split(',')])

    return rules, number_sets

def is_correct_order(rules, numbers):
    """
    Checks if the given numbers are in the correct order according to the rules.
    Returns True if the order is correct, False otherwise.
    """
    # Step 1: Parse the rules into a precedence map
    precedence_map = {}

    for rule in rules:
        a, b = map(int, rule.split('|'))
        if a not in precedence_map:
            precedence_map[a] = set()
        precedence_map[a].add(b)

    # Step 2: Validate the numbers set against the precedence map
    for i in range(len(numbers)):
        for j in range(i + 1, len(numbers)):
            a = numbers[i]
            b = numbers[j]
            # If `b` is supposed to come after `a` but doesn't, it's invalid
            if a in precedence_map and b in precedence_map[a]:
                return False

    return True

def get_middle_element(numbers):
    """
    Returns the middle element of a list of numbers.
    If the list is empty, returns None.
    """
    if not numbers:
        return None
    return numbers[len(numbers) // 2]

def main():
    # Replace with the path to your input file
    file_path = "src/input/day05.txt"

    # Parse the input file
    rules, number_sets = parse_file(file_path)
    total_sum = 0

    for number_set in number_sets:
        if is_correct_order(rules, number_set):
            middle = get_middle_element(number_set)
            total_sum += middle
            # print(f"Valid set: {number_set}, Middle element: {middle}")
        else:
            break
            # print(f"Invalid set: {number_set}")

    print(f"Sum of middle elements of valid sets: {total_sum}")

if __name__ == "__main__":
    main()
