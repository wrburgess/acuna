# Create Import Process for SFBB context

## Instructions

## Feature Description

 Create a new maintenance task that imports the sfbb player data, ids, and context to seed or update records in the players table for the Player model.

## User Stories

   - As an admin, I want to run the maintenance task, so that the data is imported into the database as a new record or updated record.

## Technical Requirements

   - Data will be imported into the players table.
   - The Player model will be the relevant model used.
   - Use the Maintenance Task gem to create a task and use the patterns present in the app/tasks/maintenance directory for the file you create and utilize.
   - Knowing the players table schema from the db/schema.rb file, match the column names in the import file with the proper attributes in the players table. Make a note where you are not sure if you have the correct match so that I can check it.

## UI/UX Design

   - No UI features in this case.

## Acceptance Criteria

   - Given a file name is provided or defaulted "players_sfbb_2025-04.csv", when the task is ran, then the data will be imported to the correct attributes to the correct player record (existing or newly created).

## Testing

   - No tests for this task

## Deployment Considerations

   - Not a concern for this feature

## Additional Notes

* A good example of the task to use is named "players_import_cbs_context_task.rb"
* Column names are consistent but not named exactly the same. Sometimes the name is IDFANGRAPHS but I name it fangraphs_id
* Don't pause, but leave a comment where you need my review in the task file
* Log skipped or invalid records, the row number should suffice
* For fields in the player table that are not in the csv file, just leave them alone, don't change the existing data or leave them nil
* Use logging to keep track of progress during the import
* Match the player record on the fangraphs_id OR the fangraphs_name OR the cbs_id OR the cbs_name OR the yahoo_id OR the espn_id before we create a new record
* If you must create a new player, use the cbs name for the first_name (Michael), middle_name (A.), last_name (Taylor), and name suffix (Jr.)
* If a new player record is created, use the "POS" column from the csv file, but convert the "P" position to "SP"
* If a player record is updated, do NOT use the POS column to update the Players table position attribute.
