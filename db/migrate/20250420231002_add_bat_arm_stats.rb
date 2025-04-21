class AddBatArmStats < ActiveRecord::Migration[8.0]
  def change
    add_column :scouting_reports, :bat_arm_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_reports, :bat_arm_proj, :decimal, precision: 10, scale: 3
    add_column :scouting_profiles, :bat_arm_pres, :decimal, precision: 10, scale: 3
    add_column :scouting_profiles, :bat_arm_proj, :decimal, precision: 10, scale: 3
    add_column :stats, :bat_bb_pct, :decimal, precision: 10, scale: 3, comment: 'batting - walk percentage'
  end
end
