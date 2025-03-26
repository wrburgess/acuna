You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective is to allow a user to type in a first and/or last name of a player and reach the player's profile page
* After the user types in at least two characters, there should be an autocomplete showing a list of 15 players first sorted by last_name first
* Player name should be formatted like "Anthony, Roman (RF, CF) BOS / WRI" for a player that is on a fantasy roster
* Player name should be formatted like "Smith, Cam (RF, 3B) HOU / FA" for a player that is a Free Agent
* The data structure of this will be [last_name], [first_name] ([eligible_positions]) [team_name] / [roster_name]
* When a user clicks on the player name in the dropdown, it should redirect the user to the player's profile page, which is at profile_admin_player_path(player)
* the search field should come before the buttons on the header, so between the page title and the buttons, so to speak.
* The header_for_index should only show this component if the header_for_index is called with a search_box: true argument

## Key objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle the browser interaction
* If bootstrap has a built-in feature for autocomplete, let's lean on that pre-built approach (or parts of it)

## Relevant models

* Player

## Relevant controllers

* PlayerController and profile action

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Relevant component

* app/components/admin/header_for_index
