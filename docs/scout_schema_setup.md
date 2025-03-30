Scouting Model schema
    
player_id, bigint, meta
timeline_id, bigint, meta
scout_id, bigint, meta

recorded_at, datetime
archived_at, datetime
created_at, datetime
updated_at, datetime

risk, RISK, fangraphs, string
eta, ETA, fangraphs, string
espn_overall_rank, EOVR, espn, decimal
ath_overall_rank, AOVR, athletic, decimal
ba_overall_rank, BOVR, baseball america, decimal
pl_overall_rank, POVR, prospects live, decimal
cbs_overall_rank, COVR, cbs, decimal
fg_overall_rank, FOVR, fangraphs, decimal
self_overall_rank, SOVR, user, decimal
espn_team_rank, ETM, espn, decimal
ath_team_rank, ATM, athletic, decimal
ba_team_rank, BTM, baseball america, decimal
pl_team_rank, PTM, prospects live, decimal
cbs_team_rank, CTM, cbs, decimal
fg_team_rank, FTM, fangraphs, decimal
self_team_rank, STM, user, decimal
espn_future_value, EFV, espn, decimal
ath_future_value, ATHFV, athletic, decimal
ba_future_value, BAFV, baseball america, decimal
pl_future_value, PLFV, prospects live, decimal
cbs_future_value, CFV, cbs, decimal
fg_future_value, FFV, fangraphs, decimal
self_future_value, SFV, user, decimal

bat_hit_pres, HIT, decimal
bat_hit_proj, HIT, decimal
bat_game_pwr_pres, GPWR, decimal
bat_game_pwr_proj, GPWR, decimal
bat_raw_pwr_pres, RPWR, decimal
bat_raw_pwr_proj, RPWR, decimal
bat_pit_sel, PSEL, decimal
bat_bat_ctrl, BCTL, decimal
bat_hard_hit, HH%, decimal
bat_spd_pres, SPEED, decimal
bat_spd_proj, SPEED, decimal
bat_fld_pres, FIELD, decimal
bat_fld_proj, FIELD, decimal

pit_control_pres, CNT, decimal
pit_control_proj, CNT, decimal
pit_command_pres, CMD, decimal
pit_command_proj, CMD, decimal
pit_fastball_pres, FB, decimal
pit_fastball_proj, FB, decimal
pit_fastball_type, FBT, decimal
pit_curve_pres, CURV, decimal
pit_curve_proj, CURV, decimal
pit_slider_pres, SLDR, decimal
pit_slider_proj, SLDR, decimal
pit_sweeper_pres, SWEEP, decimal
pit_sweeper_proj, SWEEP, decimal
pit_changeup_pres, CHGUP, decimal
pit_changeup_proj, CHGUP, decimal
pit_cutter_pres, CUTTR, decimal
pit_cutter_proj, CUTTR, decimal
pit_arm_pres, ARM, decimal
pit_arm_proj, ARM, decimal
