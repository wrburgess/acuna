class AddUserAttributes < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, default: nil
    add_column :users, :last_name, :string, default: nil
    add_column :users, :phone_number, :string, default: nil
    add_column :users, :title, :string, default: nil
    add_column :users, :archived_at, :datetime, default: nil
  end
end
