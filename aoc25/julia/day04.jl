# Brady Elster
# Advent of Code 2025 - Day 04

# Read a grid of '.' and '@' into a Matrix{Int}
function read_rolls(filename::String)::Matrix{Int}
    lines = readlines(filename)
    nrows = length(lines)
    ncols = length(lines[1])

    grid = Array{Int}(undef, nrows, ncols)

    for i in 1:nrows
        line = lines[i]
        @assert length(line) == ncols "Inconsistent row length"
        for j in 1:ncols
            grid[i, j] = line[j] == '@' ? 1 : 0
        end
    end

    return grid
end

# accessible_rolls rolls with fewer than neighbor_rolls neighboring rolls
function count_accessible_rolls(rollmat::Matrix{Int}, neighbor_rolls::Integer)::Integer
    accessible_rolls = 0
    nrows, ncols = size(rollmat)

    for i in 1:nrows
        for j in 1:ncols

            # Only check neighbors if this is a roll
            if rollmat[i, j] == 1

                neighbors = 0

                # Loop over 8 neighbors (diagonals included)
                for di in -1:1
                    for dj in -1:1
                        # skip the center
                        if di == 0 && dj == 0
                            continue
                        end

                        ni = i + di
                        nj = j + dj

                        # check bounds
                        if 1 ≤ ni ≤ nrows && 1 ≤ nj ≤ ncols
                            neighbors += rollmat[ni, nj]
                        end
                    end
                end

                # Accessible if fewer than neighbor_rolls rolls around it
                if neighbors < neighbor_rolls
                    accessible_rolls += 1
                end
            end
        end
    end

    return accessible_rolls
end

function part_one(filename::String)::Integer
    mat = read_rolls(filename)
    total = count_accessible_rolls(mat, 4)
    return total
end

function part_two(filename::String)::Integer
    mat = read_rolls(filename)
    nrows, ncols = size(mat)

    total_removed = 0

    while true
        accessible = Vector{Tuple{Int,Int}}()

        # 1. Find accessible rolls this round
        for i in 1:nrows
            for j in 1:ncols
                if mat[i, j] == 1
                    neighbors = 0

                    for di in -1:1
                        for dj in -1:1
                            if di == 0 && dj == 0
                                continue
                            end
                            ni = i + di
                            nj = j + dj
                            if 1 ≤ ni ≤ nrows && 1 ≤ nj ≤ ncols
                                neighbors += mat[ni, nj]
                            end
                        end
                    end

                    if neighbors < 4
                        push!(accessible, (i, j))
                    end
                end
            end
        end

        # 2. Stop if none left
        if isempty(accessible)
            return total_removed
        end

        # 3. Remove them (set to zero)
        for (i, j) in accessible
            mat[i, j] = 0
        end

        # 4. Update total removed
        total_removed += length(accessible)
    end
end

function main()
    TESTFILE = "input/day04.txt"
    println("Part 1: ", part_one(TESTFILE))
    println("Part 2: ", part_two(TESTFILE))
end

main()
