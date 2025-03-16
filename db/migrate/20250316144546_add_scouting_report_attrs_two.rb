class AddScoutingReportAttrsTwo < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_reports, :risk, :string
    add_column :scouting_reports, :eta, :string
    add_column :players, :height, :string
    add_column :players, :weight, :string
    add_column :players, :bats, :string
    add_column :players, :throws, :string
  end
end
