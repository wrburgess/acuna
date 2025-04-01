You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this feature is to allow a user to select a player type to filter down further on the results table.

## Filter Behavior

* The choice of Batter or Pitcher should affect the overall query in the PlayerController dashboard action and only return players with the player_type="batter" or player_type="pitcher" attributes. Use ransack for that particular query feature.
* The choice of the Batter or Pitcher should affect which columns are rendered in the Admin::TableForIndex::Component. Look at lines 46 and 51 for examples of which columns should be rendered based on the player_type choice

## Key objectives

* Use Stimulus.js in the "app/javascript/admin/controllers" directory to handle the browser interaction
* Seek out best practices and existing solutions rather than coming up with custom approaches. However, it's more important to work within the Stimulus.js framework than anything else.

## Relevant models

* Player

## Relevant controllers

* PlayersController and the "dashboard" action

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Relevant sections

* Player Type filter links
* Player Table
* Player Table Pager
