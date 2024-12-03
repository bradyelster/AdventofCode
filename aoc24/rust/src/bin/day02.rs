use std::fs;
use std::io::{self, BufRead};

#[derive(Debug)]
#[derive(PartialEq)]
enum Classification {
    Safe,
    Unsafe,
}

fn is_safe_vector(vec: &[u32]) -> bool {
    // Check if the vector is monotonic (either all increasing or all decreasing)
    let is_increasing = vec.windows(2).all(|w| w[0] < w[1]);
    let is_decreasing = vec.windows(2).all(|w| w[0] > w[1]);

    // Check if the differences between adjacent levels are within the range [1, 3]
    let differences_valid = vec.windows(2).all(|w| {
        let diff = (w[0] as i32 - w[1] as i32).abs();
        diff >= 1 && diff <= 3
    });

    // Return true if the vector satisfies both conditions
    (is_increasing || is_decreasing) && differences_valid
}

fn classify_vector1(vec: &[u32]) -> Classification {
    // Check if the vector is monotonic (either all increasing or all decreasing)
    let is_increasing = vec.windows(2).all(|w| w[0] < w[1]);
    let is_decreasing = vec.windows(2).all(|w| w[0] > w[1]);

    // Check if the differences between adjacent levels are within the range [1, 3]
    let differences_valid = vec.windows(2).all(|w| {
        let diff = (w[0] as i32 - w[1] as i32).abs();
        diff >= 1 && diff <= 3
    });

    // Determine classification
    if (is_increasing || is_decreasing) && differences_valid {
        Classification::Safe
    } else {
        Classification::Unsafe
    }
}

fn classify_vector2(vec: &[u32]) -> Classification {
    // First, check if the vector is already "safe"
    if is_safe_vector(vec) {
        return Classification::Safe;
    }

    // Try removing each element one by one and check if the resulting vector is "safe"
    for i in 0..vec.len() {
        let mut new_vec = vec.to_vec();
        new_vec.remove(i);

        if is_safe_vector(&new_vec) {
            return Classification::Safe;
        }
    }

    // If no solution was found, classify as unsafe
    Classification::Unsafe
}

fn part_one(file_path: &str) -> std::io::Result<u32> {
    // Open the file for reading
    let file = fs::File::open(file_path)?;
    let reader = io::BufReader::new(file);
    let mut num_safe: u32 = 0;

    // Iterate over each line of the file
    for line in reader.lines() {
        // Parse the line into a Vec<u32>
        let line = line?; // Unwrap the Result from reading the line
        let parsed_numbers: Vec<u32> = line
            .split_whitespace()
            .filter_map(|num| num.parse::<u32>().ok())
            .collect();

        // Classify the vector
        if classify_vector1(&parsed_numbers) == Classification::Safe {
            num_safe += 1;
        }
    }

    Ok(num_safe)
}

fn part_two(file_path: &str) -> std::io::Result<u32> {
    // Open the file for reading
    let file = fs::File::open(file_path)?;
    let reader = io::BufReader::new(file);
    let mut num_safe: u32 = 0;

    // Iterate over each line of the file
    for line in reader.lines() {
        // Parse the line into a Vec<u32>
        let line = line?; // Unwrap the Result from reading the line
        let parsed_numbers: Vec<u32> = line
            .split_whitespace()
            .filter_map(|num| num.parse::<u32>().ok())
            .collect();

        // Classify the vector
        if classify_vector2(&parsed_numbers) == Classification::Safe {
            num_safe += 1;
        }
    }

    Ok(num_safe)
}

fn main() -> std::io::Result<()> {
    // Call the part_one function
    let p1_result = part_one("src/input/day02.txt")?;
    let p2_result = part_two("src/input/day02.txt")?;

    println!("(Part One): Number of Safe Reports: {}", p1_result);
    println!("(Part Two): Number of Safe Reports (with Problem Dampening): {}", p2_result);

    Ok(())
}
