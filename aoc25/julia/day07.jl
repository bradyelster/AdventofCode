# Brady Elster
# Advent of Code 2025 - Day 07

function count_splits(lines)
    grid = collect.(lines)
    H = length(grid)
    W = length(grid[1])

    # find S
    rS, cS = 0, 0
    for r in 1:H
        c = findfirst(==('S'), grid[r])
        if c !== nothing
            rS, cS = r, c
            break
        end
    end

    # beams[r][c] = number of beams entering row r at column c
    beams = zeros(Int, H, W)
    beams[rS, cS] = 1

    splits = 0

    for r in rS:H-1
        for c in 1:W
            b = beams[r, c]
            b == 0 && continue

            if grid[r][c] == '^'
                # This splitter is hit, so count it as 1 split
                splits += 1
                if c > 1
                    beams[r+1, c-1] += b
                end
                if c < W
                    beams[r+1, c+1] += b
                end
            else
                # beam just continues straight down
                beams[r+1, c] += b
            end
        end
    end

    return splits
end

function count_timelines(lines)
    grid = collect.(lines)
    H = length(grid)
    W = length(grid[1])

    # find S
    rS, cS = 0, 0
    for r in 1:H
        c = findfirst(==('S'), grid[r])
        if c !== nothing
            rS, cS = r, c
            break
        end
    end

    # timelines[r][c] = number of different timelines that reach position (r, c)
    timelines = zeros(Int, H, W)
    timelines[rS, cS] = 1

    for r in rS:H-1
        for c in 1:W
            t = timelines[r, c]
            t == 0 && continue

            if grid[r][c] == '^'
                # Timeline splits: each timeline creates 2 new timelines
                if c > 1
                    timelines[r+1, c-1] += t
                end
                if c < W
                    timelines[r+1, c+1] += t
                end
            else
                # Timeline continues straight down
                timelines[r+1, c] += t
            end
        end
    end

    # Sum all timelines that reached the bottom row
    return sum(timelines[H, :])
end

function part_one(lines)
    return count_splits(lines)
end

function part_two(lines)
    return count_timelines(lines)
end

function main()
    lines = readlines("input/day07.txt")

    result1 = part_one(lines)
    println("Part 1: $result1")

    result2 = part_two(lines)
    println("Part 2: $result2")
end

main()