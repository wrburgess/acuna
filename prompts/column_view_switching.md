You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective is to allow a user to switch between viewing different columns on the table
* The "base" value is always shown on the table
* The "stats" value is the default when the page loads the first time or when the user clicks on the Stats link in the View menu
* The "scoring" value is shown when the user clicks on the Scoring link in the View menu 
* The "scouting" value is shown when the user clicks on the Scouting link in the View menu
* If a user clicks on a View Link, the sorting of the column headers should not trigger a different view. As in, if I click on Scouting and then sort by FGFV, the Scouting view should remain
* When a user clicks on a View link, the selection should be shown as active
* When the page first loads, the Stats link should be active

## Views Types of the columns

base: Track, Player, ROS, LEVEL, STATUS, AGE, TIME
scoring: OPS, QS
stats: H, INN
scouting: BCTL, CNTL

## Key objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle the browser interaction

## Relevant models

* Player

## Relevant controllers

* PlayerController and dashboard action

## Relevant pages

* app/views/admin/players/dashboard.html.erb
