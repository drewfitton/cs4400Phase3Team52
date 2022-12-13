from flask import Flask, render_template, redirect, request
from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SubmitField, IntegerField
from wtforms.validators import DataRequired
from flask_sqlalchemy import SQLAlchemy
import mysql.connector
import forms

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

app.config['SECRET_KEY'] = "Socce4rBalls"
app.last_page = '/'

def dictfetchall(cursor):
    "Return all rows from a cursor as a dict"
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]

# Create a route decorator
@app.route('/')
def index():
    return render_template("index.html")

# Services Tab. Contains Four Procedures
@app.route('/services', methods=['GET', 'POST'])
def services():
    app.last_page = '/services'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from delivery_services')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('services.html', table = table)

# Employees Tab. Contains Three Procedures
@app.route('/employees', methods=['GET', 'POST'])
def employees():
    app.last_page = '/employees'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from employees')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('employees.html', table=table)

# Drones Tab. Contains 5 Procedures
@app.route('/drones', methods=['GET', 'POST'])
def drones():
    app.last_page = '/drones'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from drones')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('drones.html', table = table)

# Workers Tab. Contains 2 Procedures
@app.route('/workers', methods=['GET', 'POST'])
def workers():
    app.last_page = '/workers'
    db_cursor = mydb.cursor()
    db_cursor.execute('select w.username, wf.id, ds.long_name, if(ds.manager is not null, \'yes\', \'no\') as Manager from workers as w left join work_for as wf on w.username = wf.username left join delivery_services as ds on w.username = ds.manager;')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('workers.html', table=table)

# Pilots Tab. Contains 4 Procedures
@app.route('/pilots', methods=['GET', 'POST'])
def pilots():
    app.last_page = '/pilots'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from pilots')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('pilots.html', table=table)

# Owners Tab. Contains 2 Procedures
@app.route('/owners', methods=['GET', 'POST'])
def owners():
    app.last_page = '/owners'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from restaurant_owners')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('owners.html', table=table)

# Managers Tab. Contains 2 Procedures
@app.route('/managers', methods=['GET', 'POST'])
def managers():
    app.last_page = '/managers'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from display_employee_view where Manager=\'yes\'')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('managers.html', table=table)

# Restaurants Tab. Contains 1 Procedure
@app.route('/restaurants', methods=['GET', 'POST'])
def restaurants():
    app.last_page = '/restaurants'
    db_cursor = mydb.cursor()
    db_cursor.execute('select * from restaurants')
    table = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('restaurants.html', table=table)

@app.route('/view/<type>')
def view_table(type):
    query = 'select * from display_{}_view'.format(type.lower())
    db_cursor = mydb.cursor()
    db_cursor.execute(query)
    view_list = dictfetchall(db_cursor)
    db_cursor.close()
    return render_template('view.html', view_list = view_list, type = type)

@app.route('/form/<proc>', methods=['POST', 'GET'])
def display_proc_form(proc):
    procWords = proc.split('_')
    procTitle = ''
    for w in procWords:
        procTitle = procTitle + w.title() + ' '
    formName = proc + '_form'
    form = getattr(forms, formName)()
    if request.method == 'POST':
        inputs = getattr(forms, formName).getInputs(request.form)
        db_cursor = mydb.cursor()
        db_cursor.callproc(proc, inputs)
        mydb.commit()
        db_cursor.close()
        return redirect(app.last_page)
        try:
            db_cursor.callproc(proc, inputs)
            mydb.commit()
            db_cursor.close()
            return redirect(last_page)
        except:
            return "Error with " + str(proc) + " procedure modifying database."
    return render_template('form.html', form = form, procTitle = procTitle)
