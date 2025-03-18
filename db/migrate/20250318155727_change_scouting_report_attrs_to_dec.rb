class ChangeScoutingReportAttrsToDec < ActiveRecord::Migration[8.0]
  def change
    # Change string columns to decimal(10,3)
    remove_column :scouting_reports, :fastball_proj
    remove_column :scouting_reports, :sweeper_proj
    remove_column :scouting_reports, :changeup_proj
    remove_column :scouting_reports, :cutter_proj
    remove_column :scouting_reports, :control_proj
    remove_column :scouting_reports, :power_proj
    remove_column :scouting_reports, :speed_proj
    remove_column :scouting_reports, :field_proj
    remove_column :scouting_reports, :arm_proj

    add_column :scouting_reports, :fastball_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :sweeper_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :changeup_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :cutter_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :control_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :power_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :speed_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :field_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :arm_proj, :decimal, precision: 10, scale: 3
  end
end
