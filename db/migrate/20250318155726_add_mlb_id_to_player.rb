class AddMlbIdToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :stats, :mlbam_id, :string
    add_column :stats, :pa, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :bb_pct, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :bb_pct, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :bb_k, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :avg, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :abp, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :slg, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :ops, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :iso, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :babip, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :wsb, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :wrc, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :wraa, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :woba, :decimal, precision: 5, scale: 2, if_not_exists: true
    add_column :stats, :wrc_plus, :decimal, precision: 5, scale: 2, if_not_exists: true
  end
end
