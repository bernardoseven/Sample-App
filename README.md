Hello there, i'm making a whatsapp web clone from scratch for learning purpose.
To Start:
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
**********************************
* All the relevant information, comments and tecniques i'm learning about rails can be found
* in application.html.erb, pages_controller_test.rb, 
* Every proccess of programming that involves a bunch o files and logic, will be explained
* here, in this file.
- I need to think the database model and relationships and how this is going
to be done for the most exact copy i can do in the level i'm currently programming.
- Setting up