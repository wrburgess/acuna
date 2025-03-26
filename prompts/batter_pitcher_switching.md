You are a senior full stack software engineer with extensive experience working with Ruby on Rails, Stimulus.js, and Hotwire.

* The objective of this project is to allow users to switch between Batter and Pitcher contexts on the Player Dashboard.
* We need to add a link menu, somewhat like Level, Status, Position, etc that is named "Type"
* The two options are Batter and Pitcher, with Batter being the option if the page is hit by default
* If the Batter option is defaulted or selected, the Batter Data Table is rendered
* If the Pitcher option is selected, the Pitcher Data Table is rendered
* If the batter option is used, only batters (C, 1B, 2B, 3B, SS, LF, CF, RF, DH) should be shown in the table
* If the pitcher option is used, only pitchers (SP, RP) should be shown

## Key objectives

* Use Stimulus.js in the app/javascript/admin/ directory to handle any browser interaction

## Relevant models

* Player

## Relevant controllers

* PlayerController and dashboard action

## Relevant pages

* app/views/admin/players/dashboard.html.erb

## Relevant pitching stats

Player - base
Roster - base
Level - base
Status - base
Age - base

QS - scoring
K_9 - scoring
ERA - scoring
WHP - scoring
S (Saves) - scoring
NR (Net Reliefs) - scoring

G (Games) - stats
GS (Games Started) - stats
IP - stats
W-L (Win-Loss) - stats
QS - stats
FIP - stats
XFIP - stats
WAR - stats
HA (Hits Against) - stats
RA (Runs Against) - stats
HRA (Home Runs Against) - stats
BB (Walks Against) - stats
IBB (Intentional Walks Against) - stats
BLK (Balks) - stats
K_9 - stats
BB_9 - stats
HR_9 - stats
BABIP - stats
LOB_PCT - stats
ERA - stats
WHP - stats
S (Saves) - stats
BS (Blown Saves) - stats
H (Holds) - stats
RW (Relief Wins) - stats
NR (Net Reliefs) - stats
risk - scouting
eta - scouting
espn_ovr_rnk - scouting
ath_ovr_rnk - scouting
ba_ovr_rnk - scouting
pl_ovr_rnk - scouting
cbs_ovr_rnk - scouting
fg_ovr_rnk - scouting
espn_tm_rnk - scouting
ath_tm_rnk - scouting
fg_tm_rnk - scouting
espn_fv - scouting
fg_fv - scouting
control_pres - scouting
control_proj - scouting
command_pres - scouting
command_proj - scouting
fastball_pres - scouting
fastball_proj - scouting
fastball_type - scouting
curve_pres / curve_proj - scouting
slider_pres / slider_proj - scouting
sweeper_pres / sweeper_proj - scouting
changeup_pres / changeup_proj - scouting
cutter_pres / cutter_proj - scouting
arm_pres / arm_proj - scouting
