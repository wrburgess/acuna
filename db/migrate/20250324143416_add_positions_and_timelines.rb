class AddPositionsAndTimelines < ActiveRecord::Migration[8.0]
  def change
    remove_column :stats, :timeline
    remove_column :scouting_reports, :timeline
    remove_column :scouting_profiles, :timeline

    create_table :positions do |t|
      t.string :name, null: false
      t.string :abbreviation
      t.string :position_type
      t.string :alternate_names, array: true, default: []
      t.string :collective_values, array: true, default: []
      t.integer :weight
      t.text :notes
      t.datetime :archived_at

      t.timestamps
    end

    create_table :timelines do |t|
      t.string :name, null: false
      t.string :abbreviation
      t.integer :weight
      t.boolean :default
      t.text :notes
      t.datetime :archived_at

      t.timestamps
    end

    add_reference :stats, :timeline, foreign_key: true
    add_reference :scouting_reports, :timeline, foreign_key: true
    add_reference :scouting_profiles, :timeline, foreign_key: true

    add_index :positions, :name
    add_index :positions, :abbreviation
    add_index :positions, :archived_at
    add_index :timelines, :name
    add_index :timelines, :abbreviation
    add_index :timelines, :archived_at
  end
end
