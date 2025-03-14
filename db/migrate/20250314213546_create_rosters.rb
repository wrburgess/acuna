class CreateRosters < ActiveRecord::Migration[8.0]
  def change
    create_table :rosters do |t|
      t.string :name
      t.string :abbreviation

      t.timestamps
    end
  end
end
