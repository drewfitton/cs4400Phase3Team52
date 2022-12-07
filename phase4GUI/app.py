from flask import Flask, render_template
from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SubmitField
from wtforms.validators import DataRequired
from flask_sqlalchemy import SQLAlchemy
import mysql.connector

# Create a Flask Instance
app = Flask(__name__)
# Add database
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:mC36W2!mC36W2!@localhost/restaurant_supply_express'
mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    passwd='mC36W2!mC36W2!',
    db='restaurant_supply_express'
)

def dictfetchall(cursor):
    "Return all rows from a cursor as a dict"
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]

# Create a route decorator
@app.route('/')

# def index():
#     return "<h1>Hello World!</h1>"

def index():
    return render_template("index.html")

# localhost:5000/user/alek as an example
@app.route('/user/<name>')

def user(name):
    return "<h1>Hello {}</h1>".format(name)

class addOwnerForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    fname = StringField("First Name", validators=[DataRequired()])
    lname = StringField("Last Name", validators=[DataRequired()])
    address = StringField("Address", validators=[DataRequired()])
    bdate = DateField("Birth Date", validators=[DataRequired()])
    addButton = SubmitField("Add")

@app.route('/owner')
def owner():
    form = addOwnerForm
    return render_template('owner.html', form = form)

@app.route('/view/<type>')
def view_table(type):
    query = 'select * from display_{}_view'.format(type.lower())
    db_cursor = mydb.cursor()
    db_cursor.execute(query)
    view_list = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('view.html', view_list = view_list, type = type)

