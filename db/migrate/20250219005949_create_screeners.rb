class CreateScreeners < ActiveRecord::Migration[8.0]
  def change
    create_table :screeners do |t|
      t.string :name
      t.text :description
      t.integer :amount

      t.timestamps
    end
  end
end
