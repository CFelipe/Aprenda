 #!/usr/bin/python
# -*- coding: utf-8 -*-

import psycopg2
import psycopg2.extras
import json
import urllib2

psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
psycopg2.extensions.register_type(psycopg2.extensions.UNICODEARRAY)

db_credentials = 'dbname=aprenda user=felipecortez'

def connect():
    return psycopg2.connect(db_credentials)

def get_usuario(nomeusuario):
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute('''
                SELECT *
                FROM aprenda.usuario
                WHERE lower(nome_usuario) = lower(%s)
                ''', [nomeusuario])
    usuario = cur.fetchone()

    cur.close()
    conn.close()
    return usuario

def validar_usuario(nomeusuario, emailusuario):
    valido = {}
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute('''
                SELECT *
                FROM aprenda.usuario
                WHERE lower(nome_usuario) = lower(%s)
                ''', [nomeusuario])
    u_nome = cur.fetchone()
    valido['nomeusuario'] = not u_nome
    cur.execute('''
                SELECT *
                FROM aprenda.usuario
                WHERE lower(email) = lower(%s)
                ''', [emailusuario])
    u_email = cur.fetchone()
    valido['email'] = not u_email
    cur.close()
    conn.close()
    return valido

def get_topicos():
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

    cur.execute('''
                SELECT *
                FROM aprenda.topico
                ''')
    topicos = cur.fetchall()

    for topico in topicos:
        # n_subtopicos -----------------
        cur.execute('''
                    SELECT count(subtopico_id)
                    FROM aprenda.subtopico
                    WHERE topico_id = %s
                    ''', [topico['id']])
        topico['n_subtopicos'] = cur.fetchone()['count']

        # n_supertopicos -----------------
        cur.execute('''
                    SELECT count(topico_id)
                    FROM aprenda.subtopico
                    WHERE subtopico_id = %s
                    ''', [topico['id']])
        topico['n_supertopicos'] = cur.fetchone()['count']

        # n_links ------------------------
        cur.execute('''
                    SELECT count(link_id)
                    FROM aprenda.linktopico
                    WHERE topico_id = %s
                    ''', [topico['id']])
        topico['n_links'] = cur.fetchone()['count']

        # n_videos -----------------------
        cur.execute('''
                    SELECT count(video_id)
                    FROM aprenda.videotopico
                    WHERE topico_id = %s
                    ''', [topico['id']])
        topico['n_videos'] = cur.fetchone()['count']

        # n_livros -----------------------
        cur.execute('''
                    SELECT count(livro_id)
                    FROM aprenda.livrotopico
                    WHERE topico_id = %s
                    ''', [topico['id']])
        topico['n_livros'] = cur.fetchone()['count']

    cur.close()
    conn.close()
    return topicos

def get_topico(idtopico):
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

    # Tópico ------------------

    cur.execute('''
                SELECT *
                FROM aprenda.topico t
                WHERE t.id = %s
                ''', [idtopico])
    topico = cur.fetchone()

    # Subtópicos --------------

    cur.execute('''
                SELECT st.subtopico_id AS st_id, t.titulo AS st_titulo
                FROM aprenda.topico t, aprenda.subtopico st
                WHERE t.id = st.subtopico_id AND st.topico_id = %s
                ''', [idtopico])
    topico['subtopicos'] = cur.fetchall()

    # Supertópicos ------------

    cur.execute('''
                SELECT st.topico_id AS st_id, t.titulo AS st_titulo
                FROM aprenda.topico t, aprenda.subtopico st
                WHERE t.id = st.topico_id AND st.subtopico_id = %s
                ''', [idtopico])
    topico['supertopicos'] = cur.fetchall()

    # Livros ------------------

    cur.execute('''
                SELECT l.id, l.isbn, l.titulo, l.subtitulo
                FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt
                WHERE lt.livro_id = l.id AND lt.topico_id = t.id
                AND t.id = %s;
                ''', [idtopico])
    topico['livros'] = cur.fetchall()

    for livro in topico['livros']:
        cur.execute('''
                    SELECT e.nome
                    FROM aprenda.livro l, aprenda.escritor e,
                    aprenda.escritorlivro el
                    WHERE el.livro_id = l.id AND el.escritor_id = e.id
                    AND l.id = %s;
                    ''', [livro['id']])
        escritores = cur.fetchall()
        livro['escritores'] = ""
        for escritor in escritores:
            livro['escritores'] += escritor['nome'] + ", "

        livro['escritores'] = livro['escritores'][:-2]

    print topico['livros']

    # Links -------------------

    cur.execute('''
                SELECT l.titulo, l.url, u.nome_usuario AS criador
                FROM aprenda.topico t, aprenda.link l, aprenda.linktopico lt, aprenda.usuario u
                WHERE lt.link_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = %s
                ''', [idtopico])
    topico['links'] = cur.fetchall()

    cur.close()
    conn.close()
    return topico
