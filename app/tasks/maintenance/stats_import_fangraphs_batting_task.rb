require 'csv'

module Maintenance
  class StatsImportFangraphsBattingTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'stats_fangraphs_batting_ytd_2025.csv'
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
            player_type: 'batter',
            active: true,
          )
        end

        # Find or initialize the stat record
        stat = player.stats.find_or_initialize_by(timeline: timeline)

        # Update stat attributes
        stat.assign_attributes(
          bat_ops: row['OPS'],
          bat_hr: row['HR'],
          bat_runs: row['R'],
          bat_rbi: row['RBI'],
          bat_sf: row['SF'],
          bat_sb: row['SB'],
          bat_cs: row['CS'],
          bat_nsb: (row['SB'].to_i - row['CS'].to_i),
          bat_pa: row['PA'],
          bat_ab: row['AB'],
          bat_avg: row['AVG'],
          bat_babip: row['BABIP'],
          bat_bb: row['BB'],
          bat_hits: row['H'],
          bat_singles: row['1B'],
          bat_doubles: row['2B'],
          bat_triples: row['3B'],
          bat_xbh: (row['2B'].to_i + row['3B'].to_i + row['HR'].to_i),
          bat_gdp: row['GDP'],
          bat_hbp: row['HBP'],
          bat_iso: row['ISO'],
          bat_k: row['SO'],
          bat_obp: row['OBP'],
          bat_slg: row['SLG'],
          bat_war: row['WAR'],
          bat_woba: row['wOBA'],
          bat_wraa: row['wRAA'],
          bat_wrc: row['wRC'],
          bat_wrc_plus: row['wRC+'],
          bat_wsb: row['wSB'],
          bat_k_pct: row['K%'],
          bat_barrel_pct: row['Barrel%'],
          bat_hard_hit_pct: row['HardHit%']
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
          bat_ops: 0,
          bat_hr: 0,
          bat_runs: 0,
          bat_rbi: 0,
          bat_sb: 0,
          bat_cs: 0,
          bat_nsb: 0,
          bat_pa: 0,
          bat_ab: 0,
          bat_avg: 0,
          bat_babip: 0,
          bat_bb: 0,
          bat_hits: 0,
          bat_singles: 0,
          bat_doubles: 0,
          bat_triples: 0,
          bat_gdp: 0,
          bat_hbp: 0,
          bat_iso: 0,
          bat_k: 0,
          bat_obp: 0,
          bat_slg: 0,
          bat_war: 0,
          bat_woba: 0,
          bat_wraa: 0,
          bat_wrc: 0,
          bat_wrc_plus: 0,
          bat_wsb: 0,
          bat_k_pct: 0,
          bat_barrel_pct: 0,
          bat_hard_hit_pct: 0
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
