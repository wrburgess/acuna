class CreateScreenerOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :screener_orders do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :amount
      t.string :card_brand
      t.string :card_last4
      t.string :card_exp_month
      t.string :card_exp_year
      t.string :stripe_id

      t.timestamps
    end
  end
end
