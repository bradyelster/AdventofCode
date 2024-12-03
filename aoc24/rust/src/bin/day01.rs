use std::fs;
use itertools::Itertools;
use std::collections::HashMap;

fn bubble_sort<T: Ord>(arr: &mut [T]) {
    let n = arr.len();
    for i in 0..n {
        for j in 0..n - i - 1 {
            if arr[j] > arr[j + 1] {
                arr.swap(j, j + 1);
            }
        }
    }
}

// Define the part_one function
fn part_one(file_path: &str) -> std::io::Result<(Vec<i32>, Vec<i32>, i32)> {
    // Read the file content into a string
    let content = fs::read_to_string(file_path)?;

    // Process the lines to parse and collect into two vectors
    let (mut left, mut right): (Vec<_>, Vec<_>) = content
        .lines()
        .filter_map(|line| {
            // Split and parse each line into a tuple of integers
            line.split_whitespace()
                .map(str::parse::<i32>)
                .collect_tuple::<(_, _)>()
                .and_then(|(a, b)| Some((a.ok()?, b.ok()?)))
        })
        .unzip();

    // Bubble sort the 2 arrays: left and right
    bubble_sort(&mut left);
    bubble_sort(&mut right);

    // Compute the sum of absolute differences
    let total_difference: i32 = left.iter()
        .zip(right.iter())
        .map(|(a, b)| (a - b).abs())
        .sum();

    return Ok((left, right, total_difference))
}

fn part_two(left: Vec<i32>, right: Vec<i32>) -> std::io::Result<i32> {
    // Step 1: Count frequencies in the right array
    // Create Hashmap with same capacity as either vector (i.e. left or right)
    let mut frequency_map: HashMap<i32, usize> = HashMap::with_capacity(right.len()); //
    for &num in &right {
        *frequency_map.entry(num).or_insert(0) += 1;
    }

    // Step 2: Query frequencies for the target list
    let mut similarity_score: i32 = 0;

    for &num in &left {
        // Convert frequency to i32 before multiplication to avoid type mismatch
        similarity_score += num * (*frequency_map.get(&num).unwrap_or(&0) as i32);
    }

    Ok(similarity_score)
}

fn main() -> std::io::Result<()> {
    // Call the part_one function
    let (left, right, p1_result) = part_one("src/input/day01.txt")?;
    let p2_result = part_two(left, right)?;

    println!("(Part One): Total distance: {}", p1_result);
    println!("(Part Two): Similarity score: {}", p2_result);

    Ok(())
}