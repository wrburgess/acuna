class AddScoutingReportAttrs < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_reports, :game_pwr_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :game_pwr_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :raw_pwr_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :raw_pwr_proj, :decimal, precision: 10, scale: 3
    add_column :players, :fg_id, :string
    add_column :players, :age, :decimal, precision: 10, scale: 3
  end
end
