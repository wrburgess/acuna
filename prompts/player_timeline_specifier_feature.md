You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this feature is to allow a user to search for a player based on the associated filters and to see stat and scouting profile data associated with the requested timeline.
* There is some existing code for this feature but it is not currently working, which is why you are taking over this feature
* feel free to completely refactor the javascript controller and filter partial if necessary

## Include The Files For Context

* app/views/admin/players/dashboard.html.erb
* app/javascript/admin/controllers/
* app/views/admin/players/_filter_timelines.html.erb
* app/controllers/admin/players_controller.rb
* app/models/player.rb
* app/models/position.rb
* app/prompts/player_timeline_specifier_feature.md

## Timeline Specifier Behavior

* Note: This selector works differently than the Level and Status filters in that it does not filter the player table, but instead joins the stat and scoutingprofile data in the playerscontroller dashboard action query
* When a user clicks on a timeline link, it should keep the context of other searches, like Player Type, Player Last Name, Level, and Status, but this selection does not filter the table. Instead, it changes the associated Stats and Scoring Profile data.
* The timeline is an associated model for the Stat and ScoutingProfile models which are associated with the Player model
* Each player should have a Stat line and ScoutingProfile line associated with one or more Timelines
* When a user selects a timeline, such as YTD (the default), 7D, etc, the joins in the controller action (dashboard) will return only the Player + Stat + ScoutingProfile associated with that timeline
* No actual changes to the filters should occur (Level, Status, etc)
* The default timeline setting should be YTD if no other selection is made
* If the YTD is selected, the timeline_id argument should be removed from the query, but no other filter choices changed.
* The default timeline record is "YTD" and should only show up once (at the beginning) of the timeline links. The value on the instance will be instance.default = true
* When a user clicks on a timeline option, the class should be active. Otherwise, the default link should be active.

## Key objectives

* Use Stimulus.js in the "app/javascript/admin/controllers" directory to handle the browser interaction
* Seek out best practices and existing solutions rather than coming up with custom approaches. However, it's more important to work within the Stimulus.js framework than anything else.
* Use the existing code and file structure if/when already present

## Relevant Sections on Dashboard

* Timeline Specifier row
* Player Table
* Player Table Pager
