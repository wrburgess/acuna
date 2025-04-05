You are an experienced Ruby on Rails backend engineer and have extensive experience with PostgreSQL, Excel files, csv files, and data import/transformation projects.

Use the maintenance task gem like is done with the "players_import_cbs_context_task.fb" file

Use the roo gem for accessing the xlsx file

Set an attribute of file_name with default being "stats_fangraphs_batters_2025.xlsx"
Set an attribute of timeline_abbreviation with default being "YTD"

Retrieve the Timeline record based on the timeline_abbreviation value and timeline.abbreviation value

Create a task that imports the data in the xlsx file into the Stats table

Do not create a new Stat record if the player already has a stat record associated with the timeline. Instead, update the record with the file data.

Each record will be associated with the player table via teh NameASCII attribute and the player.first_name + ' ' + player.middle_name + ' ' + player.last_name + ' ' + player.name_suffix

You'll need to map the headers in the file to the equivalent in the Stats table

update the mlbamid, playerid, and nameascii on the player instance AND stats instance 

Check the Stats table for all player instances that DO NOT have an associated Stat record also associated with the timeline. Create a blank record (all zeros for all stat attributes) for those players in the db that have no stat record for this particular timeline

Keep a log of how many stats are created, how many stats instances are updated, and how many players do not have stats from the file (but have a blank one created).

Let me know if you have trouble mapping the file headers to the values in the Stats schema

All batting-related stats have a bat_ prefix in their name
All pitching_related stats have a pitch_ prefix in their name
