class CreateScoutingProfile < ActiveRecord::Migration[8.0]
  def change
    create_table :scouting_profiles do |t|
      t.references :player, foreign_key: true

      t.string :timeline
      t.string :timeline_type

      t.string :risk
      t.string :eta

      t.decimal :espn_ovr_rnk, precision: 10, scale: 3
      t.decimal :ath_ovr_rnk, precision: 10, scale: 3
      t.decimal :ba_ovr_rnk, precision: 10, scale: 3
      t.decimal :pl_ovr_rnk, precision: 10, scale: 3
      t.decimal :cbs_ovr_rnk, precision: 10, scale: 3
      t.decimal :fg_ovr_rnk, precision: 10, scale: 3
      t.decimal :self_ovr_rnk, precision: 10, scale: 3
      t.decimal :espn_tm_rnk, precision: 10, scale: 3
      t.decimal :ath_tm_rnk, precision: 10, scale: 3
      t.decimal :ba_tm_rnk, precision: 10, scale: 3
      t.decimal :pl_tm_rnk, precision: 10, scale: 3
      t.decimal :cbs_tm_rnk, precision: 10, scale: 3
      t.decimal :fg_tm_rnk, precision: 10, scale: 3
      t.decimal :self_tm_rnk, precision: 10, scale: 3
      t.decimal :espn_fv, precision: 10, scale: 3
      t.decimal :ath_fv, precision: 10, scale: 3
      t.decimal :ba_fv, precision: 10, scale: 3
      t.decimal :pl_fv, precision: 10, scale: 3
      t.decimal :cbs_fv, precision: 10, scale: 3
      t.decimal :fg_fv, precision: 10, scale: 3
      t.decimal :self_fv, precision: 10, scale: 3

      t.decimal :hit_pres, precision: 10, scale: 3
      t.decimal :hit_proj, precision: 10, scale: 3
      t.decimal :game_pwr_pres, precision: 10, scale: 3
      t.decimal :game_pwr_proj, precision: 10, scale: 3
      t.decimal :raw_pwr_pres, precision: 10, scale: 3
      t.decimal :raw_pwr_proj, precision: 10, scale: 3
      t.decimal :pit_sel, precision: 10, scale: 3
      t.decimal :bat_ctrl, precision: 10, scale: 3
      t.decimal :hard_hit, precision: 10, scale: 3
      t.decimal :spd_pres, precision: 10, scale: 3
      t.decimal :spd_proj, precision: 10, scale: 3
      t.decimal :fld_pres, precision: 10, scale: 3
      t.decimal :fld_proj, precision: 10, scale: 3

      t.decimal :control_pres, precision: 10, scale: 3
      t.decimal :control_proj, precision: 10, scale: 3
      t.decimal :command_pres, precision: 10, scale: 3
      t.decimal :command_proj, precision: 10, scale: 3
      t.decimal :fastball_pres, precision: 10, scale: 3
      t.decimal :fastball_proj, precision: 10, scale: 3
      t.decimal :fastball_type, precision: 10, scale: 3
      t.decimal :curve_pres, precision: 10, scale: 3
      t.decimal :curve_proj, precision: 10, scale: 3
      t.decimal :slider_pres, precision: 10, scale: 3
      t.decimal :slider_proj, precision: 10, scale: 3
      t.decimal :sweeper_pres, precision: 10, scale: 3
      t.decimal :sweeper_proj, precision: 10, scale: 3
      t.decimal :changeup_pres, precision: 10, scale: 3
      t.decimal :changeup_proj, precision: 10, scale: 3
      t.decimal :cutter_pres, precision: 10, scale: 3
      t.decimal :cutter_proj, precision: 10, scale: 3
      t.decimal :arm_pres, precision: 10, scale: 3
      t.decimal :arm_proj, precision: 10, scale: 3

      t.date :archived_at
      t.timestamps
    end
  end
end
