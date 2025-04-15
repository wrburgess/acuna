require 'csv'

module Maintenance
  class StatsImportFangraphsPitchingTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'stats_fangraphs_pitching_ytd_2025.csv'
    attribute :timeline_abbreviation, :string, default: '2025'

    def process
      file_path = Rails.root.join('db', 'sources', 'stats', file_name)
      raise "File not found: #{file_path}" unless File.exist?(file_path)

      # Load the CSV file
      rows = CSV.read(file_path, headers: true, encoding: 'bom|utf-8')

      # Retrieve the Timeline record
      timeline = Timeline.find_by(abbreviation: timeline_abbreviation)
      raise "Timeline with abbreviation '#{timeline_abbreviation}' not found" unless timeline

      # Track progress
      total_created = 0
      total_updated = 0
      total_blank_created = 0
      unmatched_players = []

      # Process each row in the file
      rows.each_with_index do |row, _|
        # Map player attributes
        fangraphs_name = row['NameASCII'].to_s.strip
        fangraphs_id = row['PlayerId'].to_s.strip
        mlbam_id = row['MLBAMID'].to_s.strip
        name = row['Name'].to_s.strip

        player = Player.find_by(fangraphs_id: fangraphs_id) ||
                 Player.find_by(mlbam_id: mlbam_id) ||
                 Player.find_by(fangraphs_name: fangraphs_name)

        unless player
          unmatched_players << { name: name, fangraphs_name: fangraphs_name, fangraphs_id: fangraphs_id, mlbam_id: mlbam_id }
          player = Player.create(
            first_name: row['NameASCII'].split(' ').first,
            last_name: row['NameASCII'].split(' ').drop(1).join(' '),
            mlbam_id: row['MLBAMID'],
            fangraphs_id: row['PlayerId'],
            fangraphs_name: row['NameASCII'],
            player_type: 'pitcher',
            active: true,
          )
        end

        # Find or initialize the stat record
        stat = player.stats.find_or_initialize_by(timeline: timeline)

        # Update stat attributes
        stat.assign_attributes(
          pit_qs: row['QS'],
          pit_k_9: row['K/9'],
          pit_era: row['ERA'],
          pit_whip: row['WHIP'],
          pit_saves: row['SV'],
          pit_holds: row['HLD'],
          pit_bs: row['BS'],
          pit_war: row['WAR'],
          pit_games: row['G'],
          pit_inn: row['IP'],
          pit_gs: row['GS'],
          pit_cg: row['CG'],
          pit_tbf: row['TBF'],
          pit_wins: row['W'],
          pit_losses: row['L'],
          pit_ha: row['H'],
          pit_runs: row['R'],
          pit_earned_runs: row['ER'],
          pit_xera: row['xERA'],
          pit_baa: row['AVG'],
          pit_babip: row['BABIP'],
          pit_ks: row['SO'],
          pit_k_pct: row['K%'],
          pit_k_bb_ratio: row['K/BB'],
          pit_k_bb_pct_diff: row['K-BB%'],
          pit_bb: row['BB'],
          pit_ibb: row['IBB'],
          pit_hbp: row['HBP'],
          pit_bb_9: row['BB/9'],
          pit_bb_pct: row['BB%'],
          pit_fip: row['FIP'],
          pit_xfip: row['xFIP'],
          pit_gb_pct: row['GB%'],
          pit_hra: row['HR'],
          pit_hr_9: row['HR/9'],
          pit_lob_pct: row['LOB%'],
          pit_balks: row['BK'],
          pit_wilds: row['WP'],
          pit_shutouts: row['ShO'],
          pit_pitches: row['Pitches'],
          pit_balls: row['Balls'],
          pit_strikes: row['Strikes']
        )

        if stat.new_record?
          total_created += 1
        else
          total_updated += 1
        end

        stat.save!
      end

      # Create blank stats for players without records
      Player.where.not(id: Stat.where(timeline: timeline).select(:player_id)).find_each do |player|
        player.stats.create!(
          timeline: timeline,
          pit_qs: 0,
          pit_k_9: 0,
          pit_era: 0,
          pit_whip: 0,
          pit_saves: 0,
          pit_holds: 0,
          pit_bs: 0,
          pit_war: 0,
          pit_games: 0,
          pit_inn: 0,
          pit_gs: 0,
          pit_cg: 0,
          pit_tbf: 0,
          pit_wins: 0,
          pit_losses: 0,
          pit_ha: 0,
          pit_runs: 0,
          pit_earned_runs: 0,
          pit_xera: 0,
          pit_baa: 0,
          pit_babip: 0,
          pit_ks: 0,
          pit_k_pct: 0,
          pit_k_bb_ratio: 0,
          pit_k_bb_pct_diff: 0,
          pit_bb: 0,
          pit_ibb: 0,
          pit_hbp: 0,
          pit_bb_9: 0,
          pit_bb_pct: 0,
          pit_fip: 0,
          pit_xfip: 0,
          pit_gb_pct: 0,
          pit_hra: 0,
          pit_hr_9: 0,
          pit_lob_pct: 0,
          pit_balks: 0,
          pit_wilds: 0,
          pit_shutouts: 0,
          pit_pitches: 0,
          pit_balls: 0,
          pit_strikes: 0
        )

        total_blank_created += 1
      end

      # Log unmatched players
      Rails.logger.info("Unmatched players: #{unmatched_players.size}")
      unmatched_players.each do |unmatched|
        Rails.logger.info("  Name: #{unmatched[:name]}, FangraphsName: #{unmatched[:fangraphs_name]}, fangraphs_id: #{unmatched[:fangraphs_id]}, MLBAM_ID: #{unmatched[:mlbam_id]}")
      end

      # Log results
      Rails.logger.info('Stats import completed:')
      Rails.logger.info("  Created: #{total_created}")
      Rails.logger.info("  Updated: #{total_updated}")
      Rails.logger.info("  Blank stats created: #{total_blank_created}")
    end
  end
end
