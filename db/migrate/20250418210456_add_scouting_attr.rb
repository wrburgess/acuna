class AddScoutingAttr < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_reports, :sits, :string
    add_column :scouting_reports, :tops, :string
    add_column :scouting_profiles, :sits, :string
    add_column :scouting_profiles, :tops, :string
  end
end
