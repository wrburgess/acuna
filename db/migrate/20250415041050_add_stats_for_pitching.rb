class AddStatsForPitching < ActiveRecord::Migration[8.0]
  def change
    add_column :stats, :pit_games, :decimal, precision: 10, scale: 3, comment: "pitching - total games"
    add_column :stats, :pit_runs, :decimal, precision: 10, scale: 3, comment: "pitching - total runs against"
    add_column :stats, :pit_earned_runs, :decimal, precision: 10, scale: 3, comment: "pitching - total earned runs against"
    add_column :stats, :pit_pitches, :decimal, precision: 10, scale: 3, comment: "pitching - total pitches thrown"
    add_column :stats, :pit_balls, :decimal, precision: 10, scale: 3, comment: "pitching - total balls thrown"
    add_column :stats, :pit_strikes, :decimal, precision: 10, scale: 3, comment: "pitching - total strikes thrown"
    add_column :stats, :pit_war, :decimal, precision: 10, scale: 3, comment: "pitching - wins above replacement"
    add_column :stats, :pit_hbp, :decimal, precision: 10, scale: 3, comment: "pitching - total hit by pitch"
    add_column :stats, :pit_shutouts, :decimal, precision: 10, scale: 3, comment: "pitching - total shutouts"
  end
end
