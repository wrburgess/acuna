require 'csv'

module Maintenance
  class SimpleRankingImportTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'keith_law_baseball_prospects_rankings.csv'

    def process
      # Track progress statistics
      total_processed = 0
      players_matched = 0
      players_created = 0
      scouting_reports_created = 0
      errors = 0
      unmatched_players = []

      # Process CSV file
      Rails.logger.info("Starting import of simple rankings from #{file_name}")
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

          # Extract player data from row and sanitize encoding
          rank = row['Rank'].to_i
          first_name = sanitize_text(row['First Name'].to_s.strip)
          last_name = sanitize_text(row['Last Name'].to_s.strip)

          # Skip blank rows
          if first_name.blank? || last_name.blank? || rank.zero?
            Rails.logger.info("Skipping blank row ##{total_processed}")
            next
          end

          Rails.logger.info("Processing rank: #{rank}, last_name: #{last_name}")

          # Only attempt exact name matching
          player = Player.find_by(first_name: first_name, last_name: last_name)

          if player
            Rails.logger.info("Matched: #{first_name} #{last_name} (ID: #{player.id})")
            players_matched += 1

            # Update player status to prospect
            player.status = 'prospect'
            player.save!

            # Determine the scout based on file name
            scout_full_name = case file_name
                              when 'keith_law_baseball_prospects_rankings.csv'
                                'Keith Law'
                              when 'mlb_prospect_rankings.csv'
                                'Jim Callis'
                              when 'baseball_america_prospect_rankings.csv'
                                'JJ Cooper'
                              when 'kiley_mcdaniel_prospect_rankings.csv'
                                'Kiley McDaniel'
                              else
                                Rails.logger.error("Unknown file name: #{file_name}")
                                next
                              end

            # Parse scout name into first and last name
            scout_name_parts = scout_full_name.split(' ', 2)
            scout_first_name = scout_name_parts[0]
            scout_last_name = scout_name_parts[1] || ''

            # Find the scout in the database by first and last name
            scout = Scout.find_by(first_name: scout_first_name, last_name: scout_last_name)
            unless scout
              Rails.logger.error("Scout not found with name: #{scout_first_name} #{scout_last_name}")
              errors += 1
              next
            end

            # Create or find scouting report for the player
            scouting_report = ScoutingReport.find_or_initialize_by(
              player_id: player.id,
              scout_id: scout.id,
              timeline: '2025'
            )
            scouting_report.reported_at = Time.zone.now
            # Only update if scouting report is new or rank changed
            if scouting_report.new_record? || scouting_report.overall_ranking != rank
              scouting_report.overall_ranking = rank

              if scouting_report.save
                scouting_reports_created += 1
                Rails.logger.info("  Success: Saved scouting report ID: #{scouting_report.id}")
              else
                Rails.logger.error("Failed to save scouting report: #{scouting_report.errors.full_messages.join(', ')}")
                errors += 1
              end
            else
              Rails.logger.info('  Skipping: Scouting report already exists with same rank')
            end
          else
            Rails.logger.info("No match found: #{first_name} #{last_name}")
            unmatched_players << { rank: rank, name: "#{first_name} #{last_name}" }
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
        Rails.logger.info("  Rank #{player[:rank]}: #{player[:name]}")
      end
    end

    private

    def sanitize_text(text)
      # Fix common encoding issues
      text = text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

      # Fix special character sequences
      text = text.gsub('‚Äô', "'")   # Fix apostrophes
      text = text.gsub('‚Äú', '"')   # Fix opening quotes
      text = text.gsub('‚Äù', '"')   # Fix closing quotes
      text = text.gsub('‚Ä¶', '...') # Fix ellipsis
      text = text.gsub('‚Äî', '-')   # Fix em dash
      text.gsub('‚Äì', '-') # Fix en dash

      # Additional replacements can be added as needed
    end
  end
end
