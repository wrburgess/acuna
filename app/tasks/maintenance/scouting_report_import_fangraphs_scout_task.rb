require 'csv'
require 'i18n'

module Maintenance
  class ScoutingReportImportFangraphsScoutTask < MaintenanceTasks::Task
    no_collection

    attribute :timeline_abbrev, :string, default: '2025'
    attribute :file_name, :string, default: 'fangraphs_scouting_reports_batters.csv'

    def process
      # Track progress statistics
      total_processed = 0
      players_matched = 0
      players_created = 0
      scouting_reports_created = 0
      errors = 0
      unmatched_players = []

      # Process CSV file
      file_path = Rails.root.join('db', 'sources', 'scouting_reports', file_name)
      Rails.logger.info("Starting import of Fangraphs scouting reports from #{file_path}")
      csv_path = Rails.root.join('db', 'sources', file_path)

      unless File.exist?(csv_path)
        Rails.logger.error("Error: File not found at #{csv_path}")
        return
      end

      # Retrieve timeline
      timeline = Timeline.find_by(abbreviation: timeline_abbrev)
      unless timeline
        Rails.logger.error('Error: Timeline not found')
        return
      end

      # Find Eric Longenhagen scout
      scout = Scout.find_by(first_name: 'Eric', last_name: 'Longenhagen')
      unless scout
        Rails.logger.error("Error: Scout 'Eric Longenhagen' not found")
        return
      end

      # Process CSV file
      rows = CSV.parse(File.read(csv_path), headers: true)
      Rails.logger.info("Found #{rows.count} scouting reports to process")

      rows.each do |row|
        total_processed += 1

        begin
          # Extract player full name and split into first/last
          full_name = row['Name']
          first_name = full_name.split(' ').first
          last_name = full_name.split(' ')[1..].join(' ')

          # Extract other fields
          position = row['Pos'].to_s.strip
          team_abbr = row['Org'].to_s.strip
          overall_ranking = row['Top 100'].to_i
          team_ranking = row['Org Rk'].to_i
          fangraphs_id = row['PlayerId'].to_s.strip

          # Get tool grades
          hit_pres = row['Hit']&.split('/')&.first.to_s.strip
          hit_proj = row['Hit']&.split('/')&.last.to_s.strip
          pit_sel = row['Pitch Sel'].to_s.strip
          bat_ctrl = row['Bat Ctrl'].to_s.strip
          game_pwr_pres = row['Game Pwr']&.split('/')&.first.to_s.strip
          game_pwr_proj = row['Game Pwr']&.split('/')&.last.to_s.strip
          raw_pwr_pres = row['Raw Pwr']&.split('/')&.first.to_s.strip
          raw_pwr_proj = row['Raw Pwr']&.split('/')&.last.to_s.strip
          spd_pres = row['Spd']&.split('/')&.first.to_s.strip
          spd_proj = row['Spd']&.split('/')&.last.to_s.strip
          fld_pres = row['Fld']&.split('/')&.first.to_s.strip
          fld_proj = row['Fld']&.split('/')&.last.to_s.strip
          hard_hit = row['Hard Hit%'].to_s.strip

          sits = row['Sits'].to_s.strip
          tops = row['Tops'].to_s.strip
          fastball_pres = row['FB']&.split('/')&.first.to_s.strip
          fastball_proj = row['FB']&.split('/')&.last.to_s.strip
          slider_pres = row['SL']&.split('/')&.first.to_s.strip
          slider_proj = row['SL']&.split('/')&.last.to_s.strip
          changeup_pres = row['CH']&.split('/')&.first.to_s.strip
          changeup_proj = row['CH']&.split('/')&.last.to_s.strip
          curveball_pres = row['CB']&.split('/')&.first.to_s.strip
          curveball_proj = row['CB']&.split('/')&.last.to_s.strip
          command_pres = row['CMD']&.split('/')&.first.to_s.strip
          command_proj = row['CMD']&.split('/')&.last.to_s.strip

          future_value = row['FV'].to_s.strip

          Rails.logger.info("Processing: #{first_name} #{last_name} (#{position})")

          # Find player with normalized name matching
          player = Player.find_by(fangraphs_name: full_name) || Player.find_by(fangraphs_id: fangraphs_id)

          if player
            Rails.logger.info("Matched: #{first_name} #{last_name} (ID: #{player.id})")
            players_matched += 1
          else
            # Create new player if no match found
            player = Player.create(
              first_name:,
              last_name:,
              position:,
              fangraphs_id:,
              fangraphs_name: full_name
            )
            Rails.logger.info("Created new player: #{first_name} #{last_name} (ID: #{player.id})")
            players_created += 1
            unmatched_players << "#{first_name} #{last_name}"
          end

          # Create or update scouting report
          scouting_report = ScoutingReport.find_or_initialize_by(
            player_id: player.id,
            scout_id: scout.id,
            timeline: timeline,
            reported_at: Time.zone.now,
            overall_ranking:,
            team_ranking:,
            hit_pres:,
            hit_proj:,
            pit_sel:,
            bat_ctrl:,
            game_pwr_pres:,
            game_pwr_proj:,
            raw_pwr_pres:,
            raw_pwr_proj:,
            spd_pres:,
            spd_proj:,
            fld_pres:,
            fld_proj:,
            hard_hit:,
            future_value:,
            sits:,
            tops:
          )

          if scouting_report.save
            scouting_reports_created += 1
            Rails.logger.info("Created scouting report ID: #{scouting_report.id}")
          else
            errors += 1
            Rails.logger.error("Failed to save scouting report: #{scouting_report.errors.full_messages.join(', ')}")
          end
        rescue StandardError => e
          Rails.logger.error("Error processing row #{total_processed}: #{e.message}")
          Rails.logger.error(e.backtrace.join("\n"))
          errors += 1
        end
      end

      # Report summary
      Rails.logger.info('Import completed:')
      Rails.logger.info("  Total processed: #{total_processed}")
      Rails.logger.info("  Players matched: #{players_matched}")
      Rails.logger.info("  Players created: #{players_created}")
      Rails.logger.info("  Scouting reports created: #{scouting_reports_created}")
      Rails.logger.info("  Errors: #{errors}")

      # List unmatched/new players
      return unless unmatched_players.any?

      Rails.logger.info("\nNew players created (#{unmatched_players.size}):")
      unmatched_players.each do |player_name|
        Rails.logger.info("  #{player_name}")
      end
    end

    private

    def split_full_name(full_name)
      return { first_name: '', last_name: '' } if full_name.blank?

      # Handle Jr, Sr, III suffixes
      suffixes = [' Jr.', ' Sr.', ' II', ' III', ' IV', ' V']
      suffix = ''

      suffixes.each do |s|
        next unless full_name.include?(s)

        suffix = s
        full_name = full_name.gsub(s, '')
        break
      end

      parts = full_name.strip.split(' ')

      if parts.size == 1
        { first_name: parts[0], last_name: '' }
      elsif parts.size == 2
        { first_name: parts[0], last_name: parts[1] + suffix }
      else
        # Assume first name is the first part, and last name is all remaining parts
        { first_name: parts[0], last_name: parts[1..-1].join(' ') + suffix }
      end
    end
  end
end
