class AddPitchingStats < ActiveRecord::Migration[8.0]
  def change
    add_column :stats, :k_9, :decimal, precision: 10, scale: 3
    add_column :stats, :bb_9, :decimal, precision: 10, scale: 3
    add_column :stats, :hr_9, :decimal, precision: 10, scale: 3
    add_column :stats, :lob_pct, :decimal, precision: 10, scale: 3
    add_column :stats, :gb_pct, :decimal, precision: 10, scale: 3
    add_column :stats, :fip, :decimal, precision: 10, scale: 3
    add_column :stats, :xfip, :decimal, precision: 10, scale: 3
    add_column :stats, :hbatter, :decimal, precision: 10, scale: 3
    add_column :stats, :ibb, :decimal, precision: 10, scale: 3
    add_column :stats, :tbf, :decimal, precision: 10, scale: 3
    add_column :stats, :blk, :decimal, precision: 10, scale: 3
    add_column :stats, :wp, :decimal, precision: 10, scale: 3
    add_column :stats, :k_bb_pct, :decimal, precision: 10, scale: 3
    add_column :stats, :k_bb_ratio, :decimal, precision: 10, scale: 3
  end
end
