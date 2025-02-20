class AddLabelModel < ActiveRecord::Migration[8.0]
  def change
    create_table :labels, id: false, force: :cascade do |t|
      t.bigint :id, null: false, primary_key: true
      t.string :name
      t.timestamps
    end

    add_index :labels, :id, unique: true

    drop_table :titles, if_exists: true

    create_table :titles, id: false, force: :cascade do |t|
      t.bigint :id, null: false, primary_key: true
      t.references :labels, null: false, foreign_key: true
      t.string :name
      t.boolean :screening_requests_accepted
      t.timestamps
    end

    add_index :titles, :id, unique: true
  end
end
