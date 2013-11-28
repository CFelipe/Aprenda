 #!/usr/bin/python
# -*- coding: utf-8 -*-

import psycopg2, psycopg2.extras, json, urllib2

psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
psycopg2.extensions.register_type(psycopg2.extensions.UNICODEARRAY)

db_credentials = 'dbname=aprenda user=felipecortez'

def connect():
    return psycopg2.connect(db_credentials)

def get_topicos():
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute('''
                SELECT * FROM aprenda.topico
                ''')
    topicos = cur.fetchall()
    cur.close()
    conn.close()
    return topicos

def get_topico(idtopico):
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute('''
                SELECT * FROM aprenda.topico t WHERE t.id = %s
                ''', [idtopico])
    topico = cur.fetchone()
    
    cur.execute('''
                SELECT st.subtopico_id AS st_id, t.titulo AS st_titulo
                FROM aprenda.topico t, aprenda.subtopico st
                WHERE t.id = st.subtopico_id AND st.topico_id = %s
                ''', [idtopico])
    topico['subtopicos'] = cur.fetchall()
    
    cur.execute('''
                SELECT st.topico_id AS st_id, t.titulo AS st_titulo
                FROM aprenda.topico t, aprenda.subtopico st
                WHERE t.id = st.topico_id AND st.subtopico_id = %s
                ''', [idtopico])
    topico['supertopicos'] = cur.fetchall()
    
    cur.execute('''
                SELECT t.titulo AS topico, l.isbn, u.nome_usuario AS criador
                FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt, aprenda.usuario u
                WHERE lt.livro_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = %s
                ''', [idtopico])
    topico['livros'] = cur.fetchall()
    for livro in topico['livros']:
	url = "https://www.googleapis.com/books/v1/volumes?q=isbn:%s" % livro['isbn']
        try: 
            response = urllib2.urlopen(url);
            try:
                data = json.loads(response.read()) 
                if(int(data['totalItems']) != 0):
                    if 'title' in data['items'][0]['volumeInfo']:
                        livro['titulo'] = data['items'][0]['volumeInfo']['title']
                    if 'subtitle' in data['items'][0]['volumeInfo']:
                        livro['subtitulo'] = data['items'][0]['volumeInfo']['subtitle']
                    if 'authors' in data['items'][0]['volumeInfo']:
                        livro['autores'] = data['items'][0]['volumeInfo']['authors']
                        
                        livro['autorstring'] = ", ".join(livro['autores'])
                        
                    if 'description' in data['items'][0]['volumeInfo']:
                        livro['desc'] = data['items'][0]['volumeInfo']['description']
                else:
                    print "Não há livro com o ISBN informado"
            except ValueError:
                livro['titulo'] = livro['isbn']
        except urllib2.URLError:
            livro['titulo'] = livro['isbn']
            
    cur.execute('''
                SELECT l.titulo, l.url, u.nome_usuario AS criador
                FROM aprenda.topico t, aprenda.link l, aprenda.linktopico lt, aprenda.usuario u
                WHERE lt.link_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = %s
                ''', [idtopico])
    topico['links'] = cur.fetchall()
            
    cur.close()
    conn.close()
    return topico

def get_livros_topico(idtopico):
    conn = connect()
    cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute('''
                SELECT t.titulo AS topico, l.isbn, u.nome_usuario AS criador
                FROM aprenda.topico t, aprenda.livro l, aprenda.livrotopico lt, aprenda.usuario u
                WHERE lt.livro_id = l.id AND lt.topico_id = t.id AND lt.criador_id = u.id AND t.id = %s;
                ''', [idtopico])
    livros = cur.fetchall()
    
    for livro in livros:
	url = "https://www.googleapis.com/books/v1/volumes?q=isbn:%s" % livro['isbn']
        try: 
            response = urllib2.urlopen(url);
            data = json.loads(response.read()) 
            if(int(data['totalItems']) != 0):
                if 'title' in data['items'][0]['volumeInfo']:
                    livro['titulo'] = data['items'][0]['volumeInfo']['title']
                if 'subtitle' in data['items'][0]['volumeInfo']:
                    livro['subtitulo'] = data['items'][0]['volumeInfo']['subtitle']
                if 'authors' in data['items'][0]['volumeInfo']:
                    livro['autores'] = data['items'][0]['volumeInfo']['authors']
                if 'description' in data['items'][0]['volumeInfo']:
                    livro['desc'] = data['items'][0]['volumeInfo']['description']
            else:
                print "Não há livro com o ISBN informado"
	except urllib2.URLError as e:
            print "ih"
    
    cur.close()
    conn.close()
    return livros
