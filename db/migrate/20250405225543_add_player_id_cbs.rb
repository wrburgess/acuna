class AddPlayerIdCbs < ActiveRecord::Migration[8.0]
  def change
    rename_column :players, :nameascii, :fangraphs_name
    rename_column :stats, :nameascii, :fangraphs_name
    rename_column :scouting_profiles, :nameascii, :fangraphs_name
    rename_column :scouting_reports, :nameascii, :fangraphs_name
    add_column :players, :fangraphs_id, :string
    add_column :stats, :fangraphs_id, :string
    add_column :scouting_profiles, :fangraphs_id, :string
    add_column :scouting_reports, :fangraphs_id, :string
    add_column :players, :cbs_name, :string
    add_column :stats, :cbs_name, :string
    add_column :scouting_profiles, :cbs_name, :string
    add_column :scouting_reports, :cbs_name, :string
    add_column :players, :cbs_id, :string
    add_column :stats, :cbs_id, :string
    add_column :scouting_profiles, :cbs_id, :string
    add_column :scouting_reports, :cbs_id, :string
    add_column :players, :espn_name, :string
    add_column :stats, :espn_name, :string
    add_column :scouting_profiles, :espn_name, :string
    add_column :scouting_reports, :espn_name, :string
    add_column :players, :espn_id, :string
    add_column :stats, :espn_id, :string
    add_column :scouting_profiles, :espn_id, :string
    add_column :scouting_reports, :espn_id, :string
    add_column :players, :razzball_name, :string
    add_column :stats, :razzball_name, :string
    add_column :scouting_profiles, :razzball_name, :string
    add_column :scouting_reports, :razzball_name, :string
    add_column :players, :razzball_id, :string
    add_column :stats, :razzball_id, :string
    add_column :scouting_profiles, :razzball_id, :string
    add_column :scouting_reports, :razzball_id, :string
  end
end
