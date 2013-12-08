Aprenda
=======

An educational link/video/book aggregator for a databases course. Made using
Flask and PostgreSQL (with psycopg2). No
[ORM](https://en.wikipedia.org/wiki/Object-relational_mapping) was used, which
would defeat the purpose of the project. As of now, most of the code is in
Portuguese.

Installation
------------

This assumes you have Python 2.7.x and pip installed.

### Mac OS X
Tested on Mac OS X 10.9 using [homebrew](http://brew.sh/)

Clone the repository

    $ git clone https://github.com/CFelipe/Aprenda.git
    $ brew install postgresql
    $ createdb aprenda
    $ # cd to the directory in which you cloned the repository
    $ psql aprenda
    $ \i aprenda.sql
    $ \q

Creating a virtualenv is optional. You can skip this if you want to.

    $ virtualenv env
    $ . env/bin/activate

Install the dependencies and run

    $ pip install -r requirements.txt
    $ python aprenda.py
