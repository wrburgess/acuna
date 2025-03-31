  player
  
  string "timeline"
  
  string "risk"
  string "eta"

  decimal espn_ovr_rnk
  decimal ath_ovr_rnk
  decimal ba_ovr_rnk
  decimal pl_ovr_rnk
  decimal cbs_ovr_rnk
  decimal self_ovr_rnk
  decimal espn_tm_rnk
  decimal ath_tm_rnk
  decimal ba_tm_rnk
  decimal pl_tm_rnk
  decimal cbs_tm_rnk
  decimal self_tm_rnk
  decimal espn_fv
  decimal ath_fv
  decimal ba_fv
  decimal pl_fv
  decimal cbs_fv
  decimal self_fv

  decimal "hit_pres", precision: 10, scale: 3
  decimal "hit_proj", precision: 10, scale: 3
  decimal "game_pwr_pres", precision: 10, scale: 3
  decimal "game_pwr_proj", precision: 10, scale: 3
  decimal "raw_pwr_pres", precision: 10, scale: 3
  decimal "raw_pwr_proj", precision: 10, scale: 3
  decimal "pit_sel", precision: 10, scale: 3
  decimal "bat_ctrl", precision: 10, scale: 3
  decimal "hard_hit", precision: 10, scale: 3
  decimal "spd_pres", precision: 10, scale: 3
  decimal "spd_proj", precision: 10, scale: 3
  decimal "fld_pres", precision: 10, scale: 3
  decimal "fld_proj", precision: 10, scale: 3

  decimal "control_pres", precision: 10, scale: 3
  decimal "control_proj", precision: 10, scale: 3
  decimal "command_pres", precision: 10, scale: 3
  decimal "command_proj", precision: 10, scale: 3
  decimal "fastball_pres", precision: 10, scale: 3
  decimal "fastball_proj", precision: 10, scale: 3
  decimal "fastball_type", precision: 10, scale: 3
  decimal "curve_pres", precision: 10, scale: 3
  decimal "curve_proj", precision: 10, scale: 3
  decimal "slider_pres", precision: 10, scale: 3
  decimal "slider_proj", precision: 10, scale: 3
  decimal "sweeper_pres", precision: 10, scale: 3
  decimal "sweeper_proj", precision: 10, scale: 3
  decimal "changeup_pres", precision: 10, scale: 3
  decimal "changeup_proj", precision: 10, scale: 3
  decimal "cutter_pres", precision: 10, scale: 3
  decimal "cutter_proj", precision: 10, scale: 3
  decimal "arm_pres", precision: 10, scale: 3
  decimal "arm_proj", precision: 10, scale: 3

  date "archived_at"
  datetime "created_at", null: false
  datetime "updated_at", null: false
