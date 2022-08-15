#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY types(id,name)
    FROM '/docker-entrypoint-initdb.d/types.csv'
    DELIMITER ','
    CSV HEADER;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY moves(id, name, accuracy, power_points, priority, power, description, type_id)
    FROM '/docker-entrypoint-initdb.d/moves.csv'
    DELIMITER ','
    CSV HEADER;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY pokemon(id,name,height,weight,base_experience)
    FROM '/docker-entrypoint-initdb.d/pokemon.csv'
    DELIMITER ','
    CSV HEADER;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY pokemon_types(pokemon_id,type_id)
    FROM '/docker-entrypoint-initdb.d/pokemon_types.csv'
    DELIMITER ','
    CSV HEADER;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    COPY pokemon_moves(pokemon_id,move_id)
    FROM '/docker-entrypoint-initdb.d/pokemon_moves.csv'
    DELIMITER ','
    CSV HEADER;
EOSQL

