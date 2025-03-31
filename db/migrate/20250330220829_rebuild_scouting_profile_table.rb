class RebuildScoutingProfileTable < ActiveRecord::Migration[8.0]
  def up
    # First, find and remove all foreign key constraints pointing to stats table
    execute <<-SQL
      DO $$
      DECLARE
        r RECORD;
      BEGIN
        FOR r IN (
          SELECT conname, conrelid::regclass AS table_name
          FROM pg_constraint
          WHERE confrelid = 'scouting_profiles'::regclass
        )
        LOOP
          EXECUTE 'ALTER TABLE ' || r.table_name || ' DROP CONSTRAINT ' || r.conname;
        END LOOP;
      END
      $$;
    SQL

    # Drop the existing stats table
    drop_table :scouting_profiles if table_exists?(:scouting_profiles)

    # Create the new stats table with proper structure
    create_table :scouting_profiles do |t|
      # Meta references
      t.references :player, foreign_key: true
      t.references :timeline, foreign_key: true

      # Meta fields
      t.string :risk
      t.string :eta
      t.text :note
      t.decimal "espn_overall_rank", precision: 10, scale: 3
      t.decimal "ath_overall_rank", precision: 10, scale: 3
      t.decimal "ba_overall_rank", precision: 10, scale: 3
      t.decimal "pl_overall_rank", precision: 10, scale: 3
      t.decimal "cbs_overall_rank", precision: 10, scale: 3
      t.decimal "fg_overall_rank", precision: 10, scale: 3
      t.decimal "self_overall_rank", precision: 10, scale: 3
      t.decimal "espn_team_rank", precision: 10, scale: 3
      t.decimal "ath_team_rank", precision: 10, scale: 3
      t.decimal "ba_team_rank", precision: 10, scale: 3
      t.decimal "pl_team_rank", precision: 10, scale: 3
      t.decimal "cbs_team_rank", precision: 10, scale: 3
      t.decimal "fg_team_rank", precision: 10, scale: 3
      t.decimal "self_team_rank", precision: 10, scale: 3
      t.decimal "espn_future_value", precision: 10, scale: 3
      t.decimal "ath_future_value", precision: 10, scale: 3
      t.decimal "ba_future_value", precision: 10, scale: 3
      t.decimal "pl_future_value", precision: 10, scale: 3
      t.decimal "cbs_future_value", precision: 10, scale: 3
      t.decimal "fg_future_value", precision: 10, scale: 3
      t.decimal "self_future_value", precision: 10, scale: 3

      t.decimal "bat_hit_pres", precision: 10, scale: 3
      t.decimal "bat_hit_proj", precision: 10, scale: 3
      t.decimal "bat_game_pwr_pres", precision: 10, scale: 3
      t.decimal "bat_game_pwr_proj", precision: 10, scale: 3
      t.decimal "bat_raw_pwr_pres", precision: 10, scale: 3
      t.decimal "bat_raw_pwr_proj", precision: 10, scale: 3
      t.decimal "bat_pit_sel", precision: 10, scale: 3
      t.decimal "bat_bat_ctrl", precision: 10, scale: 3
      t.decimal "bat_hard_hit", precision: 10, scale: 3
      t.decimal "bat_spd_pres", precision: 10, scale: 3
      t.decimal "bat_spd_proj", precision: 10, scale: 3
      t.decimal "bat_fld_pres", precision: 10, scale: 3
      t.decimal "bat_fld_proj", precision: 10, scale: 3

      t.decimal "pit_control_pres", precision: 10, scale: 3
      t.decimal "pit_control_proj", precision: 10, scale: 3
      t.decimal "pit_command_pres", precision: 10, scale: 3
      t.decimal "pit_command_proj", precision: 10, scale: 3
      t.decimal "pit_fastball_pres", precision: 10, scale: 3
      t.decimal "pit_fastball_proj", precision: 10, scale: 3
      t.decimal "pit_fastball_type", precision: 10, scale: 3
      t.decimal "pit_curve_pres", precision: 10, scale: 3
      t.decimal "pit_curve_proj", precision: 10, scale: 3
      t.decimal "pit_slider_pres", precision: 10, scale: 3
      t.decimal "pit_slider_proj", precision: 10, scale: 3
      t.decimal "pit_sweeper_pres", precision: 10, scale: 3
      t.decimal "pit_sweeper_proj", precision: 10, scale: 3
      t.decimal "pit_changeup_pres", precision: 10, scale: 3
      t.decimal "pit_changeup_proj", precision: 10, scale: 3
      t.decimal "pit_cutter_pres", precision: 10, scale: 3
      t.decimal "pit_cutter_proj", precision: 10, scale: 3
      t.decimal "pit_arm_pres", precision: 10, scale: 3
      t.decimal "pit_arm_proj", precision: 10, scale: 3

      # Timestamps
      t.datetime :recorded_at
      t.datetime :archived_at
      t.timestamps
    end
  end

  def down
    drop_table :scouting_profiles if table_exists?(:scouting_profiles)
  end
end
