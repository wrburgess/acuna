module StatReset
  def self.process
    erase_all
    load_all
  end

  def self.erase_all
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE stats RESTART IDENTITY CASCADE;')
    Rails.logger.info('All stat data has been reset.')
  end

  def self.load_all
    task = Maintenance::StatsImportFangraphsTask.new
    task.file_name = 'stats_fangraphs_batting_ytd_2023.csv'
    task.timeline_abbreviation = '2023'
    task.process

    task = Maintenance::StatsImportFangraphsTask.new
    task.file_name = 'stats_fangraphs_batting_ytd_2024.csv'
    task.timeline_abbreviation = '2024'
    task.process

    task = Maintenance::StatsImportFangraphsTask.new
    task.file_name = 'stats_fangraphs_batting_ytd_2025.csv'
    task.timeline_abbreviation = '2025'
    task.process
  end
end
