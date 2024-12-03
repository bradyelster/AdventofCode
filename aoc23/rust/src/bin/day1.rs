use itertools::Itertools; // Itertools gives us access to .minmax() and .into_option()

// This macro reads the contents of the file located at the specified relative path
const INPUT: &str = include_str!("../../inputs/day1.txt");

// A constant slice (&[&str]) that maps numbers (0 to 9) to their textual representations
const NUMBERS: &[&str] = &[
    "0", "zero", "1", "one", "2", "two", "3", "three", "4", "four", "5", "five", "6", "six", "7",
    "seven", "8", "eight", "9", "nine",
];

fn main() {
    let sum: usize = INPUT
    .lines()
    .map(|line| {
        let (a, b) = NUMBERS
            .iter()
            .enumerate()
            // Filter out textual representations, we only seek the numbers "0", "1", etc.
            .filter(|(i, _)| i % 2 == 0) // only want even elements of NUMBERS (no remainer after division by 2)
            .flat_map(|(i, &n)| line.match_indices(n).map(move |(idx, _)| (idx, i / 2)))
            .minmax()
            .into_option()
            .unwrap();
        a.1 * 10 + b.1
    })
    .sum();
    println!("Part 1 Solution: {}", sum);

    // Declares a variable `sum` of type usize (an unsigned integer type)
    let sum: usize = INPUT
        // Splits INPUT into an iterator over the lines
        .lines()
        // Transforms each line using the logic inside the brackets {}
        .map(|line| {
            let (a, b) = NUMBERS
                .iter() // Iterates over the elements of
                .enumerate() // Converts the iterator into pairs of (index, element)
                // For each (index, number) pair from NUMBERS, find all occurrences of number in the current line
                .flat_map(|(i, &n)| line.match_indices(n)
                .map(move |(idx, _)| (idx, i / 2))) // transforms each match into (idx, i / 2)
                .minmax() // finds the smallest and largest (idx, i / 2) pair based on the idx value.
                .into_option() // into an Option and unwraps it to get the (min, max) tuple of matches.
                .unwrap();
            // a.1 is the first number found (tens place), b.1 is the last number found (ones place)
            a.1 * 10 + b.1
        })
        .sum(); // sum the numbers for each line
    println!("Part 2 Solution: {}", sum);
}