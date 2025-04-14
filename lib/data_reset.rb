module DataReset
  def self.process
    erase_all
    load_all
  end

  def self.erase_all
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE players, stats, scouting_reports, scouting_profiles RESTART IDENTITY CASCADE;')
    Rails.logger.info('All variable data has been reset.')
  end

  def self.load_all
    task = Maintenance::PlayersImportSfbbContextTask.new
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_prospects_2025-04.csv'
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_draft_2025-04.csv'
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_intl_2025-04.csv'
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_grads_2021-04.csv'
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_grads_2022-04.csv'
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_grads_2023-04.csv'
    task.process

    task = Maintenance::PlayersImportFangraphsContextTask.new
    task.file_name = 'players_fangraphs_grads_2025-04.csv'
    task.process

    task = Maintenance::PlayersImportCbsContextTask.new
    task.file_name = 'players_cbs_batters_2025-04.csv'
    task.process

    task = Maintenance::PlayersImportCbsContextTask.new
    task.file_name = 'players_cbs_pitchers_2025-04.csv'
    task.process
  end
end
