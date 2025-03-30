class RebuildStatTable < ActiveRecord::Migration[8.0]
  def up
    # Drop the existing stats table
    drop_table :stats if table_exists?(:stats)

    # Create the new stats table with proper structure
    create_table :stats do |t|
      # Meta references
      t.references :player, foreign_key: true
      t.references :team, foreign_key: true
      t.references :opponent, foreign_key: { to_table: :teams }
      t.references :timeline, foreign_key: true

      # Meta fields
      t.string :mlbam_id
      t.string :game_number
      t.datetime :game_date
      t.string :game_location
      t.string :game_result
      t.datetime :started_at
      t.datetime :ended_at
      t.text :notes

      # Batting stats - all decimal with precision: 10, scale: 3
      t.decimal :bat_ab, precision: 10, scale: 3, comment: "batting - total at bats"
      t.decimal :bat_avg, precision: 10, scale: 3, comment: "batting - batting average"
      t.decimal :bat_babip, precision: 10, scale: 3, comment: "batting - batting average on balls in play"
      t.decimal :bat_bb, precision: 10, scale: 3, comment: "batting - total base on balls (walks)"
      t.decimal :bat_cs, precision: 10, scale: 3, comment: "batting - total caught stealings"
      t.decimal :bat_doubles, precision: 10, scale: 3, comment: "batting - total doubles"
      t.decimal :bat_errors, precision: 10, scale: 3, comment: "batting - total errors"
      t.decimal :bat_gdp, precision: 10, scale: 3, comment: "batting - total ground into double plays"
      t.decimal :bat_hbp, precision: 10, scale: 3, comment: "batting - total hits by pitches"
      t.decimal :bat_hits, precision: 10, scale: 3, comment: "batting - total_hits"
      t.decimal :bat_hr, precision: 10, scale: 3, comment: "batting - total home runs"
      t.decimal :bat_iso, precision: 10, scale: 3, comment: "batting - isolated power"
      t.decimal :bat_k, precision: 10, scale: 3, comment: "batting - total strikeouts"
      t.decimal :bat_nsb, precision: 10, scale: 3, comment: "batting - net stolen bases (sb - cs)"
      t.decimal :bat_obp, precision: 10, scale: 3, comment: "batting - on base percentage"
      t.decimal :bat_ops, precision: 10, scale: 3, comment: "batting - on-base plus slugging percentage"
      t.decimal :bat_pa, precision: 10, scale: 3, comment: "batting - total plate appearances"
      t.decimal :bat_rbi, precision: 10, scale: 3, comment: "batting - total runs batted in"
      t.decimal :bat_runs, precision: 10, scale: 3, comment: "batting - total runs"
      t.decimal :bat_sb, precision: 10, scale: 3, comment: "batting - total stolen bases"
      t.decimal :bat_sf, precision: 10, scale: 3, comment: "batting - total sacrifice flies"
      t.decimal :bat_slg, precision: 10, scale: 3, comment: "batting - slugging percentage"
      t.decimal :bat_triples, precision: 10, scale: 3, comment: "batting - total triples"
      t.decimal :bat_war, precision: 10, scale: 3, comment: "batting - weighted runs created plus (wRC+)"
      t.decimal :bat_woba, precision: 10, scale: 3, comment: "batting - weighted on-base average (wOBA)"
      t.decimal :bat_wraa, precision: 10, scale: 3, comment: "batting - weighted runs above average (wRAA)"
      t.decimal :bat_wrc, precision: 10, scale: 3, comment: "batting - weighted runs created (wRC)"
      t.decimal :bat_wrc_plus, precision: 10, scale: 3, comment: "batting - weighted runs created plus (wRC+)"
      t.decimal :bat_wsb, precision: 10, scale: 3, comment: "batting - weighted stolen base runs (wSB)"
      t.decimal :bat_xbh, precision: 10, scale: 3, comment: "batting - extra base hits"

      # Pitching stats - all decimal with precision: 10, scale: 3
      t.decimal :pit_k_bb_pct_diff, precision: 10, scale: 3, comment: "pitching - diff between k pct and bb pct (K-BB%)"
      t.decimal :pit_k_bb_ratio, precision: 10, scale: 3, comment: "pitching - k to bb ratio (K/BB)"
      t.decimal :pit_baa, precision: 10, scale: 3, comment: "pitching - batting average against"
      t.decimal :pit_babip, precision: 10, scale: 3, comment: "pitching - batting average balls in play against"
      t.decimal :pit_balks, precision: 10, scale: 3, comment: "pitching - total balks"
      t.decimal :pit_bb, precision: 10, scale: 3, comment: "pitching - total base on balls"
      t.decimal :pit_bb_9, precision: 10, scale: 3, comment: "pitching - walks per nine innings"
      t.decimal :pit_bb_k, precision: 10, scale: 3, comment: "pitching - walk and strikeout ratio"
      t.decimal :pit_bb_pct, precision: 10, scale: 3, comment: "pitching - base on ball percentage"
      t.decimal :pit_bs, precision: 10, scale: 3, comment: "pitching - total blown saves"
      t.decimal :pit_cg, precision: 10, scale: 3, comment: "pitching - total complete games pitched"
      t.decimal :pit_era, precision: 10, scale: 3, comment: "pitching - earned run average"
      t.decimal :pit_fip, precision: 10, scale: 3, comment: "pitching - fielder independent pitching"
      t.decimal :pit_gb_pct, precision: 10, scale: 3, comment: "pitching - ground ball percentage"
      t.decimal :pit_gs, precision: 10, scale: 3, comment: "pitching - total games started"
      t.decimal :pit_ha, precision: 10, scale: 3, comment: "pitching - total hits against"
      t.decimal :pit_hit_bats, precision: 10, scale: 3, comment: "pitching - total hit batters"
      t.decimal :pit_holds, precision: 10, scale: 3, comment: "pitching - total holds"
      t.decimal :pit_hr_9, precision: 10, scale: 3, comment: "pitching - home runs per nine innings"
      t.decimal :pit_hra, precision: 10, scale: 3, comment: "pitching - total home runs against"
      t.decimal :pit_ibb, precision: 10, scale: 3, comment: "pitching - intentional base on balls allowed"
      t.decimal :pit_inn, precision: 10, scale: 3, comment: "pitching - total innings pitched"
      t.decimal :pit_k_9, precision: 10, scale: 3, comment: "pitching - strikeouts per nine innings"
      t.decimal :pit_k_pct, precision: 10, scale: 3, comment: "pitching - strikeout percentage"
      t.decimal :pit_ks, precision: 10, scale: 3, comment: "pitching - total strikeouts"
      t.decimal :pit_lob_pct, precision: 10, scale: 3, comment: "pitching - left on base percentage"
      t.decimal :pit_losses, precision: 10, scale: 3, comment: "pitching - total losses"
      t.decimal :pit_nr, precision: 10, scale: 3, comment: "pitching - net reliefs (saves + holds + relief wins - blown saves)"
      t.decimal :pit_qs, precision: 10, scale: 3, comment: "pitching - total quality starts"
      t.decimal :pit_rw, precision: 10, scale: 3, comment: "pitching - total relief wins"
      t.decimal :pit_saves, precision: 10, scale: 3, comment: "pitching - total saves"
      t.decimal :pit_tbf, precision: 10, scale: 3, comment: "pitching - total batters faced"
      t.decimal :pit_whip, precision: 10, scale: 3, comment: "pitching - walks and hits per inning pitched"
      t.decimal :pit_wilds, precision: 10, scale: 3, comment: "pitching - total wild pitches"
      t.decimal :pit_wins, precision: 10, scale: 3, comment: "pitching - total wins"
      t.decimal :pit_xera, precision: 10, scale: 3, comment: "pitching - expected earned run average"
      t.decimal :pit_xfip, precision: 10, scale: 3, comment: "pitching - expected fielder independent pitching (HRs are 10.5% of Fly Balls induced)"

      # Timestamps
      t.datetime :recorded_at
      t.datetime :archived_at
      t.timestamps
    end
  end

  def down
    drop_table :stats if table_exists?(:stats)
  end
end
