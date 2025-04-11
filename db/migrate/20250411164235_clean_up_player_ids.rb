class CleanUpPlayerIds < ActiveRecord::Migration[8.0]
  def change
    remove_column :scouting_reports, :playerid, :string
    remove_column :scouting_reports, :mlbamid, :string
    remove_column :scouting_reports, :nameascii, :string
    remove_column :scouting_profiles, :playerid, :string
    remove_column :scouting_profiles, :mlbamid, :string
    remove_column :scouting_profiles, :nameascii, :string
    remove_column :stats, :playerid, :string
    remove_column :stats, :mlbam_id, :string
    remove_column :stats, :mlbamid, :string
    remove_column :stats, :nameascii, :string
    remove_column :players, :mlbamid, :string
    remove_column :players, :fg_id, :string
    remove_column :players, :nameascii, :string
    add_column :players, :bp_id, :string
    add_column :players, :mlbam_id, :string
    add_column :players, :mlbam_name, :string
    add_index :players, :bp_id, unique: true
    add_index :players, :bref_id, unique: true
    add_index :players, :cbs_id, unique: true
    add_index :players, :espn_id, unique: true
    add_index :players, :fangraphs_id, unique: true
    add_index :players, :fantrax_id, unique: true
    add_index :players, :mlb_id, unique: true
    add_index :players, :mlbam_id, unique: true
    add_index :players, :nfbc_id, unique: true
    add_index :players, :razzball_id, unique: true
    add_index :players, :retro_id, unique: true
    add_index :players, :rotowire_id, unique: true
    add_index :players, :sfbb_id, unique: true
    add_index :players, :yahoo_id, unique: true
  end
end
