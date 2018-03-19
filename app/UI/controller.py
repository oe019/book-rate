#!/usr/bin/python
from app.dataService.service import insert;
from app.UI.dto import userDTO

from flask import Flask,redirect, url_for, request, render_template

app = Flask(__name__,static_url_path='')

@app.route('/')
@app.route('/index/')
def index():
    return render_template('index.html')
    return 'hello world'

@app.route('/success/<name>')
def success(name):
    insert(userdto=userDTO())
    return 'welcome %s' % name


@app.route('/login/', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        email = request.form['emailuser']
        passwd = request.form['passuser']
        return redirect(url_for('success', name='hello'))
    else:
        user = request.args.get('username')
        user = request.args.get('pass')


@app.route('/signup/',methods=['POST'])
def signup():
    if request.method == 'POST':
        print('ajax post geldi')
        dto = userDTO();
        dto.firstname = request.form['_firstname']
        dto.lastname = request.form['_lastname']
        dto.gender = request.form['_gender']
        dto.username = request.form['_username']
        dto.email = request.form['_email']
        dto.password = request.form['_password']
        confirm = request.form['password_confirmation']
        dto.birthdate = request.form['_bithdate']
        if confirm != dto.password:
            raise ValueError('Passwords do not match')
            return "<h1>ERROR PASS DONOT MATCH<\h1>"



        print(dto.birthdate)
        print('asd')

if __name__ == '__main__':
    app.run()
