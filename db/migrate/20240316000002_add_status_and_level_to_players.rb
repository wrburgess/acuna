class AddStatusAndLevelToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :status, :string, comment: 'prospect, show, retired'
    add_column :players, :level, :string, comment: 'CAR, MEX, KOR, JPN, INTL, USHS, NCAA, LOW A, HIGH A, AA, AAA, MLB'

    add_index :players, :status
    add_index :players, :level
  end
end
