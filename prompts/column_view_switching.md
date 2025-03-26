You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective is to allow a user to switch between different columns on the table
* The columns are identified with the link attribute of view: [value] or, for example, view: :stat
* The "base" value is always shown on the table
* The "stats" value is the default when the page loads the first time or when the user clicks on the Stats link in the View menu
* The "scoring" value is shown when the user clicks on the Scoring link in the View menu 
* The "scouting" value is shown when the user clicks on the Scouting link in the View menu
* If a user clicks on a View Link, the sorting of the column headers should not trigger a different view. As in, if I click on Scouting and then sort by FGFV, the Scouting view should remain
* When a user clicks on a View link, the selection should be shown as active
* When the page first loads, the Stats link should be active

## Key objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle the browser interaction

## Relevant models

* Player

## Relevant controllers

* PlayerController and dashboard action

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Example Sort Link

```ruby
<th class="py-1"><%= sort_link([:admin, @q], :hard_hit, "HH%", view: :scouting) %></th>
```

## View Links

```ruby
<!-- Views Filter Navigation -->
<div class="card mb-3">
  <div class="card-body py-2">
    <div class="d-flex align-items-center" data-controller="column-view">
      <div class="filter-title me-3 fw-bold text-secondary" style="min-width: 120px;">Views</div>
      <ul class="nav nav-pills nav-fill flex-grow-1 mb-0">
        <% q_params = params[:q]&.to_unsafe_h || {} %>
        <li class="nav-item">
          <%= link_to "Stats", dashboard_admin_players_path(view: :stats, q: q_params) %>
        </li>
        <li class="nav-item">
          <%= link_to "Scoring", dashboard_admin_players_path(view: :scoring, q: q_params) %>
        </li>
        <li class="nav-item">
          <%= link_to "Scouting", dashboard_admin_players_path(view: :scouting, q: q_params) %>
        </li>
      </ul>
    </div>
  </div>
</div>
```
