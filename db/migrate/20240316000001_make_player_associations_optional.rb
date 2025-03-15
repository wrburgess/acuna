class MakePlayerAssociationsOptional < ActiveRecord::Migration[8.0]
  def change
    change_column_null :players, :roster_id, true
    change_column_null :players, :team_id, true
  end
end
