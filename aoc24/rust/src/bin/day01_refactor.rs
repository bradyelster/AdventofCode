use std::{fs, collections::HashMap};
use itertools::Itertools;

fn part_one(file_path: &str) -> std::io::Result<(Vec<i32>, Vec<i32>, i32)> {
    // create vectors left and right
    // read-in file as one string
    let (mut left, mut right): (Vec<_>, Vec<_>) = fs::read_to_string(file_path)?
        .lines() // iterate over lines
        .filter_map(|line| // for each line, do the following:
            line.split_whitespace() // split on whitespace
                .map(str::parse::<i32>) // convert all string digits to <i32> 
                .collect_tuple::<(_, _)>() // collect in (left, right) vectors
                .and_then(|(a, b)| Some((a.ok()?, b.ok()?))) // make sure 
        )
        .unzip();

    left.sort_unstable();
    right.sort_unstable();

    let total_difference = left.iter()
        .zip(right.iter())
        .map(|(a, b)| (a - b).abs())
        .sum();

    Ok((left, right, total_difference))
}

fn part_two(left: Vec<i32>, right: Vec<i32>) -> std::io::Result<i32> {
    let frequency_map = right.iter()
        .fold(HashMap::new(), |mut map, &num| {
            *map.entry(num).or_insert(0) += 1;
            map
        });

    let similarity_score = left.iter()
        .map(|&num| num * (*frequency_map.get(&num).unwrap_or(&0) as i32))
        .sum();

    Ok(similarity_score)
}

fn main() -> std::io::Result<()> {
    let (left, right, p1_result) = part_one("src/input/day01.txt")?;
    let p2_result = part_two(left, right)?;

    println!("(Part One): Total distance: {}", p1_result);
    println!("(Part Two): Similarity score: {}", p2_result);

    Ok(())
}