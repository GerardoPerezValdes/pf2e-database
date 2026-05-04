# PF2e Database

A Julia-based web scraper for Pathfinder 2nd Edition creature data from [Archives of Nethys](https://2e.aonprd.com/).

## Overview

This repository provides a Julia module (`PF2eCreatureDB.jl`) to fetch and extract creature data from the official Pathfinder 2nd Edition database. It includes functions to retrieve creature information by ID, scrape the monster index for valid IDs, and parse HTML to extract relevant creature attributes.

## Features

- **Fetch Single Creature**: Retrieve a creature by its unique ID from Archives of Nethys.
- **Fetch Multiple Creatures**: Fetch a range of creatures by specifying start and end IDs.
- **List All Creature IDs**: Scrape the monster index to get a list of all valid creature IDs.
- **Extract Creature Data**: Parse HTML to extract:
  - Name
  - Level
  - Description
  - Types
  - Traits

## Rate Limiting

The module enforces a minimum delay of **0.1 seconds** between requests (10 requests/second max) to respect Archives of Nethys' servers.

## Usage

### 1. Add Dependencies

Ensure you have the required Julia packages installed:

```julia
using Pkg
Pkg.add(["HTTP", "Gumbo", "Cascadia", "JSON3"])
```

### 2. Include the Module

```julia
include("PF2eCreatureDB.jl")
using .PF2eCreatureDB
```

### 3. Fetch Data

#### Fetch a Single Creature

```julia
creature = fetch_creature(1)  # Replace 1 with the desired creature ID
println(creature[:name])
```

#### Fetch Multiple Creatures

```julia
creatures = fetch_creatures(1, 10)  # Fetch creatures with IDs 1 through 10
for c in creatures
    println("$(c[:name]) (Level $(c[:level]))")
end
```

#### List All Creature IDs

```julia
ids = list_creature_ids()
println("Total creatures: $(length(ids))")
```

## Functions

| Function | Description |
|----------|-------------|
| `fetch_creature(id; delay=MIN_DELAY)` | Fetch a single creature by ID. |
| `fetch_creatures(start_id, end_id; delay=MIN_DELAY)` | Fetch creatures in a range of IDs. |
| `extract_creature_data(root)` | Extract data from parsed HTML. |
| `list_creature_ids(; delay=MIN_DELAY)` | List all valid creature IDs. |

## Dependencies

- [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl) - HTTP client for Julia.
- [Gumbo.jl](https://github.com/JuliaWeb/Gumbo.jl) - HTML parser.
- [Cascadia.jl](https://github.com/JuliaWeb/Cascadia.jl) - CSS selector library.
- [JSON3.jl](https://github.com/JuliaIO/JSON3.jl) - JSON parsing (included for future use).

## License

This project is provided as-is for personal and non-commercial use. Respect Archives of Nethys' terms of service when scraping.
