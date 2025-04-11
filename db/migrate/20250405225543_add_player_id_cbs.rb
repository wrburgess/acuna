class AddPlayerIdCbs < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :active, :boolean
    add_column :players, :bref_id, :string
    add_column :players, :cbs_id, :string
    add_column :players, :cbs_name, :string
    add_column :players, :espn_id, :string
    add_column :players, :espn_name, :string
    add_column :players, :fangraphs_id, :string
    add_column :players, :fangraphs_name, :string
    add_column :players, :fantrax_id, :string
    add_column :players, :fantrax_name, :string
    add_column :players, :mlb_id, :string
    add_column :players, :mlb_name, :string
    add_column :players, :nfbc_id, :string
    add_column :players, :nfbc_name, :string
    add_column :players, :razzball_id, :string
    add_column :players, :razzball_name, :string
    add_column :players, :retro_id, :string
    add_column :players, :rotowire_id, :string
    add_column :players, :rotowire_name, :string
    add_column :players, :sfbb_id, :string
    add_column :players, :sfbb_name, :string
    add_column :players, :yahoo_id, :string
    add_column :players, :yahoo_name, :string
  end
end
