# Day Three - Advent of Code 2024

function read_input(filepath::String)
    content = read(filepath, String)
    
    # Split into two sections by blank line
    sections = split(content, "\n\n")
    
    # Parse ordering rules
    rules = Dict{Int, Set{Int}}()
    for line in split(sections[1], '\n')
        if !isempty(strip(line))
            parts = split(line, '|')
            before = parse(Int, parts[1])
            after = parse(Int, parts[2])
            
            # Initialize set if key doesn't exist
            if !haskey(rules, before)
                rules[before] = Set{Int}()
            end
            push!(rules[before], after)
        end
    end
    
    # Parse updates
    updates = Vector{Vector{Int}}()
    for line in split(sections[2], '\n')
        if !isempty(strip(line))
            pages = parse.(Int, split(line, ','))
            push!(updates, pages)
        end
    end
    
    return rules, updates
end

# Usage
filepath = joinpath("input", "dayFive.txt")
rules, updates = read_input(filepath)

println("Number of rules: ", length(rules))
println("Number of updates: ", length(updates))
println("First rule sample: ", first(rules))
println("First update: ", updates[1])