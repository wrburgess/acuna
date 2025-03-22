class CreateScoutingProfileReports < ActiveRecord::Migration[8.0]
  def change
    create_table :scouting_profile_reports do |t|
      t.references :scouting_profile, null: false, foreign_key: true
      t.references :scouting_report, null: false, foreign_key: true
      t.timestamps
    end

    add_index :scouting_profile_reports, [:scouting_profile_id, :scouting_report_id], unique: true, name: 'index_scouting_profile_reports_unique'
  end
end
