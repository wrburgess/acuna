require 'csv'
require 'i18n'

module Maintenance
  class ScoutingReportImportCbsTask < MaintenanceTasks::Task
    no_collection

    attribute :timeline, :string, default: '2025'
    attribute :timeline_type, :string, default: 'preseason'
    attribute :file_name, :string, default: 'cbs_scouting_reports.csv'

    def process
      # Track progress statistics
      total_processed = 0
      players_matched = 0
      players_created = 0
      scouting_reports_created = 0
      errors = 0
      unmatched_players = []

      # Process CSV file
      file_path = "preseason_2025/#{file_name}"
      Rails.logger.info("Starting import of CBS scouting reports from #{file_path}")
      csv_path = Rails.root.join('db', 'sources', 'preseason_2025', file_path)

      unless File.exist?(csv_path)
        Rails.logger.error("Error: File not found at #{csv_path}")
        return
      end

      # Find or create scout
      scout = Scout.find_by(first_name: 'Scott', last_name: 'White')
      unless scout
        Rails.logger.error("Error: Scout 'Scott White' not found")
        return
      end

      # Process CSV file
      rows = CSV.parse(File.read(csv_path), headers: true)
      Rails.logger.info("Found #{rows.count} scouting reports to process")

      rows.each do |row|
        total_processed += 1

        begin
          # Extract player data from row and sanitize encoding
          first_name = sanitize_text(row['first_name'].to_s.strip)
          last_name = sanitize_text(row['last_name'].to_s.strip)
          position = sanitize_text(row['pos'].to_s.strip)
          team_abbr = sanitize_text(row['team'].to_s.strip)
          overall_ranking = row['overall_ranking'].to_i
          body = sanitize_text(row['body'].to_s.strip)

          # Skip blank rows
          if first_name.blank? || last_name.blank?
            Rails.logger.info("Skipping blank row ##{total_processed}")
            next
          end

          Rails.logger.info("Processing: #{first_name} #{last_name} (#{position})")

          # Find player with normalized name matching
          player = find_player_by_normalized_name(first_name, last_name)

          if player
            Rails.logger.info("Matched: #{first_name} #{last_name} (ID: #{player.id})")
            players_matched += 1
          else
            # Create new player if no match found
            player = create_player(first_name, last_name, position, team_abbr)
            Rails.logger.info("Created new player: #{first_name} #{last_name} (ID: #{player.id})")
            players_created += 1
            unmatched_players << "#{first_name} #{last_name}"
          end

          # Create or update scouting report
          scouting_report = ScoutingReport.find_or_initialize_by(
            player_id: player.id,
            scout_id: scout.id,
            timeline: timeline,
            timeline_type: timeline_type
          )

          scouting_report.overall_ranking = overall_ranking
          scouting_report.body = body
          scouting_report.reported_at = Time.zone.now

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

    def normalize_text(text)
      # First sanitize the text to fix encoding issues
      text = sanitize_text(text)
      # Then remove accents and convert to lowercase
      I18n.transliterate(text.to_s.downcase)
    end

    def find_player_by_normalized_name(first_name, last_name)
      normalized_first = normalize_text(first_name)[0..4] # First 5 chars
      normalized_last = normalize_text(last_name)[0..6]   # First 7 chars

      Player.all.find do |player|
        normalized_player_first = normalize_text(player.first_name)[0..4]
        normalized_player_last = normalize_text(player.last_name)[0..6]

        normalized_first == normalized_player_first && normalized_last == normalized_player_last
      end
    end

    def create_player(first_name, last_name, position, team_abbr)
      # Find team from abbreviation
      team = Team.find_by(abbreviation: team_abbr)

      # Use FA roster if team not found
      roster = if team
                 team.roster
               else
                 Roster.find_by(abbreviation: 'FA')
               end

      # Create the player
      player = Player.new(
        first_name: first_name,
        last_name: last_name,
        position: position,
        status: 'prospect'
      )

      # Assign to roster if found
      player.roster = roster if roster

      player.save!
      player
    end
  end
end
