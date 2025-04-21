class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :archived_at

      t.timestamps
    end

    add_index :comments, [:commentable_type, :commentable_id]
  end
end
