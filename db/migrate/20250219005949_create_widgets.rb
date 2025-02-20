class CreateWidgets < ActiveRecord::Migration[8.0]
  def change
    create_table :widgets do |t|
      t.string :name
      t.text :description
      t.integer :default_amount
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
    end
  end
end
