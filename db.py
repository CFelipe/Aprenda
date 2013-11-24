 #!/usr/bin/python
# -*- coding: utf-8 -*-

import psycopg2

psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
psycopg2.extensions.register_type(psycopg2.extensions.UNICODEARRAY)

db_credentials = 'dbname=aprenda user=felipecortez'

def connect():
    return psycopg2.connect(db_credentials)

def get_atletas():
    conn = connect()
    cur = conn.cursor()
    cur.execute('''
                SELECT id, titulo FROM aprenda.topico
                ''')
    atletas = cur.fetchall()
    cur.close()
    conn.close()
    return atletas