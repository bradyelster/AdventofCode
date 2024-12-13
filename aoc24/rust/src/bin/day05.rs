use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::{HashMap, HashSet, VecDeque};

fn parse_file(file_path: &str) -> (Vec<String>, Vec<Vec<i32>>) {
    // Initialize containers for rules and number sets
    let mut rules = Vec::new();
    let mut number_sets = Vec::new();

    // Open the file
    if let Ok(lines) = read_lines(file_path) {
        for line in lines.flatten() {
            if line.contains('|') {
                // It's a rule
                rules.push(line);
            } else if line.contains(',') {
                // It's a set of numbers
                let number_set: Vec<i32> = line.split(',')
                    .map(|num| num.trim().parse::<i32>().unwrap())
                    .collect();
                number_sets.push(number_set);
            }
        }
    }

    (rules, number_sets)
}

// Helper function to read lines from a file
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn topological_sort(rules: Vec<String>, numbers: Vec<i32>) -> Vec<i32> {
    // Restrict the graph to relevant nodes in `numbers`
    let numbers_set: HashSet<i32> = numbers.iter().cloned().collect();

    // Step 1: Parse the rules and filter by `numbers`
    let mut graph: HashMap<i32, Vec<i32>> = HashMap::new();
    let mut in_degree: HashMap<i32, i32> = HashMap::new();

    for rule in rules {
        let parts: Vec<i32> = rule.split('|').map(|x| x.parse::<i32>().unwrap()).collect();
        let a = parts[0];
        let b = parts[1];

        if numbers_set.contains(&a) && numbers_set.contains(&b) {
            // Add edge a -> b
            graph.entry(a).or_insert(Vec::new()).push(b);
            *in_degree.entry(b).or_insert(0) += 1;
            in_degree.entry(a).or_insert(0); // Ensure `a` exists in in_degree
        }
    }

    // Step 2: Perform topological sort
    let mut zero_in_degree: VecDeque<i32> = in_degree
        .iter()
        .filter(|&(_, &count)| count == 0)
        .map(|(&node, _)| node)
        .collect();

    let mut sorted_order: Vec<i32> = Vec::new();

    while let Some(current) = zero_in_degree.pop_front() {
        sorted_order.push(current);

        if let Some(neighbors) = graph.get(&current) {
            for &neighbor in neighbors {
                if let Some(degree) = in_degree.get_mut(&neighbor) {
                    *degree -= 1;
                    if *degree == 0 {
                        zero_in_degree.push_back(neighbor);
                    }
                }
            }
        }
    }

    // Filter by the given numbers to ensure valid order
    sorted_order
        .into_iter()
        .filter(|&num| numbers_set.contains(&num))
        .collect()
}

fn is_correct_order(rules: Vec<String>, numbers: Vec<i32>) -> bool {
    // Step 1: Parse the rules into a precedence map
    let mut precedence_map: HashMap<i32, HashSet<i32>> = HashMap::new();

    for rule in rules {
        let parts: Vec<i32> = rule.split('|').map(|x| x.parse::<i32>().unwrap()).collect();
        let a = parts[0];
        let b = parts[1];
        precedence_map.entry(a).or_insert(HashSet::new()).insert(b);
    }

    // Step 2: Validate the numbers set against the precedence map
    for i in 0..numbers.len() {
        for j in i + 1..numbers.len() {
            let a = numbers[i];
            let b = numbers[j];
            // If `b` is supposed to come after `a` but doesn't, it's invalid
            if let Some(valid_successors) = precedence_map.get(&a) {
                if valid_successors.contains(&b) {
                    return false;
                }
            }
        }
    }

    true
}

fn get_middle_element(vec: &Vec<i32>) -> Option<i32> {
    if vec.is_empty() {
        None // Return None if the vector is empty
    } else {
        let mid_index = vec.len() / 2; // Calculate the middle index
        Some(vec[mid_index]) // Return the middle element
    }
}

fn main() {
    let file_path = "src/input/day05.txt";

    let (rules, number_sets) = parse_file(file_path);
    let mut sum = 0;

    for set in number_sets {
        if is_correct_order(rules.clone(), set.clone()) {
            if let Some(middle) = get_middle_element(&set) {
                sum += middle;
                println!("Valid set: {:?}, Middle element: {}", set, middle);
            }
        } else {
            // println!("Invalid set: {:?}", set);
        }
    }

    println!("Sum of middle elements of valid sets: {}", sum);
}

#[cfg(test)]
mod tests {
    use super::*;

    // Helper to prepare the rules
    fn prepare_rules() -> Vec<String> {
        vec![
            "47|53", "97|13", "97|61", "97|47", "75|29", "61|13", "75|53", "29|13",
            "97|29", "53|29", "61|53", "97|53", "61|29", "47|13", "75|47", "97|75",
            "47|61", "75|61", "47|29", "75|13", "53|13",
        ]
        .into_iter()
        .map(String::from)
        .collect()
    }

    #[test]
    fn test_topological_sort_with_number_set() {
        // Arrange
        let rules = prepare_rules();
        let number_set = vec![75, 47, 61, 53, 29];

        // Act
        let result = is_correct_order(rules, number_set);

        // Assert
        // Validate expected ordering
        // let expected = vec![75, 47, 61, 53, 29];
        assert_eq!(result, true, "The sorted order does not match the expected order.");
    }

    #[test]
    fn test_topological_sort_partial_set() {
        // Arrange
        let rules = prepare_rules();
        let number_set = vec![75,97,47,61,53];

        // Act
        let result = is_correct_order(rules, number_set);

        // Assert
        // let expected = vec![47, 29, 13];
        assert_eq!(result, false, "The sorted order for the partial set does not match.");
    }

    #[test]
    fn test_topological_sort_empty_set() {
        // Arrange
        let rules = prepare_rules();
        let number_set = vec![];

        // Act
        let result = topological_sort(rules, number_set);

        // Assert
        assert!(result.is_empty(), "The result should be an empty list for an empty number set.");
    }

    #[test]
    fn test_topological_sort_with_no_matching_rules() {
        // Arrange
        let rules = prepare_rules();
        let number_set = vec![100, 200, 300]; // No matching rules for these numbers

        // Act
        let result = topological_sort(rules, number_set);

        // Assert
        assert!(result.is_empty(), "The result should be empty if no rules match the number set.");
    }

    #[test]
    fn test_topological_sort_full_dag() {
        // Arrange
        let rules = prepare_rules();
        let number_set = vec![97, 75, 61, 53, 47, 29, 13];

        // Act
        let result = topological_sort(rules, number_set);

        // Assert
        let expected = vec![97, 75, 61, 53, 47, 29, 13];
        assert_eq!(result, expected, "The result does not match the expected full DAG order.");
    }
}

// problem so far: the topological_sort() function is placing each list in the correct order according to the rules. 
// HOWEVER, the prompt only wants me to test whether a given line is in the correct order. 
// if it is, then print the middle element and add it to `sum`.
