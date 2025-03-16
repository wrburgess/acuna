class AllowNullScoutingReportBody < ActiveRecord::Migration[7.1]
  def up
    change_column_null :scouting_reports, :body, true
  end

  def down
    change_column_null :scouting_reports, :body, false
  end
end
