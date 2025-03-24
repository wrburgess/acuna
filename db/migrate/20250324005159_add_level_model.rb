class AddLevelModel < ActiveRecord::Migration[8.0]
  def change
    create_table :levels do |t|
      t.string :name, null: false
      t.string :abbreviation
      t.integer :weight
      t.text :notes
      t.date :archived_at
      t.timestamps
    end

    create_table :statuses do |t|
      t.string :name, null: false
      t.string :abbreviation
      t.integer :weight
      t.text :notes
      t.date :archived_at
      t.timestamps
    end

    add_reference :players, :level, foreign_key: true
    add_reference :players, :status, foreign_key: true
  end
end
