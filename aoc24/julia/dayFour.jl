function read_input(filepath::String)
    grid = Vector{String}()
    open(filepath, "r") do file
        for line in eachline(file)
            if !isempty(strip(line))
                push!(grid, strip(line))
            end
        end
    end
    return grid
end

function solve_part1(grid::Vector{String})
    rows = length(grid)
    cols = length(grid[1])
    word = "XMAS"
    count = 0
    
    # 8 directions: right, left, down, up, diag-down-right, diag-down-left, diag-up-right, diag-up-left
    directions = [
        (0, 1),   # right
        (0, -1),  # left
        (1, 0),   # down
        (-1, 0),  # up
        (1, 1),   # diagonal down-right
        (1, -1),  # diagonal down-left
        (-1, 1),  # diagonal up-right
        (-1, -1)  # diagonal up-left
    ]
    
    function check_word(row, col, dr, dc)
        for i in 0:3
            r = row + i * dr
            c = col + i * dc
            
            # Check bounds
            if r < 1 || r > rows || c < 1 || c > cols
                return false
            end
            
            # Check character
            if grid[r][c] != word[i+1]
                return false
            end
        end
        return true
    end
    
    # Check every position as potential start
    for row in 1:rows
        for col in 1:cols
            for (dr, dc) in directions
                if check_word(row, col, dr, dc)
                    count += 1
                end
            end
        end
    end
    
    return count
end

function solve_part2(grid::Vector{String})
    rows = length(grid)
    cols = length(grid[1])
    count = 0
    
    function check_xmas(row, col)
        # Center must be 'A'
        if grid[row][col] != 'A'
            return false
        end
        
        # Check bounds for diagonals
        if row < 2 || row > rows - 1 || col < 2 || col > cols - 1
            return false
        end
        
        # Get diagonal characters
        # Top-left to bottom-right diagonal
        tl = grid[row-1][col-1]
        br = grid[row+1][col+1]
        
        # Top-right to bottom-left diagonal
        tr = grid[row-1][col+1]
        bl = grid[row+1][col-1]
        
        # Check if both diagonals form MAS (forward or backward)
        diag1_valid = (tl == 'M' && br == 'S') || (tl == 'S' && br == 'M')
        diag2_valid = (tr == 'M' && bl == 'S') || (tr == 'S' && bl == 'M')
        
        return diag1_valid && diag2_valid
    end
    
    # Check every position as potential center of X
    for row in 2:rows-1
        for col in 2:cols-1
            if check_xmas(row, col)
                count += 1
            end
        end
    end
    
    return count
end

# Main execution
filepath = joinpath("input", "dayFour.txt")
grid = read_input(filepath)

part1 = solve_part1(grid)
part2 = solve_part2(grid)

println("Part 1: $part1")
println("Part 2: $part2")

# Test with example
test_grid = [
    "MMMSXXMASM",
    "MSAMXMSMSA",
    "AMXSXMAAMM",
    "MSAMASMSMX",
    "XMASAMXAMM",
    "XXAMMXXAMA",
    "SMSMSASXSS",
    "SAXAMASAAA",
    "MAMMMXMMMM",
    "MXMXAXMASX"
]

println("\nTest Part 1: $(solve_part1(test_grid)) (expected 18)")
println("Test Part 2: $(solve_part2(test_grid)) (expected 9)")