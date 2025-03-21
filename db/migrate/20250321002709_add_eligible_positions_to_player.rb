class AddEligiblePositionsToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :eligible_positions, :string, array: true, default: []
  end
end
