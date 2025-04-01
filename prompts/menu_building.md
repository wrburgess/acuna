You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

## Project Objectives

* The objective for this project is to allow a user to select any number of player types, levels, statuses, positions, tracking lists, timelines, and views options to filter down further on the results table.
* A use can only choose one of each filter type at a time. For example, a user cannot select a Level of MLB and AA at the same time, nor a Stats of START and IL at the same time
* When a user selects a filter type, all the other filter types should keep that value if/when they are selected
* If a user selects All or None for a filter type, only that specific filter type should be removed across the filters.
* Make sure you take your time to complete all 7 of the filter behaviors. Feel free to take extra time to check your work, ensure you're covering the features, and not leaving things out.

## Technical Objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle the browser interaction
* Follow the existing patterns for registering stimulus controllers
* Seek out best practices and existing solutions rather than coming up with custom approaches. However, it's more important to work within the Rails and Stimulus.js frameworks than anything else.
* The ransack-based query in the PlayersController dashboard action is a key piece of the functionality of this view. Make sure we are using the most efficient ActiveRecord and SQL querys possible.

## Filter Behavior

1. Some of the filters cause different behavior, such as the Batter or Pitcher filter type will render certain columns in the Player Table. See lines 46 and 51 in the app/views/admin/players/dashboard.html.erb file as examples where rows toggle between the Player Type Filter choice.
2. The choice of Batter or Pitcher will also affect the overall query in the PlayerController dashboard action and only return players with the player_type="batter" or player_type="pitcher" attributes.
3. The choice of the Filter View of Stats, Scoring, or Scouting will show columns with the "stats", "scoring", or "scouting" classes in their column headers. Columns with "base" class will render, regardless.
4. The sorting links should maintain all of the filter choices from above. Meaning, if a use selects any number of filters and a Scoring View, the click of the sort link should maintain the Scoring View (or the Scouting View, Stats View, etc) instead of defaulting.
5. The Stats view is the default view if no other view is chosen.
6. The Last Name filter, where the field is housed in the Player Type filter row, should filter the player by last name for whatever characters are typed in. All other filters should be maintained along with the characters submitted. If no characters are submitted, then all players are part of the query. 
7. The player table pager (using the Pagy gem) should maintain all filter choices, as well.

## Relevant models

* Player

## Relevant controllers

* PlayerController and the dashboard action

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Relevant sections on dashboard view

* Player Type links
* Player Last Name field
* Levels links
* Status links
* Player Position links
* Tracking List links
* Timeline links
* Table View links
* Player Table
* Player Table Pager
