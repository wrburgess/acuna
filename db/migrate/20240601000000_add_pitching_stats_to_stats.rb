class AddPitchingStatsToStats < ActiveRecord::Migration[7.0]
  def change
    add_column :stats, :app, :decimal, precision: 5, scale: 0
    add_column :stats, :inn, :decimal, precision: 5, scale: 1
    add_column :stats, :gs, :decimal, precision: 5, scale: 0
    add_column :stats, :ks, :decimal, precision: 5, scale: 0
    add_column :stats, :baa, :decimal, precision: 4, scale: 3
    add_column :stats, :ha, :decimal, precision: 5, scale: 0
    add_column :stats, :hra, :decimal, precision: 5, scale: 0
    add_column :stats, :qs, :decimal, precision: 5, scale: 0
    add_column :stats, :win, :decimal, precision: 5, scale: 0
    add_column :stats, :loss, :decimal, precision: 5, scale: 0
    add_column :stats, :hd, :decimal, precision: 5, scale: 0
    add_column :stats, :saves, :decimal, precision: 5, scale: 0
    add_column :stats, :bs, :decimal, precision: 5, scale: 0
    add_column :stats, :rw, :decimal, precision: 5, scale: 0
    add_column :stats, :era, :decimal, precision: 5, scale: 2
    add_column :stats, :whip, :decimal, precision: 4, scale: 2
  end
end
