import requests
import csv
import re

POKEAPI_BASE_URL = "https://pokeapi.co/api/v2"

def get_all_pokemon() -> list:
    response = requests.get(url=f"{POKEAPI_BASE_URL}/pokemon?limit=5000&offset=0.")
    return response.json()['results']

def get_pokemon_info(name: str) -> dict:
    response = requests.get(url=f"{POKEAPI_BASE_URL}/pokemon/{name}")
    return response.json()

def get_moves() -> list:
    response = requests.get(url=f"{POKEAPI_BASE_URL}/move?limit=5000&offset=0.")
    return response.json()['results']

def get_move(name: str) -> list:
    response = requests.get(url=f"{POKEAPI_BASE_URL}/move/{name}")
    return response.json()

def get_types() -> list:
    response = requests.get(url=f"{POKEAPI_BASE_URL}/type?limit=100&offset=0.")
    return response.json()['results']

def extract_id(url: str) -> int:
    return re.search(f"{POKEAPI_BASE_URL}/\w+/([0-9]+)/", url).group(1)

def sanitize_description(description: str) -> str:
    return description.replace("\n", "").replace(".", "").replace("\"", "")

############################
# TYPES
############################

print("Loading types..")

with open('./pokedb/initdb/types.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerow(["id", "name"])

    types = get_types()
    for type in types:
        writer.writerow([extract_id(type['url']), type['name']])
        
print("Finished loading types.")

############################
# MOVES
############################

print("Loading moves..")

loaded_moves = 0
with open('./pokedb/initdb/moves.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerow(["id", "name", "accuracy", "power_points", 
                     "priority", "power", "description", "type_id"])

    moves = get_moves()
    for move in moves:
        move_info = get_move(move['name'])
        description = ""
        for text_entry in move_info['flavor_text_entries']:
            if text_entry["language"]["name"] == "en":
                description = sanitize_description(text_entry["flavor_text"])
                break
        type_id = extract_id(move_info["type"]["url"])
        writer.writerow([move_info['id'],
                        move_info['name'], 
                        move_info['accuracy'], 
                        move_info['pp'], 
                        move_info['priority'], 
                        move_info['power'], 
                        description, 
                        type_id])
        loaded_moves+=1
        if loaded_moves % 100 == 0:
            print(f"Loaded {loaded_moves} moves..")

print("Finished loading moves.")


############################
# POKEMON
############################


print("Loading pokemon..")

loaded_pokemon=0
with open('./pokedb/initdb/pokemon.csv', 'w') as pokemon, \
    open('./pokedb/initdb/pokemon_types.csv', 'w') as pokemon_types, \
    open('./pokedb/initdb/pokemon_moves.csv', 'w') as pokemon_moves:

    pokemon_writer = csv.writer(pokemon)
    pokemon_types_writer = csv.writer(pokemon_types)
    pokemon_moves_writer = csv.writer(pokemon_moves)
    # CSV HEADER
    pokemon_writer.writerow(["id", "name", "height", "weight", "base_experience"])
    pokemon_types_writer.writerow(["pokemon_id", "type_id"])
    pokemon_moves_writer.writerow(["pokemon_id", "move_id"])

    pokemon_list = get_all_pokemon()
    for pokemon in pokemon_list:
        pokemon_info = get_pokemon_info(pokemon['name'])
        pokemon_writer.writerow([pokemon_info['id'], 
                                 pokemon_info['name'], 
                                 pokemon_info['height'], 
                                 pokemon_info['weight'], 
                                 pokemon_info['base_experience']])
        for type in pokemon_info["types"]:
            pokemon_types_writer.writerow([pokemon_info['id'], 
                                           extract_id(type["type"]["url"])])
        for move in pokemon_info["moves"]:
            pokemon_moves_writer.writerow([pokemon_info['id'], 
                                           extract_id(move["move"]["url"])])
        loaded_pokemon+=1
        if loaded_pokemon % 100 == 0:
            print(f"Loaded {loaded_pokemon} pokemon..")

print("Finished loading pokemon.")
print("Done!")