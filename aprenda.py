#!/usr/bin/python
# -*- coding: utf-8 -*-

from flask import Flask, render_template, request, session, redirect, \
                  url_for, g, flash, jsonify
from datetime import datetime
import re
import db
import hashlib
import urllib2

app = Flask(__name__)
app.secret_key = \
    '\xdb\xa5{\xa1\xa6\x7f\xe6\x9c\xc6\xa0\x8e=]\x9a\x0c\x97 >\xaf\xe9\xa9\tyk'

# Helpers -----------------

def entre(menor, maior, string):
    return len(string) >= menor and len(string) <= maior

def check_password_hash(senhaform, senhabd):
    m = hashlib.md5()
    m.update(senhaform)
    senhaform = m.hexdigest()
    return senhaform == senhabd

@app.before_request
def before_request():
    g.usuario = None
    if 'nomeusuario' in session:
        g.usuario = db.get_usuario(session['nomeusuario'])

# Aprenda REST ------------

@app.route('/_proc_usuario')
def procurar_usuario():
    usuario = db.validar_usuario(request.args.get('nomeusuario', ''),
                                 request.args.get('email', ''))
    return jsonify(usuario)

# External REST APIs ------

def get_livro_info(isbn):
    url = "https://www.googleapis.com/books/v1/volumes?q=isbn:%s" \
    % isbn
    livro = {}
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
                if 'description' in data['items'][0]['volumeInfo']:
                    livro['desc'] = data['items'][0]['volumeInfo']['description']
                return jsonify(usuario)
        except ValueError:
            livro['titulo'] = livro['isbn']
    except urllib2.URLError:
        livro['titulo'] = livro['isbn']
    return livro

# Pages -------------------

@app.route('/')
def index():
    dbtopicos = db.get_topicos()
    return render_template('topicos.html', topicos = dbtopicos)

@app.route('/t/<int:topicoid>')
def topico(topicoid):
    dbtopico = db.get_topico(topicoid)
    return render_template('topico.html', topico = dbtopico)


@app.route('/adicionartopico', methods=['GET', 'POST'])
def addtopico():
    if not g.usuario:
        return redirect(url_for('logreg'))
    erros = []
    addinfo = {}
    if request.method == 'POST':
        if request.form['btn'] == 'addtopico':
            titulo = request.form['titulo']
            if titulo == None:
                erros.append(u"Titulo inválido")
            elif not re.match("^[a-zA-Z0-9 ]+$", titulo):
                erros.append(u"Título inválido (use apenas caracteres, espaços \
                        e números)")
                addinfo['titulo'] = titulo

            if not erros:
                db.adicionar_topico(titulo)
                return redirect(url_for('index'))

    return render_template('addtopico.html', erros=erros, addinfo=addinfo)

@app.route('/adicionarsubtopicos/<int:topicoid>', methods=['GET', 'POST'])
def addsubtopicos(topicoid):
    if not g.usuario:
        return redirect(url_for('logreg'))
    erros = []
    dbtopico = db.get_topico(topicoid)
    dbtopicos = db.get_topicos()
    if request.method == 'POST':
        if request.form['btn'] == 'addsubtopicos':
            topicoid = request.form['topicoid']
            subtopicos = request.form.getlist('subtopicos')

            if not subtopicos:
                erros.append(u"Selecione pelo menos um subtópico")
            if not erros:
                db.adicionar_subtopicos(topicoid, subtopicos)
                return redirect(url_for('index'))

    return render_template('addsubtopicos.html', erros=erros,
            otopico = dbtopico, topicos = dbtopicos)

@app.route('/adicionarsupertopicos/<int:topicoid>', methods=['GET', 'POST'])
def addsupertopicos(topicoid):
    if not g.usuario:
        return redirect(url_for('logreg'))
    erros = []
    dbtopico = db.get_topico(topicoid)
    dbtopicos = db.get_topicos()
    if request.method == 'POST':
        if request.form['btn'] == 'addsupertopicos':
            topicoid = request.form['topicoid']
            supertopicos = request.form.getlist('supertopicos')

            if not supertopicos:
                erros.append(u"Selecione pelo menos um supertópico")
            if not erros:
                db.adicionar_supertopicos(topicoid, supertopicos)
                return redirect(url_for('index'))

    return render_template('addsupertopicos.html', erros=erros,
            otopico = dbtopico, topicos = dbtopicos)

@app.route('/logreg', methods=['GET', 'POST'])
def logreg():
    if g.usuario:
        return redirect(url_for('index'))
    erros = []
    loginfo = {}
    if request.method == 'POST':
        if request.form['btn'] == 'reg':
            nomeusuario = request.form['nomeusuario']
            email = request.form['email']
            senha = request.form['password']
            nasc = request.form['nasc']
            sexo = request.form['sexoradio']

            valido = db.validar_usuario(request.form['nomeusuario'],
                    request.form['email'])

            # Validando nome de usuário ----
            if not valido['nomeusuario'] or \
               not entre(2, 20, nomeusuario):
                erros.append(u"Nome de usuário inválido")
            elif not re.match("^[a-zA-Z0-9_]+$", nomeusuario):
                erros.append(u"Nome de usuário inválido (use apenas \
                        caracteres, números e underlines)")

            # Validando email --------------
            if not valido['email'] or not entre(3, 1024, email):
                erros.append(u"Email inválido")

            # Validando senha --------------
            if len(senha) <= 4:
                erros.append(u"Senha inválida (use pelo menos 4 caracteres")
            else:
                m = hashlib.md5()
                m.update(senha)
                senha = m.hexdigest()

            # Validando data ---------------
            try:
                nasc = datetime.strptime(nasc, '%d/%m/%Y')
            except ValueError:
                erros.append(u"Data inválida (use DD/MM/AAAA)")

            nasc = nasc.strftime('%Y-%m-%d')

            # Validando sexo ---------------
            if(sexo == '/'):
                erros.append(u"Sexo não informado")
            else:
                if(sexo == 'masc'):     sexo = 'M'
                elif(sexo == 'fem'):    sexo = 'F'
                elif(sexo == 'na'):     sexo = 'N'

            if not erros:
                db.registrar_usuario(nomeusuario, email, senha, nasc, sexo)

        elif request.form['btn'] == 'log':
            nomeusuario = request.form['nomeusuario']
            senha = request.form['password']

            usuario = db.get_usuario(nomeusuario)
            if usuario == None:
                erros.append(u"Usuário inválido")
            elif not check_password_hash(senha, usuario['senha']):
                erros.append(u"Senha incorreta")
                loginfo['nomeusuario'] = nomeusuario
            else:
                session['nomeusuario'] = usuario['nome_usuario']
                return redirect(url_for('index'))
    return render_template('logreg.html', erros=erros, loginfo=loginfo)

@app.route('/logout')
def logout():
    flash('Você foi deslogado')
    session.pop('nomeusuario', None)
    return redirect(url_for('index'))

# Run ---------------------

if __name__ == '__main__':
    app.run(debug=True)
