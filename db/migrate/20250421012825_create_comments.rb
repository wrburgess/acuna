class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :archived_at

      t.timestamps
    end
  end
end
