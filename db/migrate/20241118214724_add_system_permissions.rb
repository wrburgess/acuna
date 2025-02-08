class AddSystemPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :system_groups, force: :cascade do |t|
      t.string :name
      t.string :abbreviation
      t.string :description
      t.text :notes
      t.timestamps
    end

    create_table :system_roles, force: :cascade do |t|
      t.string :name
      t.string :abbreviation
      t.string :description
      t.text :notes
      t.timestamps
    end

    create_table :system_permissions, force: :cascade do |t|
      t.string :name
      t.string :abbreviation
      t.string :resource
      t.string :operation
      t.string :description
      t.text :notes
      t.timestamps
    end

    create_table :system_group_users, force: :cascade do |t|
      t.references :system_group
      t.references :user
      t.timestamps
    end

    create_table :system_group_system_roles, force: :cascade do |t|
      t.references :system_group
      t.references :system_role
      t.timestamps
    end

    create_table :system_role_system_permissions, force: :cascade do |t|
      t.references :system_role
      t.references :system_permission
      t.timestamps
    end
  end
end
