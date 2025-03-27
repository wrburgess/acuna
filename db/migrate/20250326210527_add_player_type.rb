class AddPlayerType < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :player_type, :string
  end
end
