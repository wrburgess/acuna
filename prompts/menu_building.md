You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this project is to allow a user to select any number of player types, levels, statuses, positions, tracking lists, timelines, and views options to filter down further on the results table.
* A use can only choose one of each filter type at a time. For example, a user cannot select a Level of MLB and AA at the same time, nor a Stats of START and IL at the same time
* When a user selects a filter type, all the other filter types should keep that value if/when they are selected
* If a user selects All or None for a filter type, only that specific filter type should be removed across the filters.

## Filter Behavior

* Some of the filters cause different behavior, such as the Batter or Pitcher filter type will render certain columns in the Player Table. See lines 46 and 51 in the app/views/admin/players/dashboard.html.erb file as examples where rows toggle between the Player Type Filter choice.
* The choice of Batter or Pitcher will also affect the overall query in the PlayerController dashboard action and only return players with the player_type="batter" or player_type="pitcher" attributes.
* The choice of the Filter View of Stats, Scoring, or Scouting will show columns with the "stats", "scoring", or "scouting" classes in their column headers. Columns with "base" class will render, regardless.
* The sorting links should maintain all of the filter choices from above. Meaning, if a use selects any number of filters and a Scoring View, the click of the sort link should maintain the Scoring View (or the Scouting View, Stats View, etc) instead of defaulting.
* The Stats view is the default view if no other view is chosen.
* The Last Name filter, where the field is  

## Key objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle the browser interaction
* I don't even know if you need javascript and stimulus for this solution, so do something easier if warranted. No need to make things complex unless needed.

## Relevant models

* Player

## Relevant controllers

* PlayerController and the dashboard action

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Relevant section

* Levels links
* Status links
