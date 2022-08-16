/*
*************************
POKEMON DATABASE
*************************
*/
GRANT ALL PRIVILEGES ON DATABASE pokemon TO oak;

/*
The collection of pokemon
*/
CREATE TABLE "pokemon" (
  "id" INTEGER,
  "name" TEXT,
  "height" INTEGER, /* In dm */
  "weight" INTEGER, /* In Hg */
  "base_experience" INTEGER,
  PRIMARY KEY ("id")
);

/*
The types (e.g. fire) that a pokemon, move
or ability can have
*/
CREATE TABLE "types" (
  "id" INTEGER,
  "name" TEXT,
  PRIMARY KEY ("id")
);

/*
The moves that can be learned by pokemon
*/
CREATE TABLE "moves" (
  "id" INTEGER,
  "name" TEXT,
  "accuracy" INTEGER,
  "power_points" INTEGER,
  "priority" INTEGER,
  "power" INTEGER,
  "description" TEXT,
  "type_id" INTEGER,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_moves.type_id"
    FOREIGN KEY ("type_id")
      REFERENCES "types"("id") ON DELETE CASCADE
);

/*
A pokemon can have several types. A type
has several pokemon.
*/
CREATE TABLE "pokemon_types" (
  "pokemon_id" INTEGER,
  "type_id" INTEGER,
  PRIMARY KEY ("pokemon_id", "type_id"),
  CONSTRAINT "FK_pokemon_types.type_id"
    FOREIGN KEY ("type_id")
      REFERENCES "types"("id") ON DELETE CASCADE,
  CONSTRAINT "FK_pokemon_types.pokemon_id"
    FOREIGN KEY ("pokemon_id")
      REFERENCES "pokemon"("id") ON DELETE CASCADE
);

/*
A pokemon can learn several moves. A move can be learned
by several pokemon.
*/
CREATE TABLE "pokemon_moves" (
  "pokemon_id" INTEGER,
  "move_id" INTEGER,
  PRIMARY KEY ("pokemon_id", "move_id"),
  CONSTRAINT "FK_pokemon_moves.pokemon_id"
    FOREIGN KEY ("pokemon_id")
      REFERENCES "pokemon"("id") ON DELETE CASCADE,
  CONSTRAINT "FK_pokemon_moves.move_id"
    FOREIGN KEY ("move_id")
      REFERENCES "moves"("id") ON DELETE CASCADE
);

