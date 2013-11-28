-- Consultas básicas --

-- Usuários no sistema
SELECT * FROM aprenda.usuario;

-- Relação de tópicos e seus subtópicos
SELECT t1.id AS t_id, t1.titulo AS t_titulo, t2.id AS st_id, t2.titulo AS st_titulo
FROM aprenda.topico t1, aprenda.topico t2, aprenda.subtopico st
WHERE t1.id = st.topico_id AND t2.id = st.subtopico_id;

-- Relação de tópicos e seus links
SELECT t.titulo AS topico, l.titulo AS link_titulo, l.url, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.link l, aprenda.linktopico lt, aprenda.usuario u
WHERE lt.link_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id;

-- Relação de tópicos e seus vídeos
SELECT t.titulo AS topico, v.url AS video_titulo, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.video v, aprenda.videotopico vt, aprenda.usuario u
WHERE vt.video_id = v.id AND vt.topico_id = t.id AND vt.criador_id = u.id;

-- Relação de tópicos e seus livros
SELECT t.titulo AS topico, l.isbn, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt, aprenda.usuario u
WHERE lt.livro_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id;

-- Relação de um tópico específico e seus livros
SELECT t.titulo AS topico, l.isbn, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt, aprenda.usuario u
WHERE lt.livro_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = 1;

----

-- Usados no site --

-- Subtópicos de um tópico (id 1 para exemplificar)
SELECT st.subtopico_id AS st_id, t.titulo AS st_titulo
FROM aprenda.topico t, aprenda.subtopico st
WHERE st.topico_id = 1 AND t.id = st.subtopico_id;

-- Supertópicos de um tópico (id 1 para exemplificar)
SELECT st.topico_id AS st_id, t.titulo AS st_titulo
FROM aprenda.topico t, aprenda.subtopico st
WHERE st.subtopico_id = 1 AND t.id = st.topico_id;

-- Livros de um tópico (id 1 para exemplificar)
SELECT l.isbn, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt, aprenda.usuario u
WHERE lt.livro_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = 1;

-- Links de um tópico (id 1 para exemplificar)
SELECT l.titulo, l.url, u.nome_usuario AS criador
FROM aprenda.topico t, aprenda.link l, aprenda.linktopico lt, aprenda.usuario u
WHERE lt.link_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = 1;
