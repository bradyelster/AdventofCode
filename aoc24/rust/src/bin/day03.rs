use std::fs;
use std::io::{self, BufRead, BufReader};
use regex::Regex;

/// Reads a file and returns an iterator over its lines.
fn read_file(file_path: &str) -> io::Result<impl Iterator<Item = String>> {
    let file = fs::File::open(file_path)?;
    let reader = BufReader::new(file);
    Ok(reader.lines().filter_map(Result::ok)) // Filters out any lines with errors
}

/// Finds all matches of the `mul()` pattern in a given line and returns the multiplications as a vector of integers.
fn find_multiplications(line: &str) -> Vec<i64> {
    let pattern = Regex::new(r"mul\((\d+),(\d+)\)").unwrap(); // Regex with capture groups for the numbers
    pattern.captures_iter(line)
        .filter_map(|caps| {
            // Extract numbers, parse them, and return their product
            let num1 = caps[1].parse::<i64>().ok()?;
            let num2 = caps[2].parse::<i64>().ok()?;
            Some(num1 * num2)
        })
        .collect()
}

/// Parses a single line and computes the sum of valid multiplications based on the presence of `do()` or `don't()`.
fn parse_line(line: &str) -> i64 {
    let pattern = Regex::new(r"(mul\((\d+),(\d+)\)|do\(\)|don't\(\))").unwrap();
    let mut is_allowed = true; // Start by default allowing multiplications
    let mut line_sum = 0;

    // println!("Processing line: {}", line);

    for caps in pattern.captures_iter(line) {
        if let Some(func) = caps.get(1) {
            match func.as_str() {
                "do()" => {
                    is_allowed = true; // Enable adding results
                    // println!("Found do(): is_allowed set to true");
                }
                "don't()" => {
                    is_allowed = false; // Disable adding results
                    // println!("Found don't(): is_allowed set to false");
                }
                _ => {
                    // Handle `mul()` matches
                    if let (Some(num1), Some(num2)) = (caps.get(2), caps.get(3)) {
                        let num1 = num1.as_str().parse::<i64>().unwrap();
                        let num2 = num2.as_str().parse::<i64>().unwrap();
                        if is_allowed {
                            // println!("Found mul({}, {}): Adding {} to line_sum", num1, num2, num1 * num2);
                            line_sum += num1 * num2; // Add only if allowed
                        } else {
                            // println!("Found mul({}, {}): Ignored due to is_allowed being false", num1, num2);
                        }
                    }
                }
            }
        }
    }
    // println!("Line sum: {}", line_sum);
    line_sum
}


/// Processes the file line by line, sums all valid multiplications, and returns the total sum.
fn process_file(file_path: &str) -> io::Result<i64> {
    let mut total_sum = 0;

    for line in read_file(file_path)? {
        let line_sum: i64 = find_multiplications(&line).iter().sum(); // Sum valid products in the line
        total_sum += line_sum;
    }

    Ok(total_sum)
}

fn part_one(file_path: &str) -> Result<i64, std::io::Error>{
    let sum = process_file(file_path);
    return sum
}

fn part_two(file_path: &str) -> Result<i64, std::io::Error>{
    // Step 1: Read the entire file as one big string (line-by-line fails)
    let content = fs::read_to_string(file_path)?;

    // Step 2: Call find_multiplications with the full content
    return Ok(parse_line(&content));
}

/// Main function to demonstrate the program.
fn main() -> io::Result<()> {
    let file_path = "src/input/day03.txt";

    let p1_result = part_one(file_path)?; // Part One: find mul()
    let p2_result = part_two(file_path)?;  // Part Two: include do() and don't() logic

    println!("(Part One): Sum of All Multiplications: {}", p1_result);
    println!("(Part Two): Sum of All Multiplications (modified): {}", p2_result);

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_single_line_with_do_and_dont() {
        let line = "mul(2,4) don't() mul(3,5) do() mul(6,7)";
        let result = parse_line(line);
        assert_eq!(result, 50); // Expected: 8 (2*4) + 42 (6*7)
    }

    #[test]
    fn test_line_with_only_dont() {
        let line = "don't() mul(8,9) mul(10,11)";
        let result = parse_line(line);
        assert_eq!(result, 0); // Expected: 0 (nothing added)
    }

    #[test]
    fn test_line_with_no_dont() {
        let line = "mul(5,5) mul(2,3)";
        let result = parse_line(line);
        assert_eq!(result, 31); // Expected: 25 (5*5) + 6 (2*3)
    }

    #[test]
    fn test_line_with_do_and_dont() {
        let line = "do() mul(4,5) don't() mul(7,8) do() mul(1,1)";
        let result = parse_line(line);
        assert_eq!(result, 21); // Expected: 20 (4*5) + 1 (1*1)
    }

    #[test]
    fn test_empty_line() {
        let line = "";
        let result = parse_line(line);
        assert_eq!(result, 0); // Expected: 0 (no matches)
    }
    #[test]
    fn test_given_example() {
        let line = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";
        let result = parse_line(line);
        assert_eq!(result, 48); // Expected: 8 (2*4) + 40 (8*5)
    }
}
