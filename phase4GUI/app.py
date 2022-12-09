from flask import Flask, render_template, redirect, request
from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SubmitField, IntegerField
from wtforms.validators import DataRequired
from flask_sqlalchemy import SQLAlchemy
import mysql.connector

# Create a Flask Instance
app = Flask(__name__)
# Add database
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:Soccer.6678@localhost/restaurant_supply_express'
mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    passwd='Soccer.6678',
    db='restaurant_supply_express'
)

app.config['SECRET_KEY'] = "Socce4rBalls"

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

@app.route('/owner', methods=['GET', 'POST'])
def owner():
    form = addOwnerForm()
    if request.method == "POST":
        user_name = request.form['username']
        f_name = request.form['fname']
        l_name = request.form['lname']
        addy = request.form['address']
        b_date = request.form['bdate']
        db_cursor = mydb.cursor()
        res = db_cursor.callproc('add_owner', [user_name, f_name, l_name, addy, b_date])
        
        try:
            db_cursor.session.add(res)
            db_cursor.commit()
            return redirect('/owner')
        except:
            return render_template('employee.html', form = form)

    else:
        return render_template('owner.html',
            form = form)

class addEmployee(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    fname = StringField("First Name", validators=[DataRequired()])
    lname = StringField("Last Name", validators=[DataRequired()])
    address = StringField("Address", validators=[DataRequired()])
    bdate = DateField("Birth Date", validators=[DataRequired()])
    taxID = StringField("TaxID", validators=[DataRequired()])
    hired = DateField("Date Hired", validators=[DataRequired()])
    experience = IntegerField("Experience", validators=[DataRequired()])
    salary = IntegerField("Salary", validators=[DataRequired()])
    submit = SubmitField("Add")

@app.route('/employee', methods=['GET', 'POST'])
def employee():
    form = addEmployee()
    if request.method == "POST":
        user_name = request.form['username']
        f_name = request.form['fname']
        l_name = request.form['lname']
        addy = request.form['address']
        b_date = request.form['bdate']
        tax_ID = request.form['taxID']
        date_hired = request.form['date_hired']
        experience_ = request.form['experience']
        salary_ = request.form['salary']
        db_cursor = mydb.cursor()
        res = db_cursor.callproc('add_employee', [user_name, f_name, l_name, addy, b_date, tax_ID, date_hired, experience_, salary_])

        try:
            db_cursor.session.add(res)
            db_cursor.commit()
            return redirect('/employee')
        except:
            return render_template('employee.html', form = form)
    else:
        return render_template('employee.html',
            form = form)

@app.route('/view/<type>')
def view_table(type):
    query = 'select * from display_{}_view'.format(type.lower())
    db_cursor = mydb.cursor()
    db_cursor.execute(query)
    view_list = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('view.html', view_list = view_list, type = type)

