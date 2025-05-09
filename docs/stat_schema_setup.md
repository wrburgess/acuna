Stat Model schema
    
player_id, bigint, meta
team_id, bigint, meta
opponent_id, bigint, meta
timeline_id, bigint, meta

mlbam_id, string
game_number, integer
game_time, datetime
game_location, string
game_result, string
text, notes

datetime, recorded_at
datetime, archived_at
datetime, created_at
datetime, updated_at

bat_obp, OBP, "batting - on base percentage", decimal, scoring
bat_hr, HR, "batting - total home runs", decimal, scoring 
bat_runs, R, "batting - total runs", decimal, scoring
bat_rbi, RBI, "batting - total runs batted in", decimal, scoring 
bat_nsb, NSB, "batting - net stolen bases (sb - cs)", decimal, scoring
bat_errors, E, "batting - total errors", decimal, scoring

bat_pa, PA, "batting - total plate appearances", decimal, stats
bat_ab, AB, "batting - total at bats", decimal, stats
bat_avg, AVG, "batting - batting average", decimal, stats
bat_babip, BABIP, "batting - batting average on balls in play", decimal, stats
bat_bb, BB , "batting - total base on balls (walks)", decimal, stats
bat_cs, CS, "batting - total caught stealings", decimal, stats stats
bat_doubles, 2B, "batting - total doubles", decimal, stats stats
bat_errors, E, "batting - total errors", decimal, stats
bat_gdp, GDP, "batting - total ground into double plays", decimal, stats
bat_hbp, HBP, "batting - total hits by pitches", decimal, stats
bat_hits, H, "batting - total_hits", decimal, stats
bat_hr, HR, "batting - total home runs", decimal, stats
bat_iso, ISO, "batting - isolated power", decimal, stats
bat_k, K, "batting - total strikeouts", decimal, stats
bat_ops, OPS, "batting - on-base plus slugging percentage", decimal, stats
bat_obp, OBP, "batting - on base percentage", decimal, scoringstats
bat_rbi, "batting - total runs batted in", decimal, stats
bat_runs, "batting - total runs", decimal, stats
bat_sb, "batting - total stolen bases", decimal, stats
bat_sf, "batting - total sacrifice flies", decimal, stats
bat_slg, "batting - slugging percentage", decimal, stats
bat_triples, "batting - total triples", decimal, stats
bat_war, "batting - weighted runs created plus (wRC+)", decimal, stats
bat_woba, "batting - weighted on-base average (wOBA)", decimal, stats
bat_wraa, "batting - weighted runs above average (wRAA)", decimal, stats
bat_wrc, "batting - weighted runs created (wRC)", decimal, stats
bat_wrc_plus, "batting - weighted runs created plus (wRC+)", decimal, stats
bat_wsb, "batting - weighted stolen base runs (wSB)", decimal, stats
bat_xbh, "batting - extra base hits", decimal,stats 

pit_qs, QS, "pitching - total quality starts", decimal, scoring
pit_k_9, K/9, "pitching - strikeouts per nine innings", decimal, scoring
pit_era, ERA, "pitching - earned run average", decimal, scoring 
pit_whip, WHIP, "pitching - walks and hits per inning pitched", decimal, scoring 
pit_nr, NR, "pitching - net reliefs (saves + holds + relief wins - blown saves), decimal, scoring

pit_gs, GS, "pitching - total games started", decimal, stats
pit_inn, INN, "pitching - total innings pitched", decimal, stats
pit_cg, CG, "pitching - total complete games pitched", decimal, stats
pit_tbf, TBF, "pitching - total batters faced", decimal, stats
pit_qs, QS, "pitching - total quality starts", decimal, stats
pit_wins, W, "pitching - total wins", decimal, stats
pit_losses, L, "pitching - total losses", decimal, stats
pit_ha, HA, "pitching - total hits against", decimal, stats
pit_whip, WHIP, "pitching - walks and hits per inning pitched", decimal, stats
pit_era, ERA, "pitching - earned run average", decimal, stats
pit_xera, xERA, "pitching - expected earned run average", decimal, stats
pit_baa, BAA, "pitching - batting average against", decimal, stats
pit_babip, BABIP, "pitching - batting average balls in play against", decimal, stats
pit_ks, K, "pitching - total strikeouts", decimal, stats
pit_k_9, K/9, "pitching - strikeouts per nine innings", decimal, stats
pit_k_pct, K%, "pitching - strikeout percentage", decimal, stats
pit_k_bb_ratio, K/BB, "pitching - k to bb ratio", decimal, stats
pit_k_bb_pct_diff, K-BB%, "pitching - diff between k pct and bb pct", decimal, stats
pit_bb_9, BB/9, "pitching - walks per nine innings", decimal, stats
pit_bb_k, BB/K, "pitching - walk and strikeout ratio", decimal, stats
pit_bb_pct, BB%, "pitching - base on ball percentage", decimal, stats
pit_bb, BB, "pitching - total base on balls allowed", decimal, stats
pit_ibb, IBB, "pitching - intentional base on balls allowed", decimal, stats
pit_fip, FIP, "pitching - fielder independent pitching", decimal, stats
pit_xfip, xFIP, "pitching - expected fielder independent pitching (HRs 10.5% of Fly Balls)", decimal, stats
pit_gb_pct, GB%, "pitching - ground ball percentage", decimal, stats
pit_hra, HRA, "pitching - total home runs against", decimal, stats
pit_hr_9, HR/9, "pitching - home runs per nine innings", decimal, stats
pit_lob_pct, LOB%, "pitching - left on base percentage", decimal, stats
pit_saves, S, "pitching - total saves", decimal, stats
pit_holds, H, "pitching - total holds", decimal, stats
pit_rw, RW, "pitching - total relief wins", decimal, stats
pit_bs, BS, "pitching - total blown saves", decimal, stats
pit_nr, NR, "pitching - net reliefs (saves + holds + relief wins - blown saves), decimal, stats
pit_hit_bats, HB, "pitching - total hit batters", decimal, stats
pit_balks, BLK, "pitching - total balks", decimal, stats
pit_wilds, WP, "pitching - total wild pitches", decimal, stats
