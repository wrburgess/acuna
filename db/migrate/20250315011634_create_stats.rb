class CreateStats < ActiveRecord::Migration[8.0]
  def change
    create_table :stats do |t|
      t.references :player, null: false, foreign_key: true

      t.string :timeline
      t.string :timeline_type
      t.decimal :pa, precision: 10, scale: 3
      t.decimal :ab, precision: 10, scale: 3
      t.decimal :runs, precision: 10, scale: 3
      t.decimal :hits, precision: 10, scale: 3
      t.decimal :_2b, precision: 10, scale: 3
      t.decimal :_3b, precision: 10, scale: 3
      t.decimal :hr, precision: 10, scale: 3
      t.decimal :rbi, precision: 10, scale: 3
      t.decimal :bb, precision: 10, scale: 3
      t.decimal :k, precision: 10, scale: 3
      t.decimal :sb, precision: 10, scale: 3
      t.decimal :cs, precision: 10, scale: 3
      t.decimal :avg, precision: 10, scale: 3
      t.decimal :obp, precision: 10, scale: 3
      t.decimal :slg, precision: 10, scale: 3
      t.decimal :cbs_rank, precision: 10, scale: 3
      t.decimal :fg_top_rank, precision: 10, scale: 3
      t.decimal :fg_org_rank, precision: 10, scale: 3
      t.decimal :fg_fv, precision: 10, scale: 3
      t.decimal :fg_hit_pres, precision: 10, scale: 3
      t.decimal :fg_hit_proj, precision: 10, scale: 3
      t.decimal :fg_pwr_pres, precision: 10, scale: 3
      t.decimal :fg_pwr_proj, precision: 10, scale: 3
      t.decimal :fg_pit_sel, precision: 10, scale: 3
      t.decimal :fg_bat_ctrl, precision: 10, scale: 3
      t.decimal :fg_spd_pres, precision: 10, scale: 3
      t.decimal :fg_spd_proj, precision: 10, scale: 3
      t.decimal :fg_fld_pres, precision: 10, scale: 3
      t.decimal :fg_fld_proj, precision: 10, scale: 3
      t.decimal :fg_hard_hit, precision: 10, scale: 3
      t.decimal :ba_rank, precision: 10, scale: 3
      t.decimal :mlb_rank, precision: 10, scale: 3
      t.decimal :kl_rank, precision: 10, scale: 3
      t.decimal :mcd_rank, precision: 10, scale: 3
      t.decimal :mcd_fv, precision: 10, scale: 3

      t.datetime :archived_at
      t.timestamps
    end
  end
end
