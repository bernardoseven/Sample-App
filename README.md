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
Unlike user form, sessions does not have a model, so we need to pass more information
to the sessions form to give rails the ability to infer that the action of the
form should be post.
Rails has a session method and does not has a controller sessions. The code is
session[:user_id] = user.id, this method creates a temporary cookie that expires 
when the browser is closed by the user.
If we want to use this method in more than a place, we have to create a method in
the sessions helper.
note: temporary sessions are not vulnerable to any attack, but permanent cookies
are vulnerable to a session hijacking attack(we must limit the info in that case).
note: if we want to use bootstrap ability to make dropdown menus, we have to include
bootstrap in the rails asset pipeline application.js, with the code: //= require bootstrap
Login after signup:
We need to add the ability to login a user inmediately after signing up, because other 
wise would be strange. This is accomplish with a single line of code in users controller.
**********************************
Persistent Sessions:
We can make persistents sessions by putting a cookie in the browser. To start,
we will add a remember_digest to the user model, that will be a hashed string that we'll
use to compare the cookie with our record in the database.
the code is: rails generate migration add_remember_digest_to_users remember_digest:string
As allways we need to run db:migrate
The plan is to make a rember_digest attribute in the db, with the migration this is 
already solve, but for the cookie, we need to make a method "user.remember_token" that
will be in the cookie and not in the db.
An example of a persistent session(lasting 20 years) using a cookie would be:
cookies[:remember_token] = {value: remember_token, expires: 20.years.from_now.utc}. This
pattern is so common that Rails has a special permament method:
cookies.permanent[:remember_token] = remember_token
To store the user's id in the cookie, we could follow the pattern used with the session
method using something like cookies[:user_id] = user.id, but this is insecure because 
places the id as plain text. To avoid this problem, we'll use a signed cookie, wich securely
encrypts the cookie before placing it on the browser like below:
cookies.signed[:user_id] = user.id
because we want the user id to be paired with the permanent remember token, we should
make it permament as well, this can be done chaining the signed and permanent methods:
cookies.permanent.signed[:user_id] = user.id
After the cookies are set, we can retrieve the user in subsequent page views with code like:
User.find_by(id: cookies.signed[:user_id]) where cookies.signed[:user_id] automatically
decrypts the user id cookie. We can then use bcrypt to verify that cookies[:remember_token]
matches the remember_digest already generated.
There are some details to watch.
**********************************
Requiring logged-in users:
This is done with a before filter that use a before_action command.
To redirect users trying to edit other user profile page, we have to define another
method in users controller, and then used it with a before filter method like the one
above.
To friendly take a user where him want to go, for example, he wants to edit his profile
page and is not logged_in, we can make methods to store where he wants to go and take
him to that place. This is done in the sessions helper.
**********************************
Admin-Attribute:
Must add default: false in the migration file for this purpose.
**********************************
AccountActivation:
We need to add three more columns to the users table, activation_digest, activated,
activated_at.
**********************************
Mailer Method:
We can generate mailer just like a controller, and once a mailer is created, rails
generates two templates views, a plain text view and a html view.
To see the results of the templates defined in Listing 10.12 and Listing 10.13,
we can use email previews, which are special URLs exposed by Rails to let us see 
what our email messages look like. First, we need to add some configuration to
our application’s development environment, as shown in Listing 10.14.

**********************************
**********************************
* All the relevant information, comments and tecniques i'm learning about rails can be found
* in application.html.erb, pages_controller_test.rb, 
* Every proccess of programming that involves a bunch o files and logic, will be explained
* here, in this file.
- I need to think the database model and relationships and how this is going
to be done for the most exact copy i can do in the level i'm currently programming.
- Setting up