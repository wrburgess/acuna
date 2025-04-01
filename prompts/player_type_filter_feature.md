You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this feature is to allow a user to search for a player based on last name to filter down further on the results table.

## Include The Files For Context

* app/views/admin/players/dashboard.html.erb
* app/javascript/admin/controllers/
* app/views/admin/players/_filter_context.html.erb
* app/controllers/players_controller.rb
* app/models/player.rb

## Filter Target Behavior

* The last name field is located in the dashboard.html.erb Player Type filter row
* After a user types a name or partial of a name, the ransack filter should add to the existing search based on last_name_cont 

## Key objectives

* Use Stimulus.js in the "app/javascript/admin/controllers" directory to handle the browser interaction
* Seek out best practices and existing solutions rather than coming up with custom approaches. However, it's more important to work within the Stimulus.js framework than anything else.

## Relevant Sections on Dashboard

* Player Type Filter row
* Last Name Filter form
* Player Table
* Player Table Pager
