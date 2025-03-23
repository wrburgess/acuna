class CreateTrackingListsForPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :tracking_lists do |t|
      t.string :name, null: false
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.date :archived_at
      t.timestamps
    end

    create_table :tracking_list_players do |t|
      t.references :tracking_list, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.timestamps
    end

    add_index :tracking_list_players, [:tracking_list_id, :player_id], unique: true
  end
end
