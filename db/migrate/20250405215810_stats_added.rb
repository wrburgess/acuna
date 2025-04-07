class StatsAdded < ActiveRecord::Migration[8.0]
  def change
    add_column :stats, :bat_singles, :decimal, precision: 10, scale: 3, comment: 'batting - total singles'
    add_column :stats, :bat_barrel_pct, :decimal, precision: 10, scale: 3, comment: 'batting - barrel percentage'
    add_column :stats, :bat_hard_hit_pct, :decimal, precision: 10, scale: 3, comment: 'batting - hard hit percentage'
    add_column :stats, :bat_k_pct, :decimal, precision: 10, scale: 3, comment: 'batting - strikeout percentage'
  end
end
