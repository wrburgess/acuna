module DataReset
  def self.erase_all
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE players, stats, scouting_reports, scouting_profiles RESTART IDENTITY CASCADE;')
    Rails.logger.info('All variable data has been reset.')
  end
end
