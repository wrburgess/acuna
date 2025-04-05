class PlayerIdsAdded < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :playerid, :string
    add_column :players, :mlbamid, :string
    add_column :players, :nameascii, :string
    add_column :stats, :playerid, :string
    add_column :stats, :mlbamid, :string
    add_column :stats, :nameascii, :string
    add_column :scouting_reports, :playerid, :string
    add_column :scouting_reports, :mlbamid, :string
    add_column :scouting_reports, :nameascii, :string
    add_column :scouting_profiles, :playerid, :string
    add_column :scouting_profiles, :mlbamid, :string
    add_column :scouting_profiles, :nameascii, :string
  end
end
