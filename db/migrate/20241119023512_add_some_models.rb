class AddSomeModels < ActiveRecord::Migration[8.0]
  def change
    create_table :reports, force: :cascade do |t|
      t.string :name, null: false
      t.text :description
      t.text :sql, null: false
      t.text :staff_notes
      t.datetime :archived_at
      t.timestamps
    end
  end
end
