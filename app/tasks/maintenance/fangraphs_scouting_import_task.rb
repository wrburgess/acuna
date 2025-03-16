require 'csv'

module Maintenance
  class FangraphsScoutingImportTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'fangraphs-the-board-scout.csv'

    def process
      # Track progress statistics
      total_processed = 0
      players_matched = 0
      players_created = 0
      scouting_reports_created = 0
      errors = 0
      unmatched_players = []

      # Get or create the default scout
      scout = Scout.find_or_create_by!(first_name: 'Eric', last_name: 'Longenhagen') do |s|
        s.company = 'Fangraphs'
      end

      Rails.logger.info("Using scout: #{scout.name} (ID: #{scout.id})")

      # Process CSV file
      Rails.logger.info("Starting import of Fangraphs scouting data from #{file_name}")
      csv_path = Rails.root.join('db', 'sources', file_name)

      unless File.exist?(csv_path)
        Rails.logger.error("Error: File not found at #{csv_path}")
        return
      end

      # Debug CSV headers and first few rows
      csv_data = CSV.read(csv_path)
      Rails.logger.info("CSV Headers: #{csv_data[0].inspect}")
      Rails.logger.info("Sample Row 1: #{csv_data[1].inspect}") if csv_data[1]
      Rails.logger.info("Sample Row 2: #{csv_data[2].inspect}") if csv_data[2]

      rows = CSV.parse(File.read(csv_path), headers: true)
      Rails.logger.info("Found #{rows.count} prospects to process")

      rows.each do |row|
        total_processed += 1

        begin
          # Log the raw row for debugging
          Rails.logger.info("Row #{total_processed}: #{row.inspect}")

          # Extract player data from row
          full_name = row['full_name'].to_s.strip
          position = row['pos'].to_s.strip
          team_name = row['team'].to_s.strip
          overall_ranking = row['overall_ranking'].to_s.strip.to_i
          team_ranking = row['team_ranking'].to_s.strip.to_i
          age = row['age'].to_s.strip.to_f
          hit_pres = row['hit_pres'].to_s.strip.to_f
          hit_proj = row['hit_proj'].to_s.strip.to_f
          pit_sel = row['pit_sel'].to_s.strip.to_f
          bat_ctrl = row['bat_ctrl'].to_s.strip.to_f
          game_pwr_pres = row['game_pwr_pres'].to_s.strip.to_f
          game_pwr_proj = row['game_pwr_proj'].to_s.strip.to_f
          raw_pwr_pres = row['raw_pwr_pres'].to_s.strip.to_f
          raw_pwr_proj = row['raw_pwr_proj'].to_s.strip.to_f
          spd_pres = row['spd_pres'].to_s.strip.to_f
          spd_proj = row['spd_proj'].to_s.strip.to_f
          fld_pres = row['fld_pres'].to_s.strip.to_f
          fld_proj = row['fld_proj'].to_s.strip.to_f
          hard_hit = row['hard_hit'].to_s.strip.to_f
          future_value = row['future_value'].to_s.strip.to_f
          fg_id = row['fg_id'].to_s.strip

          # Skip blank rows
          if full_name.blank? || future_value.zero?
            Rails.logger.info("Skipping blank row ##{total_processed}")
            next
          end

          # Split full name into first and last
          name_parts = full_name.split
          if name_parts.size < 2
            Rails.logger.error("Invalid name format: #{full_name}")
            errors += 1
            next
          end

          first_name = name_parts[0]
          last_name = name_parts[1..-1].join(' ')

          Rails.logger.info("Processing: #{first_name} #{last_name}, Team: #{team_name}, FV: #{future_value}")

          # Find team if provided
          team = nil
          if team_name.present?
            team = Team.find_by('name ILIKE ?', "%#{team_name}%")
            if team.nil?
              Rails.logger.warn("Team not found: #{team_name}")
            else
              Rails.logger.info("Team matched: #{team.name} (ID: #{team.id})")
            end
          end

          # Try to find the player first with exact match
          player = Player.find_by(fg_id: fg_id) if fg_id.present?

          # Then try by name
          if player.nil?
            # Fuzzy matching using first 5 chars of first name and first 8 chars of last name
            first_5 = first_name[0, [first_name.length, 5].min]
            last_8 = last_name[0, [last_name.length, 8].min]

            player = Player.where('first_name ILIKE ? AND last_name ILIKE ?',
                                  "#{first_5}%", "#{last_8}%").first
          end

          # Create player if not found
          if player.nil?
            Rails.logger.info("Creating new player: #{first_name} #{last_name}")
            player = Player.create!(
              first_name: first_name,
              last_name: last_name,
              position: position,
              level: nil, # Level field not directly provided in this CSV
              status: 'prospect',
              team_id: team&.id,
              fg_id: fg_id,
              age: age
            )
            players_created += 1
            Rails.logger.info("  Created player ID: #{player.id}")
          else
            Rails.logger.info("Matched: #{first_name} #{last_name} (ID: #{player.id})")
            players_matched += 1

            # Update player attributes if needed
            player.update(
              position: position.presence || player.position,
              team_id: team&.id || player.team_id,
              fg_id: fg_id.presence || player.fg_id,
              age: age.presence || player.age
            )
          end

          # Create or update scouting report
          scouting_report = ScoutingReport.find_or_initialize_by(
            scout_id: scout.id,
            player_id: player.id,
            reported_at: Date.today
          )

          scouting_report.body = "Fangraphs scouting report for #{player.name}. Future Value: #{future_value}"
          scouting_report.overall_ranking = overall_ranking if overall_ranking.positive?
          scouting_report.team_ranking = team_ranking if team_ranking.positive?
          scouting_report.future_value = future_value
          scouting_report.hit_pres = hit_pres if hit_pres.positive?
          scouting_report.hit_proj = hit_proj if hit_proj.positive?
          scouting_report.pit_sel = pit_sel if pit_sel.positive?
          scouting_report.bat_ctrl = bat_ctrl if bat_ctrl.positive?
          scouting_report.pwr_pres = game_pwr_pres if game_pwr_pres.positive?
          scouting_report.pwr_proj = game_pwr_proj if game_pwr_proj.positive?
          scouting_report.raw_pwr_pres = raw_pwr_pres if raw_pwr_pres.positive?
          scouting_report.raw_pwr_proj = raw_pwr_proj if raw_pwr_proj.positive?
          scouting_report.game_pwr_pres = game_pwr_pres if game_pwr_pres.positive?
          scouting_report.game_pwr_proj = game_pwr_proj if game_pwr_proj.positive?
          scouting_report.spd_pres = spd_pres if spd_pres.positive?
          scouting_report.spd_proj = spd_proj if spd_proj.positive?
          scouting_report.fld_pres = fld_pres if fld_pres.positive?
          scouting_report.fld_proj = fld_proj if fld_proj.positive?
          scouting_report.hard_hit = hard_hit if hard_hit.positive?

          if scouting_report.save
            scouting_reports_created += 1
            Rails.logger.info("  Success: Saved scouting report ID: #{scouting_report.id}")
          else
            Rails.logger.error("Failed to save scouting report: #{scouting_report.errors.full_messages.join(', ')}")
            errors += 1
          end
        rescue StandardError => e
          Rails.logger.error("Error processing row #{total_processed}: #{e.message}")
          Rails.logger.error("  Backtrace: #{e.backtrace.join("\n")}")
          errors += 1
        end
      end

      # Report summary
      Rails.logger.info('Import completed:')
      Rails.logger.info("  Total processed: #{total_processed}")
      Rails.logger.info("  Players matched: #{players_matched}")
      Rails.logger.info("  Players created: #{players_created}")
      Rails.logger.info("  Scouting reports created/updated: #{scouting_reports_created}")
      Rails.logger.info("  Errors: #{errors}")

      # List unmatched players
      return unless unmatched_players.any?

      Rails.logger.info("\nUnmatched players (#{unmatched_players.size}):")
      unmatched_players.each do |player|
        Rails.logger.info("  #{player[:name]}, Team: #{player[:team]}")
      end
    end
  end
end
