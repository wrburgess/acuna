class CreateScreenerOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :screener_order_items do |t|
      t.belongs_to :screener, null: false, foreign_key: true
      t.belongs_to :screener_order, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
