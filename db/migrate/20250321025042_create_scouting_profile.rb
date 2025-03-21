class CreateScoutingProfile < ActiveRecord::Migration[8.0]
  def change
    create_table :scouting_profiles do |t|
      t.timestamps
    end
  end
end
