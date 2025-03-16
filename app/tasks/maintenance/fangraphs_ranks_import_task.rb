require 'csv'

module Maintenance
  class FangraphsRanksImportTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'fangraphs-the-board-ranks.csv'

    def process
      # Track progress statistics
      total_processed = 0
      players_matched = 0
      players_created = 0
      scouting_reports_updated = 0
      scouting_reports_created = 0
      errors = 0
      unmatched_players = []

      # Get or create the default scout
      scout = Scout.find_or_create_by!(first_name: 'Eric', last_name: 'Longenhagen') do |s|
        s.company = 'Fangraphs'
      end

      Rails.logger.info("Using scout: #{scout.name} (ID: #{scout.id})")

      # Process CSV file
      Rails.logger.info("Starting import of Fangraphs rankings data from #{file_name}")
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
      Rails.logger.info("Found #{rows.count} ranked prospects to process")

      rows.each do |row|
        total_processed += 1

        begin
          # Log the raw row for debugging
          Rails.logger.info("Row #{total_processed}: #{row.inspect}")

          # Extract player data from row
          top_100_rank = row['Top 100'].to_s.strip
          org_rank = row['Org Rk'].to_s.strip
          full_name = row['full_name'].to_s.strip
          team_name = row['team'].to_s.strip
          position = row['pos'].to_s.strip
          current_level = row['Current Level'].to_s.strip
          eta = row['eta'].to_s.strip

          # Handle special case for future value with + notation
          raw_fv = row['FV'].to_s.strip
          future_value = if raw_fv.include?('+')
                           base = raw_fv.to_i
                           base + 1 # Convert 45+ to 46, etc.
                         else
                           raw_fv.to_f
                         end

          risk = row['risk'].to_s.strip
          trend = row['Trend'].to_s.strip
          age = row['Age'].to_s.strip.to_f
          height = row['height'].to_s.strip
          weight = row['weight'].to_s.strip.to_i
          bats = row['bats'].to_s.strip
          throws = row['throws'].to_s.strip
          sign_year = row['Sign Yr'].to_s.strip
          sign_market = row['Sign Mkt'].to_s.strip
          sign_org = row['Sign Org'].to_s.strip
          bonus = row['Bonus'].to_s.strip
          signed_from = row['Signed From'].to_s.strip
          report = row['report'].to_s.strip
          video = row['Video'].to_s.strip
          fg_id = row['fg_id'].to_s.strip

          # Skip blank rows
          if full_name.blank?
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

          # Try to find the player first with FG ID
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
              level: current_level,
              status: 'prospect',
              team_id: team&.id,
              fg_id: fg_id,
              bats: bats,
              throws: throws,
              birthdate: age.present? ? calculate_birthdate_from_age(age) : nil
            )
            players_created += 1
            Rails.logger.info("  Created player ID: #{player.id}")
          else
            Rails.logger.info("Matched: #{first_name} #{last_name} (ID: #{player.id})")
            players_matched += 1

            # Update player attributes
            player_updates = {
              position: position.presence || player.position,
              level: current_level.presence || player.level,
              team_id: team&.id || player.team_id,
              fg_id: fg_id.presence || player.fg_id
            }

            # Add physical attributes if present
            player_updates[:bats] = bats if bats.present?
            player_updates[:throws] = throws if throws.present?

            # Parse height from format like "6' 3""" to inches
            if height.present?
              inches = parse_height_to_inches(height)
              player_updates[:height] = inches if inches.positive?
            end

            # Add weight if present
            player_updates[:weight] = weight if weight.positive?

            # Update the player
            player.update(player_updates)
          end

          # Find existing scouting report for this player and scout
          scouting_report = ScoutingReport.find_by(
            scout_id: scout.id,
            player_id: player.id
          )

          if scouting_report
            # Update existing scouting report
            report_updates = {
              future_value: future_value
            }

            # Add content to body if there's a report
            report_updates[:body] = report if report.present?

            # Update overall ranking if present
            report_updates[:overall_ranking] = top_100_rank.to_i if top_100_rank.present? && top_100_rank != '0'

            # Update team ranking if present
            report_updates[:team_ranking] = org_rank.to_i if org_rank.present? && org_rank != '0'

            scouting_report.update(report_updates)
            scouting_reports_updated += 1
            Rails.logger.info("  Updated scouting report ID: #{scouting_report.id}")
          else
            # Create new scouting report
            scouting_report = ScoutingReport.new(
              scout_id: scout.id,
              player_id: player.id,
              reported_at: Date.today,
              future_value: future_value,
              body: report.presence || "Fangraphs ranking for #{player.name}. FV: #{future_value}"
            )

            # Add rankings if present
            scouting_report.overall_ranking = top_100_rank.to_i if top_100_rank.present? && top_100_rank != '0'
            scouting_report.team_ranking = org_rank.to_i if org_rank.present? && org_rank != '0'

            if scouting_report.save
              scouting_reports_created += 1
              Rails.logger.info("  Created scouting report ID: #{scouting_report.id}")
            else
              Rails.logger.error("Failed to save scouting report: #{scouting_report.errors.full_messages.join(', ')}")
              errors += 1
            end
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
      Rails.logger.info("  Scouting reports updated: #{scouting_reports_updated}")
      Rails.logger.info("  Scouting reports created: #{scouting_reports_created}")
      Rails.logger.info("  Errors: #{errors}")

      # List unmatched players
      return unless unmatched_players.any?

      Rails.logger.info("\nUnmatched players (#{unmatched_players.size}):")
      unmatched_players.each do |player|
        Rails.logger.info("  #{player[:name]}, Team: #{player[:team]}")
      end
    end

    private

    def parse_height_to_inches(height_str)
      # Parse height format like "6' 3""" to total inches
      match = height_str.match(/(\d+)'?\s*(\d+)?"?/)
      return 0 unless match

      feet = match[1].to_i
      inches = match[2].to_i

      (feet * 12) + inches
    end

    def calculate_birthdate_from_age(age)
      # Approximate birthdate based on age
      # This is rough since we don't know exact birthdate
      years = age.to_i
      months = ((age - years) * 12).to_i

      date = Date.today
      date = date.prev_year(years)
      date.prev_month(months)
    end
  end
end
