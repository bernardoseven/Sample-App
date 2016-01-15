THIS PROYECT IS IN DEVELOPMENT

I'm making a whatsapp web clone(at least most of the features) 
from scratch for learning purpose.
Most of the comments and learning comes from the MAGNIFICENT BOOK "Ruby on Rails
Tutorial" by MICHAEL HARTL, Codecademy exercises and a litle from teamtreehouse.
**********************************
LAYOUT:
We can make an integration test to test if the links of the App are working
correctly.
This can be done typying the command: rails generate integration_test nameofyourchoice
This snippet test's the requirements explained above
 test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 "count:2 means that there must be
    to link's to the root_path, for example, one in the logo and one anywhere else"
    assert_select "a[href=?]", link2_path
    assert_select "a[href=?]", link3_path
    assert_select "a[href=?]", link4_path
  end
Then, if we want to check the new test passes, we can run the integration test with
the command: bundle exec rake test:integration

USERS(To improve layout understanding):
rails generate controller Users new, generates a users controller with the new action
(def new end), a new.html.erb view, a users_test controller, etc.
However, we can arrange to asign a different html.erb file than users/new.html.erb to
whatever html.erb we want. For example, the new action, following the REST principle
will be to add a new user, but may we want associate a signup.html.erb url. We can 
accomplish this in the routes.rb file simple by putting
the line: " get 'signup' => 'users#new' ".
**********************************
MODELING-USERS:
rails generate model User name:string email:string, generates a database table with two
string column's, name and email. Additionally creates an user_test.rb and user.rb model
file's, and a migration file THAT IS A WAY TO ALTER THE DATABASE INCREMENTALLY, so that
our data model can adapt to changing requirements
We can run the command: rake db:migrate to finish the proccess detailed above. 
Migrations are reversible, at least most of them, with the simple command:
bundle exec rake db:rollback. In most case's when a developer has used the rollback command,
the migration's file can be migrated again with rake db:migrate.

To write a test for a vaild object, we will create an initially valid User model object
@user, using the special setup method, wich automatically gets run before each test.
Because @user is an instance variable, it's automatically available in all the tests.

The most elementary validation is presence, wich simple verifies that a given 
attribute is present. Our user has name and email, so we are going to verify that both
attribute's are present writting tests.

Validations for format purposes, like that a given email have a valid email format
will be done after.

Regular Expressions Table:
Expression	Meaning
/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	full regex
/	start of regex
\A	match start of a string
[\w+\-.]+	at least one word character, plus, hyphen, or dot
@	literal “at sign”
[a-z\d\-.]+	at least one letter, digit, hyphen, or dot
\.	literal dot
[a-z]+	at least one letter
\z	match end of a string
/	end of regex
i	case-insensitive

Uniqueness Validation:
To enforce uniqueness of email addresses(so that we can use them as usernames),
we will be using the :unique option to the validates method.
Despite all the method's writted to avoid user duplications, at the database level
this could happen still. So we have to add an index to the database to enforce
uniqueness at the database and user model level.
We need to add new structure to the existing users migration, for that purpose,
we need to create a migration directly using the migration generator.
rails generate migration add_index_to_users_email, more steps are in the corresponding file.
After the last step, we only have to migrate the database.

If we run the tests again, them will fail due to the fixtures users.yml file, that 
contains sample data for the test database. At this point we can erase the content of this
file, leaving the comment #empty (tests are now passing).

Some databases doesn't support uppercase emails, so we have to downcase the emails
before save them to the databse. This is done adding the
before_save { self.email = email.downcase } method to the user model.

Secure password:
The only requirement of has_secure_password to work his magic is for the corresponding
model to have an attribute called password_digest.
We can accomplish this with a single command: 
rails generate migration add_password_digest_to_users password_digest:string
After the above line, it is all set to work, we just need to migrate de database.
For all the things mentioned, we need a gem called bcrypt in the gemfile, we install this gem
uncommenting the line where is bcrypt and executing bundle install.
At this point the tests are failing, and the reason is because has_secure_password enforces
validations on the virtual password and password_confirmation attributes.
To get the tests passing again we just need to add a password and its confirmation to
the tests.
**********************************
Sign-up:
In rails we can create a new user into the app with a form called 
form_for, wich takes in an active record object and constructs a form using the 
object's attributes. For this we must create an instance variable in def new method
in user controller.
**********************************
Server:
The server ruby on rails uses, WEBrick, is not good at handling traffic, so for 
production purposes, we need to change the default server for another one pretty
good at handling traffic. We are going to use Puma, an http server.
We need to add a gem to the gemfile called puma, version 2.11.1.
Then, we must run bundle install, after this, we need to create a file in 
the config folder called puma.rb, i put the code in that file neccesary to run puma,
the last step is to create a Procfile in the root directory of the app with some
code too.
**********************************
Sessions:
We are only going to use named routes handling get and post request to log-in and 
log-out.
**********************************
**********************************
**********************************
**********************************
* All the relevant information, comments and tecniques i'm learning about rails can be found
* in application.html.erb, pages_controller_test.rb, 
* Every proccess of programming that involves a bunch o files and logic, will be explained
* here, in this file.
- I need to think the database model and relationships and how this is going
to be done for the most exact copy i can do in the level i'm currently programming.
- Setting up