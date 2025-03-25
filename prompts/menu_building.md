You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this project is to allow a user to select a level and status option to filter down further on the results table.
* When a user selects a Level option, such as AAA, the active status should "stick" when the page reloads.
* When a user then selects a Status option, such as START, the active status should stick on START when the page reloads. The previous Level option selected, in this case, AAA, should remain as active.
* If the user goes back to Level and selects All, the ransack filter should reset for Level, but remain for Status.

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
