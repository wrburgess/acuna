You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this feature is to allow a user to search for a player based on the associated Position to filter down further on the player results table.

## Include The Files For Context

* app/views/admin/players/dashboard.html.erb
* app/javascript/admin/controllers/
* app/views/admin/players/_filter_positions.html.erb
* app/controllers/admin/players_controller.rb
* app/models/player.rb
* app/models/position.rb
* app/prompts/player_position_filter_feature.md

## Filter Target Behavior

* Note: This filter works similar to the Level and Status filters
* When a user clicks on a position link, such as C, 1B, IF, the player table records should filter based on the ransack argument
* When a user clicks on a position link, it should keep the context of other searches, like Player Type, Player Last Name, Level, and Status
* When a user clicks on a positions All option, it should remove the position argument from the filtering, but **retain the other filters in place*, such as Player Type and Player Last Name
* Down the road, we will be adding other filters, like Status, Position, and Lists. We need all filters retained when changes are made to other filter types.
* When a user selects a Batter, only batter positions should render on that filter row. The Position instances each have an attribute named position_type that equals "batter" or "pitcher"
* For instance, when a Pitcher Player Type is selected, only SP, RP, P will render.

## Key objectives

* Use Stimulus.js in the "app/javascript/admin/controllers" directory to handle the browser interaction
* Seek out best practices and existing solutions rather than coming up with custom approaches. However, it's more important to work within the Stimulus.js framework than anything else.
* Use the existing code and file structure if/when already present

## Relevant Sections on Dashboard

* Position Filter row
* Player Table
* Player Table Pager
