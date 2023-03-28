CREATE TABLE
    "campeonato" (
        "id_campeonato" INTEGER NOT NULL UNIQUE,
        "nome" TEXT NOT NULL UNIQUE,
        "n_competidores" INTEGER NOT NULL,
        "precoKG" REAL NOT NULL,
        id_ganhador INTEGER,
        PRIMARY KEY("id_campeonato" AUTOINCREMENT),
        FOREIGN KEY("id_ganhador") REFERENCES "competidor"("id_competidor")
    );

CREATE TABLE
    "competidor" (
        "id_competidor" INTEGER NOT NULL UNIQUE,
        "id_campeonato" INTEGER NOT NULL,
        "nome" TEXT NOT NULL UNIQUE,
        "CPF" INTEGER NOT NULL UNIQUE,
        "ano_nasc" INTEGER NOT NULL,
        "cidade" TEXT NOT NULL,
        PRIMARY KEY("id_campeonato" AUTOINCREMENT),
        FOREIGN KEY("id_campeonato") REFERENCES "campeonato"("id_campeonato")
    );

CREATE TABLE
    "partida" (
        "id_partida" INTEGER NOT NULL UNIQUE,
        "id_campeonato" INTEGER NOT NULL,
        "id_competidor1" INTEGER NOT NULL,
        "id_competidor2" INTEGER NOT NULL,
        PRIMARY KEY ("id_partida" AUTOINCREMENT),
        FOREIGN KEY ("id_campeonato") REFERENCES "campeonato"("id_campeonato"),
        FOREIGN KEY ("id_competidor1") REFERENCES "competidor"("id_competidor"),
        FOREIGN KEY ("id_competidor2") REFERENCES "competidor"("id_competidor")
    );

-- INSERT INTO campeonato (nome) VALUES ("teste1");

SELECT * FROM campeonato;

-- DELETE from campeonato;

-- ALTER TABLE "competidor" ADD COLUMN AFTER "ano_nasc" "cidade" TEXT NOT NULL;

-- PRAGMA table_info(competidor);