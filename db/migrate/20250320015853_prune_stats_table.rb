class PruneStatsTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :stats, :cbs_rank
    remove_column :stats, :fg_top_rank
    remove_column :stats, :fg_org_rank
    remove_column :stats, :fg_fv
    remove_column :stats, :fg_hit_pres
    remove_column :stats, :fg_hit_proj
    remove_column :stats, :fg_pwr_pres
    remove_column :stats, :fg_pwr_proj
    remove_column :stats, :fg_pit_sel
    remove_column :stats, :fg_bat_ctrl
    remove_column :stats, :fg_spd_pres
    remove_column :stats, :fg_spd_proj
    remove_column :stats, :fg_fld_pres
    remove_column :stats, :fg_fld_proj
    remove_column :stats, :fg_hard_hit
    remove_column :stats, :ba_rank
    remove_column :stats, :mlb_rank
    remove_column :stats, :kl_rank
    remove_column :stats, :mcd_rank
    remove_column :stats, :mcd_fv

    add_reference :stats, :team, foreign_key: true
    add_reference :stats, :opponent, foreign_key: { to_table: :teams }

    add_column :stats, :recorded_at, :datetime
    add_column :stats, :game_number, :integer
    add_column :stats, :game_time, :datetime
    add_column :stats, :game_location, :string
    add_column :stats, :game_result, :string
    add_column :stats, :notes, :text
  end
end
