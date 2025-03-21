You are a Ruby on Rails senior full-stack developer with a decade of experience with Ruby on Rails and Bootstrap

Create a view named admin/players/index.html.erb for player index

Use dummy data so I can just approve the design

The table style and fonts need to be small and compact, headers should not minimal

This is like a spreadsheet more than a webpage

Mousing over rows should be lightly highlighted

Show at least 50 rows of player data in example

Pager should be at the bottom as if there are 30+ pages of data

Leave the headers and filter card already on the page where they are


## Status Filters

There should be a nav bar for filters (links)

* All Players
* Pros
* Prospects
* Free Agents (players not on a roster)
* Roster (players on Wrigleyville Fielders roster)
* Starters (players on WRI roster, but status of prospect)
* Prospects (players on WRI roster, but status of prospect)
* Tracked (players tagged as Tracked)
* Targets (players on rosters tagged as Trade Targets)

## List Filters

There should be second nav bar for Lists (links). These are examples of fake list names

* 2025 Draft
* 2026 Draft
* 2026 INTL Signs
* Recently Hyped
* Comps 1
* Comps 2

## Position Filters

There should be third nav bar for Positions (links)

* CA
* 1B
* 2B
* SS
* 3B
* RF
* CF
* LF
* DH
* SP
* RP

## Timeline Filters

There should be 4th nav bar for Timelines (links)

* 2024
* 2025
* 7 Days
* 14 Days
* 21 Days
* 30 Days
* 60 Days

#### Batter Stat Lines

* roster_position
* player - Example (Bryce Harper, PHI)
* status (prospect, pro)
* level (Pro, AAA, JPN, NCAA, etc)
* OPS
* RBI
* HR
* R
* NSB
* ER
* wRC+
* PA
* AB
* H
* BB
* BB%
* K
* K%
* SB
* CS
* BA
* OBP
* SLG
* WAR

#### Pitcher Stat Lines

* roster_position (SP or RP)
* player - Example (Chase Burnes, ARI)
* status (prospect, pro)
* level (Pro, AAA, JPN, NCAA, etc)
* QS
* K/9
* ERA
* WHIP
* NR
* INN
* W-L
* HA
* HRA
* BAA
* S
* BS
* RW
