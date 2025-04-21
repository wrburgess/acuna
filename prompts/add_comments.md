# Comment Feature Project Prompt

## Your Role

   - You are an experienced senior software engineer with signication knowlege of Ruby on Rails version 8+ and JavaScript, Hotwire, Turbo, and Stimulus
   - You like to utilize existing patterns in an application you are asked to work on, rather than create different patterns.
   - You prefer clear code and write comments to let other developers know what your code is doing.
   - You are fine to write simple code rather than add new libraries (ruby gems or node packages) unless it saves signifcant time

## Instructions

### Feature Description

- We want to be able to add Comments written by a user to any model on the application.
- To begin with, we will associate Comments to the Player and Scouting Report models, but our first interfaces will work with Player Profiles

### User Stories

- As an admin, I want to view an Index of Comments, a Show View of a Comment, an Edit View of a Comment, a New View of a Comment, to be able to update, create, and archive comments.
- As a user, I want to view a Player profile and see a list of existing comments.
- As a user, I want to view a Player Profile and be able to add additional comments
- As a user, I want to view a Player's comments and be able to edit them
- As a user, I want to view a Player's comments and be able to archive them

### Technical Requirements

- There should be a admin Comment Model in the app/models/admin directory
- There should be a admin Comment Controller in the app/controllers/admin directory
- There should be a an admin Comment Policy in the app/policies/admin directory
- You should make a Commentable polymorphic concern to handle the associations between a Comment and a Player (or future models)
- Stimulus controllers or Hotwire streams to be implemented using the app/javascripts/admin directory
- API endpoints to be created or updated if needed
- Use the Loggable and Archivable concerns for the Comment model
- Use the Team, Roster, and Level models as a good example of patterns to follow for the Comment model, controllers, views, etc as it pertains to admin functionality and code. Don't stray away from these patterns and code unless otherwise needed

### UI/UX Design

- The comments for a Player should be rendered on the app/views/admin/players/profile.html.erb view
- You may replace all of the code in the  <!-- Comments Card --> section around line 137
- We want each comment to have author initials, date of comment in yyyy-mm-dd format, and a truncated comment of max 100 characters.
- Use the accordian feature to expand the comment body so user can view comments that are longer than 100 characters
- At the bottom of the list, have a form that allows a user to add a new comment that will be associated with the user and the player
- Submitting a new comment should then add the new comment to the list
- There should be two icon buttons at the end of each comment for editing or archiving
- The list of comments should only show comments that have archived_at == nil

### Acceptance Criteria

- Given [context], when [action], then [expected outcome].

### Testing

- Skip testing for now

### Deployment Considerations

- No deployment changes needed

### Examples

* There's a good public repo with a comment feature that may be of value to analyze https://github.com/gorails-screencasts/gorails-episode-36
