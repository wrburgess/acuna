class AddMoreStuffToScoutingReports < ActiveRecord::Migration[8.0]
  def change
    # Add present/projection pairs for tools
    # Present values (current grades)
    add_column :scouting_reports, :fastball_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :sweeper_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :changeup_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :cutter_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :control_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :hit_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :power_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :speed_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :field_pres, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :scouting_reports, :arm_pres, :decimal, precision: 5, scale: 2, if_not_exists: true

    # Projection values (future grades)
    # Only adding ones that don't appear in the ransackable_attributes list
    add_column :scouting_reports, :hit_proj, :decimal, precision: 5, scale: 2, if_not_exists: true

    # Add timeline and timeline_type fields for categorization
    add_column :scouting_reports, :timeline, :string, if_not_exists: true
    add_column :scouting_reports, :timeline_type, :string, if_not_exists: true

    # Add body field for additional notes
    add_column :scouting_reports, :body, :text, if_not_exists: true

    # Add index for better query performance
    add_index :scouting_reports, [:player_id, :scout_id, :timeline, :timeline_type],
              name: 'index_scouting_reports_on_player_scout_and_timeline',
              unique: true,
              if_not_exists: true
  end
end
