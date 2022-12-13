from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SubmitField, IntegerField
from wtforms.validators import DataRequired

# add_service_form
class add_service_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_long_name = StringField("Name", validators=[DataRequired()])
    ip_home_base = StringField("Home Base", validators=[DataRequired()])
    ip_manager = StringField("Manager", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_long_name'], form['ip_home_base'], form['ip_manager']]
        return inputs

# add_employee_form
class add_employee_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    ip_first_name = StringField("First Name", validators=[DataRequired()])
    ip_last_name = StringField("Last Name", validators=[DataRequired()])
    ip_address = StringField("Address", validators=[DataRequired()])
    ip_birthdate = DateField("Birth Date", validators=[DataRequired()])
    ip_taxID = StringField("TaxID", validators=[DataRequired()])
    ip_hired = DateField("Date Hired", validators=[DataRequired()])
    ip_employee_experience = IntegerField("Experience", validators=[DataRequired()])
    ip_salary = IntegerField("Salary", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_username'], form['ip_first_name'], form['ip_last_name'], form['ip_address'], form['ip_birthdate'], form['ip_taxID'], form['ip_hired'], form['ip_employee_experience'], form['ip_salary']]
        return inputs

# hire_employee_form
class hire_employee_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    ip_id = StringField("ID", validators=[DataRequired()])
    hireButton = SubmitField("Hire")

    def getInputs(form):
        inputs = [form['ip_username'], form['ip_id']]
        return inputs

# fire_employee_form
class fire_employee_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    ip_id = StringField("ID", validators=[DataRequired()])
    fireButton = SubmitField("Fire")

    def getInputs(form):
        inputs = [form['ip_username'], form['ip_id']]
        return inputs

# add_pilot_role_form
class add_pilot_role_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    ip_licenseID = StringField("LicesnseID", validators=[DataRequired()])
    ip_pilot_experience = IntegerField("Pilot Experience", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_username'], form['ip_licenseID'], form['ip_pilot_experience']]
        return inputs

# remove_pilot_role_form
class remove_pilot_role_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    removeButton = SubmitField("Remove")

    def getInputs(form):
        inputs = [form['ip_username']]
        return inputs

# add_worker_role_form
class add_worker_role_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_username']]
        return inputs

# add_ingredient_form
class add_ingredient_form(FlaskForm):
    ip_barcode = StringField("Barcode", validators=[DataRequired()])
    ip_iname = StringField("Ingredient Name", validators=[DataRequired()])
    ip_weight = IntegerField("Weight", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_barcode'], form['ip_iname'], form['ip_weight']]
        return inputs

# remove_ingredient_form
class remove_ingredient_form(FlaskForm):
    ip_barcode = StringField("Barcode", validators=[DataRequired()])
    removeButton = SubmitField("Remove")

    def getInputs(form):
        inputs = [form['ip_barcode']]
        return inputs

# add_drone_form
class add_drone_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    ip_fuel = IntegerField("Fuel", validators=[DataRequired()])
    ip_capacity = IntegerField("Capacity", validators=[DataRequired()])
    ip_sales = IntegerField("Sales", validators=[DataRequired()])
    ip_flown_by = StringField("Flown By (Pilot Username)", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag'], form['ip_fuel'], form['ip_capacity'], form['ip_sales'], form['ip_flown_by']]
        return inputs

# remove_drone_form
class remove_drone_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    removeButton = SubmitField("Remove")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag']]
        return inputs

# add_restaurant_form
class add_restaurant_form(FlaskForm):
    ip_long_name = StringField("Restaurant Name", validators=[DataRequired()])
    ip_rating = IntegerField("Rating", validators=[DataRequired()])
    ip_spent = IntegerField("Spent", validators=[DataRequired()])
    ip_location = StringField("Location", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_long_name'], form['ip_rating'], form['ip_spent'], form['ip_location']]
        return inputs

# load_drone_form
class load_drone_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    ip_barcode = StringField("Barcode", validators=[DataRequired()])
    ip_more_packages = IntegerField("Number of Packages to Add", validators=[DataRequired()])
    ip_price = IntegerField("Price", validators=[DataRequired()])
    loadButton = SubmitField("Load")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag'], form['ip_barcode'], form['ip_more_packages'], form['ip_price']]
        return inputs

# refuel_drone_form
class refuel_drone_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    ip_more_fuel = IntegerField("Fuel Quantity to Add", validators=[DataRequired()])
    refuelButton = SubmitField("Refuel")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag'], form['ip_more_fuel']]
        return inputs

# takeover_drone_form
class takeover_drone_form(FlaskForm):
    ip_username = StringField("Pilot Username", validators=[DataRequired()])
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    takeoverButton = SubmitField("Takeover Drone")

    def getInputs(form):
        inputs = [form['ip_username'], form['ip_id'], form['ip_tag']]
        return inputs

# fly_drone_form
class fly_drone_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    ip_destination = StringField("Destination", validators=[DataRequired()])
    flyButton = SubmitField("Fly")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag'], form['ip_destination']]
        return inputs

# join_swarm_form
class join_swarm_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    ip_swarm_leader_tag = IntegerField("Swarm Leader Tag", validators=[DataRequired()])
    joinButton = SubmitField("Join")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag'], form['ip_swarm_leader_tag']]
        return inputs

# leave_swarm_form
class leave_swarm_form(FlaskForm):
    ip_id = StringField("ID", validators=[DataRequired()])
    ip_tag = IntegerField("Tag", validators=[DataRequired()])
    leaveButton = SubmitField("Leave")

    def getInputs(form):
        inputs = [form['ip_id'], form['ip_tag']]
        return inputs

# add_owner_form
class add_owner_form(FlaskForm):
    ip_username = StringField("Username", validators=[DataRequired()])
    ip_first_name = StringField("First Name", validators=[DataRequired()])
    ip_last_name = StringField("Last Name", validators=[DataRequired()])
    ip_address = StringField("Address", validators=[DataRequired()])
    ip_birthdate = DateField("Birthdate", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        inputs = [form['ip_username'], form['ip_first_name'], form['ip_last_name'], form['ip_address'], form['ip_birthdate']]
        return inputs

# start_funding_form
class start_funding_form(FlaskForm):
    ip_owner = StringField("Owner Username", validators=[DataRequired()])
    ip_long_name = StringField("Restaurant Name", validators=[DataRequired()])
    fundButton = SubmitField("Fund")

    def getInputs(form):
        inputs = [form['ip_owner'], form['ip_long_name']]
        return inputs

# add_location_form
class add_location_form(FlaskForm):
    ip_label = StringField("Location Name", validators=[DataRequired()])
    ip_x_coord = IntegerField("X-Coordinate", validators=[DataRequired()])
    ip_y_coord = IntegerField("Y-Coordinate", validators=[DataRequired()])
    ip_space = IntegerField("Space", validators=[DataRequired()])
    addButton = SubmitField("Add")

    def getInputs(form):
        return [form['ip_label'], form['ip_x_coord'], form['ip_y_coord'], form['ip_space']]

# manage_service_form
class manage_service_form(FlaskForm):
    ip_username = StringField("Employee Username", validators=[DataRequired()])
    ip_id = StringField("Service ID", validators=[DataRequired()])
    manageButton = SubmitField("Manage")

    def getInputs(form):
        return [form['ip_username'], form['ip_id']]

# purchase_ingredient_form
class purchase_ingredient_form(FlaskForm):
    ip_long_name = StringField("Restaurant Name", validators=[DataRequired()])
    ip_id = StringField("Drone ID", validators=[DataRequired()])
    ip_tag = IntegerField("Drone Tag", validators=[DataRequired()])
    ip_barcode = StringField("Ingredient Barcode", validators=[DataRequired()])
    ip_quantity = IntegerField("Quantity to Purchase", validators=[DataRequired()])
    purcahseButton = SubmitField("Purhcase")

    def getInputs(form):
        return [form['ip_long_name'], form['ip_id'], form['ip_tag'], form['ip_barcode'], form['ip_quantity']]
        