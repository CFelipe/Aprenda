 #!/usr/bin/python
# -*- coding: utf-8 -*-

from flask import Flask, render_template
import psycopg2
import db

app = Flask(__name__)

@app.route('/')
def index():
    dbatletas = db.get_atletas()
    print dbatletas
    return render_template('layout.html', atletas=dbatletas)

if __name__ == '__main__':
    app.run(debug=True)