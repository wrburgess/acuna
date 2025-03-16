class AddScoutingReportTimeline < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_reports, :timeline, :string
    add_column :scouting_reports, :timeline_type, :string
  end
end
