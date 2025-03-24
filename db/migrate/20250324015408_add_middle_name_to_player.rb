class AddMiddleNameToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :middle_name, :string
    add_column :players, :name_suffix, :text
  end
end
