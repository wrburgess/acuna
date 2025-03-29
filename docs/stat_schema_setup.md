Stat Model schema
    
## Meta

references player
references team
references opponent (team alias)
references timeline

string, mlbam_id
string, game_number
string, game_time
string, game_location
string, game_result
text, notes

datetime, recorded_at
datetime, archived_at
datetime, created_at
datetime, updated_at

## Batting

bat_ab, "batting - total at bats"
bat_app, "batting - total appearances"
bat_avg, "batting - batting average"
bat_babip, "batting - batting average on balls in play"
bat_bb, "batting - total base on balls (walks)"
bat_cs, "batting - total caught stealings"
bat_doubles, "batting - total doubles"
bat_errors, "batting - total errors"
bat_gdp, "batting - total ground into double plays"
bat_hbp, "batting - total hits by pitches"
bat_hits, "batting - total_hits"
bat_hr, "batting - total home runs"
bat_iso, "batting - isolated power"
bat_k, "batting - total strikeouts"
bat_nsb, "batting - net stolen bases (sb - cs)"
bat_obp, "batting - on base percentage"
bat_ops, "batting - on-base plus slugging percentage"
bat_pa, "batting - total plate appearances"
bat_rbi, "batting - total runs batted in"
bat_runs, "batting - total runs"
bat_sb, "batting - total stolen bases"
bat_sf, "batting - total sacrifice flies"
bat_slg, "batting - slugging percentage"
bat_triples, "batting - total triples"
bat_war, "batting - weighted runs created plus (wRC+)"
bat_woba, "batting - weighted on-base average (wOBA)"
bat_wraa, "batting - weighted runs above average (wRAA)"
bat_wrc, "batting - weighted runs created (wRC)"
bat_wrc_plus, "batting - weighted runs created plus (wRC+)"
bat_wsb, "batting - weighted stolen base runs (wSB)"
bat_xbh, "batting - extra base hits"

## Pitching

k_bb_pct_diff, "pitching - diff between k pct and bb pct (K-BB%)"
k_bb_ratio, "pitching - k to bb ratio (K/BB)"
pit_baa, "pitching - batting average against"
pit_baa, "pitching - batting average against"
pit_babip, "pitching - batting average balls in play against"
pit_balks, "pitching - total balks"
pit_bb_9, "pitching - walks per nine innings"
pit_bb_k, "pitching - walk and strikeout ratio"
pit_bb_pct, "pitching - base on ball percentage"
pit_bb_pct, "pitching - walk percentage"
pit_bs, "pitching - total blown saves"
pit_cg, "pitching - total complete games pitched"
pit_era, "pitching - earned run average"
pit_fip, "pitching - fielder independent pitching"
pit_gb_pct, "pitching - ground ball percentage"
pit_gs, "pitching - total games started"
pit_ha, "pitching - total hits against"
pit_hit_bats, "pitching - total hit batters"
pit_holds, "pitching - total holds"
pit_hr_9, "pitching - home runs per nine innings"
pit_hra, "pitching - total home runs against"
pit_ibb, "pitching - intentional base on balls allowed"
pit_inn, "pitching - total innings pitched"
pit_k_9, "pitching - strikeouts per nine innings"
pit_k_pct, "pitching - strikeout percentage"
pit_ks, "pitching - total strikeouts"
pit_lob_pct, "pitching - left on base percentage"
pit_losses, "pitching - total losses"
pit_nr, "pitching - net reliefs (saves + holds + relief wins - blown saves)
pit_qs, "pitching - total quality starts"
pit_rw, "pitching - total relief wins"
pit_saves, "pitching - total saves"
pit_tbf, "pitching - total batters faced"
pit_whip, "pitching - walks and hits per inning pitched"
pit_wilds, "pitching - total wild pitches"
pit_wins, "pitching - total wins"
pit_xera, "pitching - expected earned run average"
pit_xfip, "pitching - expected fielder independent pitching (HRs are 10.5% of Fly Balls induced)"
  
