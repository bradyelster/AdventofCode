use std::fs;
use std::io::{self, BufRead};

#[derive(Debug, PartialEq)]
enum Classification {
    Safe,
    Unsafe,
}

fn is_safe_vector(vec: &[u32]) -> bool {
    // uses a sliding window of size 2 to compare every neighboring pair.
    let is_increasing = vec.windows(2).all(|w| w[0] < w[1]);
    let is_decreasing = vec.windows(2).all(|w| w[0] > w[1]);

    // now check that no 2 neighbors differ by at least one and at most three.
    let differences_valid = vec.windows(2).all(|w| {
        let diff = (w[0] as i32 - w[1] as i32).abs();
        diff >= 1 && diff <= 3
    });

    // return true (safe) under these 2 conditions, false otherwise
    (is_increasing || is_decreasing) && differences_valid
}

fn classify_vector(vec: &[u32], allow_removal: bool) -> Classification {
    if is_safe_vector(vec) {
        return Classification::Safe;
    }

    if allow_removal {
        for i in 0..vec.len() {
            let mut new_vec = vec.to_vec();
            new_vec.remove(i);

            if is_safe_vector(&new_vec) {
                return Classification::Safe;
            }
        }
    }

    Classification::Unsafe
}

fn process_file(file_path: &str, allow_removal: bool) -> std::io::Result<u32> {
    let file = fs::File::open(file_path)?;
    let reader = io::BufReader::new(file);
    let mut num_safe: u32 = 0;

    for line in reader.lines() {
        let line = line?;
        let parsed_numbers: Vec<u32> = line
            .split_whitespace()
            .filter_map(|num| num.parse::<u32>().ok())
            .collect();

        if classify_vector(&parsed_numbers, allow_removal) == Classification::Safe {
            num_safe += 1;
        }
    }

    Ok(num_safe)
}

fn main() -> std::io::Result<()> {
    let file_path = "src/input/day02.txt";

    let p1_result = process_file(file_path, false)?; // Part One: no removals allowed
    let p2_result = process_file(file_path, true)?;  // Part Two: removals allowed

    println!("(Part One): Number of Safe Reports: {}", p1_result);
    println!("(Part Two): Number of Safe Reports (modified): {}", p2_result);

    Ok(())
}