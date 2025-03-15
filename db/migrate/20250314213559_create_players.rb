class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :abbreviation
      t.text :notes
      t.datetime :archived_at

      t.timestamps
    end

    create_table :rosters do |t|
      t.string :name
      t.string :abbreviation
      t.text :notes
      t.datetime :archived_at

      t.timestamps
    end

    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :position
      t.date :birthdate
      t.references :roster, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.text :notes
      t.datetime :archived_at

      t.timestamps
    end
  end
end
