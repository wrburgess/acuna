class AddMissingStats < ActiveRecord::Migration[8.0]
  def change
    add_column :stats, :errs, :decimal, precision: 10, scale: 3
    add_column :stats, :k_pct, :decimal, precision: 10, scale: 3
    add_column :stats, :war, :decimal, precision: 10, scale: 3
    add_column :stats, :nsb, :decimal, precision: 10, scale: 3
    add_column :stats, :nr, :decimal, precision: 10, scale: 3
    add_column :stats, :xbh, :decimal, precision: 10, scale: 3
    add_column :stats, :bavg, :decimal, precision: 10, scale: 3
  end
end
