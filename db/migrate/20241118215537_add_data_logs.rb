class AddDataLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :data_logs, force: :cascade do |t|
      t.references :loggable, polymorphic: true, null: false
      t.references :user
      t.string :operation
      t.jsonb :meta
      t.jsonb :original_data
      t.text :note
      t.timestamps
    end
  end
end
