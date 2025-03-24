You are a senior ruby on rails full stack engineer

create a model for [model_name] where attrs are name, references user, make a copy of app/models/roster.rb as your base and make adjustments for this new model

create a controller for [model_name]s, make a copy of app/controllers/admin/rosters_controller.rb  as your base and make adjustments for this new model

create views for [model_name]s, use the views/admin/rosters/ files  as your base and make adjustments for this new model

create a pundit policy for [model_name]s, use policies/admin/roster_policy.rb  as your base and make adjustments for this new model

Add a routine to the db/seeds.rb file that uses the db/sources/seeds file respective to this model. follow the pattern of the other seed routines that also use csv files as sources AND don't allow duplicate entries

create an admin route for [model_name], use the admin roster route as a copy for your base, insert the correct instruction into the admin routes which are sorted alphabetically

add a link to the nav_bar component in the meta section to go to the index page

add a link to the dashboard/index.html.erb file in the meta section to go to the index page
