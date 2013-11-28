#!/usr/bin/python
# -*- coding: utf-8 -*-

from flask import Flask, render_template
import db

app = Flask(__name__)

@app.route('/')
def index():
    dbtopicos = db.get_topicos()
    return render_template('topicos.html', topicos = dbtopicos)
    
@app.route('/t/<int:topicoid>')
def topico(topicoid):
    dbtopico = db.get_topico(topicoid)
    dblivros = db.get_livros_topico(topicoid)
    return render_template('topico.html', topico = dbtopico)

@app.route('/livro/<int:isbn>')
def livro(isbn):
    pass

@app.route('/link/<linkid>')
def link(linkid):
    pass

if __name__ == '__main__':
    app.run(debug=True)
