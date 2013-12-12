-- Consultas básicas --

-- Usuários no sistema
SELECT * FROM aprenda.usuario;

-- Relação de tópicos e seus subtópicos
DROP VIEW IF EXISTS subtopicos;
CREATE VIEW subtopicos AS
SELECT t1.id AS t_id, t1.titulo AS t_titulo, t2.id AS st_id, t2.titulo AS st_titulo
FROM aprenda.topico t1, aprenda.topico t2, aprenda.subtopico st
WHERE t1.id = st.topico_id AND t2.id = st.subtopico_id;

-- Relação de tópicos e seus links
DROP VIEW IF EXISTS links;
CREATE VIEW links AS
SELECT t.titulo AS topico, l.titulo AS link_titulo, l.url, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.link l, aprenda.linktopico lt, aprenda.usuario u
WHERE lt.link_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id;

-- Relação de tópicos e seus vídeos
DROP VIEW IF EXISTS videos;
CREATE VIEW videos AS
SELECT t.titulo AS topico, v.url AS video_titulo, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.video v, aprenda.videotopico vt, aprenda.usuario u
WHERE vt.video_id = v.id AND vt.topico_id = t.id AND vt.criador_id = u.id;

-- Relação de tópicos e seus livros
DROP VIEW IF EXISTS livros;
CREATE VIEW livros AS
SELECT t.titulo AS t_id, l.isbn, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt, aprenda.usuario u
WHERE lt.livro_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id;
