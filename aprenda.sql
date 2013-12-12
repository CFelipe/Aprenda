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

DROP INDEX IF EXISTS nomeusuario_min;
CREATE INDEX nomeusuario_min ON aprenda.usuario(lower(nome_usuario));

DROP INDEX IF EXISTS email_min;
CREATE INDEX email_min ON aprenda.usuario(lower(email));

DROP TABLE IF EXISTS aprenda.topico CASCADE;
CREATE TABLE aprenda.topico (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(40) NOT NULL
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
    titulo TEXT NOT NULL,
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
    isbn VARCHAR(13) NOT NULL,
    titulo TEXT NOT NULL,
    subtitulo TEXT
);

DROP TABLE IF EXISTS aprenda.escritor CASCADE;
CREATE TABLE aprenda.escritor (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

DROP TABLE IF EXISTS aprenda.escritorlivro CASCADE;
CREATE TABLE aprenda.escritorlivro (
    livro_id SERIAL REFERENCES aprenda.livro
        ON DELETE CASCADE,
    escritor_id SERIAL REFERENCES aprenda.escritor
        ON DELETE RESTRICT,
    PRIMARY KEY (livro_id, escritor_id)
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
    titulo TEXT NOT NULL,
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

INSERT INTO aprenda.usuario (
    nome_usuario, email, senha, sexo, dt_nascimento) VALUES
    ('Felipe', 'felipecortezfi@gmail.com', '849d2fdca1ee9d6d6b7239fedbd19305',
        'M', '1995-07-21');
---
INSERT INTO aprenda.topico (titulo) VALUES
    ('Ciência da Computação'),  -- 1
    ('Teoria dos Grafos'),      -- 2
    ('Banco de Dados'),         -- 3
    ('Matemática Aplicada'),    -- 4
    ('Música'),                 -- 5
    ('História da Música');     -- 6
---
INSERT INTO aprenda.subtopico (topico_id, subtopico_id) VALUES
    (1, 3),
    (1, 2),
    (4, 1),
    (5, 6);
---
INSERT INTO aprenda.link (titulo, url) VALUES
    ('Teoria dos grafos',
        'https://pt.wikipedia.org/wiki/Teoria_dos_grafos'),
    ('Primers',
        'http://jeremykun.com/primers/'),
    ('Coursera - Introduction to Databases',
    'https://www.coursera.org/course/db'),
    ('Thinking Sounds',
        'http://cobussen.com/teaching/what-is-music/'),
    ('Music History 102',
        'http://www.ipl.org/div/mushist/');
---
INSERT INTO aprenda.linktopico (link_id, topico_id, criador_id) VALUES
    (1, 1, 1),
    (1, 2, 1),
    (2, 1, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 5, 1),
    (5, 6, 1);
---
INSERT INTO aprenda.video (titulo, url) VALUES
    ('Introduction to Computer Science',
        'https://www.youtube.com/watch?v=k6U-i4gXkLM'),
    ('The P versus NP problem',
        'https://www.youtube.com/watch?v=gCpAE4K38j0'),
    ('What is the point of music?',
        'https://www.youtube.com/watch?v=aXFBW-MllmA'),
    ('Graph Theory - An introduction',
        'https://www.youtube.com/watch?v=HmQR8Xy9DeM');
---
INSERT INTO aprenda.videotopico (video_id, topico_id, criador_id) VALUES
    (1, 1, 1),
    (2, 1, 1),
    (3, 5, 1),
    (4, 2, 1);
---
INSERT INTO aprenda.livro (isbn, titulo, subtitulo) VALUES
    ('0262033844', 'Introduction to Algorithms', NULL),
    ('0132569035', 'Computer Science', 'An Overview'),
    ('9788525031433', 'Música, Maestro!', NULL),
    ('0136086209', 'Fundamentals of Database Systems', NULL);
---
INSERT INTO aprenda.escritor (nome) VALUES
    ('Thomas H. Cormen'),
    ('J. Glenn Brookshear'),
    ('Júlio Medaglia'),
    ('Ramez Elmasri'),
    ('Shamkant Navathe');
---
INSERT INTO aprenda.escritorlivro (livro_id, escritor_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (4, 5);
---
INSERT INTO aprenda.livrotopico (livro_id, topico_id, criador_id) VALUES
    (1, 1, 1),
    (1, 2, 1),
    (2, 1, 1),
    (3, 5, 1),
    (3, 6, 1),
    (4, 2, 1),
    (4, 3, 1);
