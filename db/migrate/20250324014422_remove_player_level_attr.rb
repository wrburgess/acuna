class RemovePlayerLevelAttr < ActiveRecord::Migration[8.0]
  def change
    remove_column :players, :level
    remove_column :players, :status
  end
end
