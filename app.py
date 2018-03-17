import sys

import os
from flask import Flask,redirect, url_for, request, render_template

app = Flask(__name__,static_url_path='')


@app.route('/index/')
def index():
    return render_template('index.html')

@app.route('/success/<name>')
def success(name):
    return 'welcome %s' % name


@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        user = request.form['username']
        pwd = request.form['pass']
        return redirect(url_for('success', name=user))
    else:
        user = request.args.get('username')
        user = request.args.get('pass')


if __name__ == '__main__':
    app.run()
