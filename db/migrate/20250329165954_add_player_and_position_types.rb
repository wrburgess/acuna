class AddPlayerAndPositionTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :player_type, :string
    add_column :stats, :holds, :decimal, precision: 10, scale: 3
    add_column :positions, :player_type, :string
  end
end
