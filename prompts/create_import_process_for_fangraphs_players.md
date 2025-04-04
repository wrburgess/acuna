
Use the maintenance task gem like is done with the "players_import_cbs_context_task.fb" file

Use the roo gem for accessing the xlsx file

Set an attribute of file_name with default being "players_fangraphs_mlb_2025-04.xlsx"

First check if there's a match for each player record based on first_name and last_name. In the case of Max Muncy, ensure you check the team value, as well.

If there is no match, check if the file fg_id value matches the Player table record with a fg_id value

If there is still no match, create a new player record

If there is a match, update the player record from this file with these attributes:

age
height
weight
bats
throws
fg_id

You need to match the Level value with the Level abbreviation in the Level model or match it with the  "N/A" level

You need to match the file Team value with the Team.abbreviation and use alternative abbreviations that fangraphs uses if there is no match:

WSN = WAS
KCR = KC
TBR = TB
SDP = SD
ATH = OAK
SFG = SF

If a match still fails to be found, skip the association for Team
