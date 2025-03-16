class AddReports < ActiveRecord::Migration[7.0]
  def change
    create_table :scouts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :company
      t.date :archived_at

      t.timestamps
    end

    create_table :scouting_reports do |t|
      t.references :scout, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.date :reported_at, null: false
      t.text :body, null: false
      t.integer :overall_ranking, precision: 10, scale: 3
      t.integer :team_ranking, precision: 10, scale: 3
      t.decimal :future_value, precision: 10, scale: 3
      t.decimal :hit_pres, precision: 10, scale: 3
      t.decimal :hit_proj, precision: 10, scale: 3
      t.decimal :pwr_pres, precision: 10, scale: 3
      t.decimal :pwr_proj, precision: 10, scale: 3
      t.decimal :pit_sel, precision: 10, scale: 3
      t.decimal :bat_ctrl, precision: 10, scale: 3
      t.decimal :spd_pres, precision: 10, scale: 3
      t.decimal :spd_proj, precision: 10, scale: 3
      t.decimal :fld_pres, precision: 10, scale: 3
      t.decimal :fld_proj, precision: 10, scale: 3
      t.decimal :hard_hit, precision: 10, scale: 3
      t.date :archived_at

      t.timestamps
    end

    add_index :scouts, [:first_name, :last_name]
  end
end
