You are a Ruby on Rails senior full-stack developer with a decade of experience with Ruby on Rails and Bootstrap

Create a view named profile.html.erb for a player instance
Feel free to use dummy data so I can just approve the design

## Player Card

* In desktop view there should be a Player Card with data below
* This card should take up half the screen in desktop view in Top Left area
* This card should take up full screen in mobile view

### Title

* player_full_name
* player_position
* player_team_name
* player_roster_name
* Example:

  Roman Anthony, RF, BOS, WRI

### Status

* player_acquisition - Player (new)
* player_level - Player
* player_type - Player
* eta
* risk
* Example:

  Acquired: 2017 Draft 1.17
  Current Level: AAA
  ETA: 2025, Risk: HIGH

### Metrics

* player_age - Player
* player_height - Player
* player_weight - Player
* player_hit - Player
* player_throw - Player
* Example:

  Age: 19, Ht: 6'2", Wt: 170lbs
  Hits: Right, Throws: Left

### Misc

* tj_at - ScoutingReport
* Example:

  TJ Surgery: 2023-01-02

## Scouting Card

* In desktop view there should be a Scouting Card with data below
* This card should take up half the screen in desktop view on right side
* This card should take up full screen in mobile view 

### Reports Referenced

* scout
* scouting_report
* reported_at

Examples:

  [Preseason 2025, K Law, The Athletic, 2025/03](link_to_scouting_report)
  [Preseason 2025, K McDaniel, ESPN, 2025/03](link_to_scouting_report)

## Analysis Card

* In desktop view there should be a Analysis Card with data below
* This card should take up the full screen in desktop view on second row
* This card should take up full screen in mobile view 
* The body text should be shortened to one line by default view with elipsis, but expandable to read the entire body

### Analysis

* body

Examples:

  Law 25/03: "Sasaki cemented a legacy while he was still in high school. There was a stretch when he was asked to throw nearly 500 pitches..."
  McDaniel 25/03: "In high school, Anthony presented clubs with a risky but exciting combination of present raw power and long-term power projection, but..."

## Rankings Card

* In desktop view there should be a Ranking Card with data below for each scount
* This card should take up the full screen in desktop view on second row
* This card should take up full screen in mobile view 
* The body text should be shortened to one line by default view with elipsis, but expandable to read the entire body

### Rankings

* scout, overall_ranking, team_ranking, future_value, 2025_draft_ranking, 2026_draft_ranking
* Column for each scount

Example:

          KL    KM     EL    
Overall | 15 |  11  |  11  | 
Team    |  3 |   1  |   1  | 
FV      |    |  60  |  55  | 

## Hitting Grades

* In desktop view there should be a Hitting Grades with data below for each scount
* This card should take up the full screen in desktop view on third row
* This card should take up full screen in mobile view 
* The category should be in the top headers, the data in rows below
* Each scouting report should have a row with respective values (if present)
* For data with Present / Projected data, for example, hit_pres of 40 and hit_proj of 55 should look like 40/55 in one column with label of Hit
* Other fields are standalone, like bat_ctrl

* hit_pres
* hit_proj
* raw_pwr_pres
* raw_pwr_proj
* game_pwr_pres
* game_pwr_proj
* bat_ctrl
* pit_sel
* hard_hit
* spd_pres
* spd_proj
* fld_pres
* fld_proj
* arm_pres
* arm_proj

## Pitching Grades

* In desktop view there should be a Pitching Grades with data below for each scount
* This card should take up the full screen in desktop view on third row
* This card should take up full screen in mobile view 
* The category should be in the top headers, the data in rows below
* Each scouting report should have a row with respective values (if present)
* For data with Present / Projected data, for example, command_pres of 40 and command_proj of 55 should look like 40/55 in one column with label of Command

* command_pres
* command_proj
* control_pres
* control_proj
* changeup_pres
* changeup_proj
* curve_pres
* curve_proj
* cutter_pres
* cutter_proj
* fastball_type
* fastball_pres
* fastball_proj
* slider_pres
* slider_proj
* sweeper_pres
* sweeper_proj

## Meta Data

* archived_at
* created_at
* updated_at
