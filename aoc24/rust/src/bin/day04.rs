use std::fs::File;
use std::io::{self, BufRead};

/* PART ONE */
const WORD: &str = "XMAS";

// Direction vectors for horizontal, vertical, and diagonal search.
const DIRECTIONS: [(i32, i32); 8] = [
    (0, 1),   // Left to Right
    (0, -1),  // Right to Left
    (1, 0),   // Top to Bottom
    (-1, 0),  // Bottom to Top
    (1, 1),   // Top-left to Bottom-right
    (1, -1),  // Top-right to Bottom-left
    (-1, 1),  // Bottom-left to Top-right
    (-1, -1), // Bottom-right to Top-left
];

fn read_grid(filename: &str) -> Result<Vec<Vec<char>>, io::Error> {
    let mut grid = Vec::new();
    let file = File::open(filename)?;
    for line in io::BufReader::new(file).lines() {
        let line = line?;
        grid.push(line.chars().collect());
    }
    Ok(grid)
}

fn is_valid_position(grid: &Vec<Vec<char>>, row: i32, col: i32) -> bool {
    row >= 0 && col >= 0 && row < grid.len() as i32 && col < grid[0].len() as i32
}

fn search_word(grid: &Vec<Vec<char>>, word: &str, row: i32, col: i32, direction: (i32, i32)) -> bool {
    let mut r = row;
    let mut c = col;
    for (_, ch) in word.chars().enumerate() {
        if !is_valid_position(grid, r, c) || grid[r as usize][c as usize] != ch {
            return false;
        }
        r += direction.0;
        c += direction.1;
    }
    true
}

fn find_word_occurrences(grid: &Vec<Vec<char>>, word: &str) -> Vec<(i32, i32)> {
    let mut occurrences = Vec::new();
    let rows = grid.len();
    let cols = grid[0].len();
    
    for row in 0..rows {
        for col in 0..cols {
            for &direction in &DIRECTIONS {
                if search_word(grid, word, row as i32, col as i32, direction) {
                    occurrences.push((row as i32, col as i32));
                }
            }
        }
    }
    occurrences
}

/* MAIN */
fn main() -> Result<(), std::io::Error> {
    let filename = "src/input/day04.txt"; // Your input file

    match read_grid(filename) {
        Ok(grid) => {
            let occurrences = find_word_occurrences(&grid, WORD);
            let total_num_occur = occurrences.len() as i32; // Count the number of occurrences
            println!("(Part One): Total occurrences of 'XMAS': {}", total_num_occur);
        }
        Err(e) => eprintln!("Error reading file: {}", e),
    }

    Ok(())
}
