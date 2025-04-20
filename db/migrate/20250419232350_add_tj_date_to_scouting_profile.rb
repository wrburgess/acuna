class AddTjDateToScoutingProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_profiles, :tj_at, :datetime
  end
end
