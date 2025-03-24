You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective for this project is to allow a user to see the status of being added to a tracking list or not
* Allowing a user to click on an icon button to add or remove a player without refreshing the page

## Key objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle the browser interaction

## Relevant models

* Player
* TrackingListPlayer
* TrackingList

## Relevant controllers

* TrackingListPlayersController or TrackingListsController? You decide?
* It seems like a new TrackingListPlayersController might be the easiest with create and delete actions

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Relevant section

* TRX column in the front of each Player row.

```ruby
<td class="py-1" data-column-view-category="base">
  <% current_user.tracking_lists.each do |tracking_list| %>
    <button type="button" class="btn btn-sm p-0" data-bs-toggle="tooltip" title="<%= instance.aggregated_tracking_list_ids.include?(tracking_list.id) ? "Remove from #{tracking_list.name}" : "Add to #{tracking_list.name}" %>">
      <i class="<%= instance.aggregated_tracking_list_ids.include?(tracking_list.id) ? "bi #{tracking_list.icon_name_on} text-warning" : "bi #{tracking_list.icon_name_off} text-muted" %>"></i>
    </button>
  <% end %>
</td>
```
