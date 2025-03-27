class AddEvenMoreStats < ActiveRecord::Migration[8.0]
  def change
    add_column :stats, :holds, :decimal, precision: 10, scale: 3
    add_column :positions, :player_type, :string
  end
end
