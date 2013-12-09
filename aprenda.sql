DROP SCHEMA IF EXISTS aprenda CASCADE;
CREATE SCHEMA aprenda;

DROP TYPE IF EXISTS tipo;
CREATE TYPE tipo AS ENUM ('video', 'link', 'livro');

DROP TABLE IF EXISTS aprenda.usuario CASCADE;
CREATE TABLE aprenda.usuario (
    id SERIAL PRIMARY KEY,
    nome_usuario VARCHAR(20) UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    senha VARCHAR(32) NOT NULL,
    sexo CHAR,
    dt_nascimento DATE
);

DROP INDEX IF EXITS nomeusuario_min;
CREATE INDEX users_lower_email ON aprenda.usuario(lower(nome_usuario));

DROP TABLE IF EXISTS aprenda.topico CASCADE;
CREATE TABLE aprenda.topico (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(40) NOT NULL/*,
    slug VARCHAR (40) UNIQUE NOT NULL*/
);

DROP TABLE IF EXISTS aprenda.subtopico CASCADE;
CREATE TABLE aprenda.subtopico (
    topico_id SERIAL REFERENCES aprenda.topico
        ON DELETE RESTRICT,
    subtopico_id SERIAL REFERENCES aprenda.topico
        ON DELETE RESTRICT,
    PRIMARY KEY (topico_id, subtopico_id)
);

DROP TABLE IF EXISTS aprenda.link CASCADE;
CREATE TABLE aprenda.link (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(40) NOT NULL,
    url TEXT NOT NULL
);

DROP TABLE IF EXISTS aprenda.linktopico CASCADE;
CREATE TABLE aprenda.linktopico (
    link_id SERIAL REFERENCES aprenda.link
        ON DELETE CASCADE,
    topico_id SERIAL REFERENCES aprenda.topico
        ON DELETE CASCADE,
    criador_id SERIAL REFERENCES aprenda.usuario
        ON DELETE SET NULL,
    data DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (link_id, topico_id)
);

DROP TABLE IF EXISTS aprenda.livro CASCADE;
CREATE TABLE aprenda.livro (
    id SERIAL PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL
);

DROP TABLE IF EXISTS aprenda.livrotopico CASCADE;
CREATE TABLE aprenda.livrotopico (
    livro_id SERIAL REFERENCES aprenda.livro
        ON DELETE CASCADE,
    topico_id SERIAL REFERENCES aprenda.topico
        ON DELETE CASCADE,
    criador_id SERIAL REFERENCES aprenda.usuario
        ON DELETE SET NULL,
    data DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (livro_id, topico_id)
);

DROP TABLE IF EXISTS aprenda.video CASCADE;
CREATE TABLE aprenda.video (
    id SERIAL PRIMARY KEY,
    url TEXT NOT NULL
);

DROP TABLE IF EXISTS aprenda.videotopico CASCADE;
CREATE TABLE aprenda.videotopico (
    video_id SERIAL REFERENCES aprenda.video
        ON DELETE CASCADE,
    topico_id SERIAL REFERENCES aprenda.topico
        ON DELETE CASCADE,
    criador_id SERIAL REFERENCES aprenda.usuario
        ON DELETE SET NULL,
    data DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (video_id, topico_id)
);

DROP TABLE IF EXISTS aprenda.comentario CASCADE;
CREATE TABLE aprenda.comentario (
    id SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    topico_id SERIAL REFERENCES aprenda.topico
        ON DELETE SET NULL,
    criador_id SERIAL REFERENCES aprenda.usuario
        ON DELETE SET NULL,
    tipo TIPO NOT NULL,
    video_id SERIAL REFERENCES aprenda.video
        ON DELETE CASCADE,
    livro_id SERIAL REFERENCES aprenda.livro
        ON DELETE CASCADE,
    link_id SERIAL REFERENCES aprenda.link
        ON DELETE CASCADE
);

-- Populando --

INSERT INTO aprenda.usuario (nome_usuario, email, senha, sexo, dt_nascimento) VALUES
    ('Felipe', 'felipecortezfi@gmail.com', '849d2fdca1ee9d6d6b7239fedbd19305', 'M', '1995-07-21');
---
INSERT INTO aprenda.topico (titulo) VALUES
    ('Ciência da Computação'),  -- 1
    ('Teoria dos Grafos'),      -- 2
    ('Banco de Dados'),         -- 3
    ('Matemática Aplicada'),    -- 4
    ('Música'),                 -- 5
    ('História da Música'),     -- 6
    ('Programação'),            -- 7
    ('Desenvolvimento Web'),    -- 8
    ('Python'),                 -- 9
    ('Flask'),                  -- 10
    ('Ruby'),                   -- 11
    ('Ruby on Rails');          -- 12
---
INSERT INTO aprenda.subtopico (topico_id, subtopico_id) VALUES
    (1, 3),
    (1, 2),
    (1, 7),
    (1, 8),
    (4, 1),
    (5, 6);
---
INSERT INTO aprenda.link (titulo, url) VALUES
    ('Teoria dos grafos (Wikipedia)', 'https://pt.wikipedia.org/wiki/Teoria_dos_grafos'),
    ('Primers', 'http://jeremykun.com/primers/');
---
INSERT INTO aprenda.linktopico (link_id, topico_id, criador_id) VALUES
    (1, 1, 1),
    (1, 2, 1);
---
INSERT INTO aprenda.video (url) VALUES
    ('https://www.youtube.com/watch?v=k6U-i4gXkLM'),    -- MIT Introduction to Computer Science
    ('https://www.youtube.com/watch?v=gCpAE4K38j0'),    -- The P versus NP problem
    ('https://www.youtube.com/watch?v=aXFBW-MllmA'),    -- What is the point of music?
    ('https://www.youtube.com/watch?v=HmQR8Xy9DeM');    -- Graph theory - An introduction
---
INSERT INTO aprenda.videotopico (video_id, topico_id, criador_id) VALUES
    (1, 1, 1),
    (2, 1, 1),
    (3, 5, 1),
    (4, 2, 1);
---
INSERT INTO aprenda.livro (isbn) VALUES
    ('0262033844'),     -- Algoritmos (Cormen)
    ('0132569035'),     -- Computer Science: An Overview
    ('9788525031433'),  -- Música, Maestro!
    ('0136086209');     -- Fundamentals of Database Systems
---
INSERT INTO aprenda.livrotopico (livro_id, topico_id, criador_id) VALUES
    (1, 1, 1),
    (1, 2, 1),
    (2, 1, 1),
    (3, 5, 1),
    (3, 6, 1),
    (4, 2, 1),
    (4, 3, 1);
