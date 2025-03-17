class AddBaScoutingReportAttrs < ActiveRecord::Migration[8.0]
  def change
    # Check if columns exist before adding them to prevent migration errors
    add_column :scouting_reports, :future_value, :string unless column_exists?(:scouting_reports, :future_value)
    add_column :scouting_reports, :risk, :string unless column_exists?(:scouting_reports, :risk)
    add_column :scouting_reports, :fastball_proj, :string unless column_exists?(:scouting_reports, :fastball_proj)
    add_column :scouting_reports, :sweeper_proj, :string unless column_exists?(:scouting_reports, :sweeper_proj)
    add_column :scouting_reports, :changeup_proj, :string unless column_exists?(:scouting_reports, :changeup_proj)
    add_column :scouting_reports, :cutter_proj, :string unless column_exists?(:scouting_reports, :cutter_proj)
    add_column :scouting_reports, :control_proj, :string unless column_exists?(:scouting_reports, :control_proj)
    add_column :scouting_reports, :hit_proj, :string unless column_exists?(:scouting_reports, :hit_proj)
    add_column :scouting_reports, :power_proj, :string unless column_exists?(:scouting_reports, :power_proj)
    add_column :scouting_reports, :speed_proj, :string unless column_exists?(:scouting_reports, :speed_proj)
    add_column :scouting_reports, :field_proj, :string unless column_exists?(:scouting_reports, :field_proj)
    add_column :scouting_reports, :arm_proj, :string unless column_exists?(:scouting_reports, :arm_proj)
  end
end
