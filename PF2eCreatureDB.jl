module PF2eCreatureDB


using HTTP


using Gumbo


using Cascadia


using JSON3



const BASE_URL = "https://2e.aonprd.com/Monsters.aspx?ID="


const MIN_DELAY = 0.1  # Minimum delay in seconds (10 requests/second max)



"""

    fetch_creature(id::Int; delay::Float64=MIN_DELAY)



Fetch a single creature by its ID from Archives of Nethys.


Respects rate limiting with a minimum delay of 0.1 seconds (10 requests/second max).


"""

function fetch_creature(id::Int; delay::Float64=MIN_DELAY)


    actual_delay = max(delay, MIN_DELAY)


    sleep(actual_delay)



    url = "$BASE_URL$id"


    response = HTTP.get(url)


    if response.status != 200


        error("Failed to fetch creature with ID $id: HTTP $(response.status)")


    end



    root = parsehtml(String(response.body))


    creature = extract_creature_data(root)


    return creature


end



"""

    fetch_creatures(start_id::Int, end_id::Int; delay::Float64=MIN_DELAY)



Fetch multiple creatures by their ID range.


Respects rate limiting with a minimum delay of 0.1 seconds (10 requests/second max).


"""

function fetch_creatures(start_id::Int, end_id::Int; delay::Float64=MIN_DELAY)


    creatures = []


    for id in start_id:end_id


        creature = fetch_creature(id; delay=delay)


        push!(creatures, creature)


    end


    return creatures


end



"""

    extract_creature_data(root::HTMLDocument)



Extract relevant data (name, level, description, types, traits) from the HTML of a creature page.


"""

function extract_creature_data(root::HTMLDocument)


    creature = Dict(


        :name => "",


        :level => "",


        :description => "",


        :types => String[],


        :traits => String[]


    )



    # Extract name


    name_node = eachmatch(Selector("h1"), root.root)[1]


    creature[:name] = text(name_node)



    # Extract level


    level_node = eachmatch(Selector(".creature-level"), root.root)


    if !isempty(level_node)


        creature[:level] = text(level_node[1])


    end



    # Extract description


    desc_node = eachmatch(Selector(".creature-description"), root.root)


    if !isempty(desc_node)


        creature[:description] = text(desc_node[1])


    end



    # Extract types


    type_nodes = eachmatch(Selector(".creature-type"), root.root)


    for node in type_nodes


        push!(creature[:types], text(node))


    end



    # Extract traits


    trait_nodes = eachmatch(Selector(".creature-traits a"), root.root)


    for node in trait_nodes


        push!(creature[:traits], text(node))


    end



    return creature


end



"""

    list_creature_ids(; delay::Float64=MIN_DELAY)



List all valid creature IDs by scraping the monster index.


Respects rate limiting with a minimum delay of 0.1 seconds (10 requests/second max).


"""

function list_creature_ids(; delay::Float64=MIN_DELAY)


    actual_delay = max(delay, MIN_DELAY)


    sleep(actual_delay)



    index_url = "https://2e.aonprd.com/Monsters.aspx"


    response = HTTP.get(index_url)


    if response.status != 200


        error("Failed to fetch monster index: HTTP $(response.status)")


    end



    root = parsehtml(String(response.body))


    id_links = eachmatch(Selector("a[href*='Monsters.aspx?ID=']"), root.root)


    ids = Int[]


    for link in id_links


        href = getattr(link, "href")


        id_match = match(r"ID=(\d+)", href)


        if id_match !== nothing


            push!(ids, parse(Int, id_match.captures[1]))


        end


    end


    return unique(ids)


end



end # module PF2eCreatureDB