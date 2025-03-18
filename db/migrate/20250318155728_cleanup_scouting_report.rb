class CleanupScoutingReport < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_reports, :slider_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :slider_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :curve_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :curve_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :command_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :command_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :fastball_type, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :tj_at, :datetime
    add_column :scouting_reports, :video_url, :string

    remove_column :scouting_reports, :speed_pres
    remove_column :scouting_reports, :speed_proj
    remove_column :scouting_reports, :field_pres
    remove_column :scouting_reports, :field_proj
    remove_column :scouting_reports, :power_pres
    remove_column :scouting_reports, :power_proj
    remove_column :scouting_reports, :pwr_pres
    remove_column :scouting_reports, :pwr_proj

    remove_column :scouting_reports, :fastball_pres
    remove_column :scouting_reports, :sweeper_pres
    remove_column :scouting_reports, :changeup_pres
    remove_column :scouting_reports, :cutter_pres
    remove_column :scouting_reports, :control_pres
    remove_column :scouting_reports, :arm_pres

    add_column :scouting_reports, :fastball_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :sweeper_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :changeup_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :cutter_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :control_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :arm_pres, :decimal, precision: 10, scale: 3
  end
end
