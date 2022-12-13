Group 52 Phase 4 GUI

--Setup Instruction
To setup our application, the device must have python3 installed.
Also, you will need some text editor to change some parameters in the app.py file before running the application.
In the app.py file, line 12 contains an app.config that will allow a database connection. Be sure to edit this to
change for you mySQL database. The format of this line is as follows, inserting your appropriate values where needed:

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://USERNAME:PASSWORD@HOST/DATABASE_NAME'

Then, below line 12, we create a db (Database) variable so that we can connect to it to make changes to our database
using called procedures. There, change the host, user, password, and db variables to match the values in the lin 12
app.config. Then, your database is set up and you should be able to run our application.

--Instructions to Run the Application
First, open some sort of command terminal and navigate to the code folder on your device. We have named it Phase4GUI
but you may have saved it as something else on your device. Then, once in the folder in some terminal, we need to activate
the Python virtual environment that we created for this application. The command varies from device to device but the
important thing here is that we named our virtual environment "virt". The next command in your terminal should be:

source virt/scripts/activate

As aforementioned, each device may have a different command for this so do not hestitate to find it on Google and replace
whatever virtual environment name they provide with virt. Then, once the virtual environment is activated, it will install
all of the necessary libraries. To run our application, you can choose either of the following commands:

flask run
flask --debug run

The first command runs it without the debugging and the second does. We highly recommend using the debugger since it can
help when errors arise. Running either of these commands should return to you a url. Copy this url into a search engine
of your choice and you should have a fully functional applicaiton for restaurant_supply_express. When finished using the
application, hit ctrl+C in your terminal to terminate the process. That will kill the application. Then, you can type
deactivate to deactivate the python virtual environment.

--Technologies Used
The primary technologies used to create this application were Python, Flask, Jinja2 and Bootstrap. We used Python to
create a virtual environment which allowed us to download Flask and Jinja2. We used Bootstrap for the CSS styling and
for some of the various buttons and inputs fields found throughout the application. We followed a series of videos on
YouTube to help us better understand Flask and how it worked. This series introduced us to these techologies which we
then used to create our application for Phase 4. 

--Distribution of Work
There was a very even distribution of work for this phase of the project. Alek mainly worked on setup for the application
and on the structural organization of the application. Andrew worked on creating forms for the website and connecting
those forms to the database on mySQL with GET and POST requests. Once the forms were created, Alek worked on displaying
the various views and tables for each page seen and ensuring each page was functional, fixing any errors along the way.