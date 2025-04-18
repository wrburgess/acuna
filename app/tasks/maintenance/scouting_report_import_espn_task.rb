require 'csv'
require 'i18n'

module Maintenance
  class ScoutingReportImportEspnTask < MaintenanceTasks::Task
    no_collection

    attribute :timeline_abbrev, :string, default: '2025'
    attribute :file_name, :string, default: 'espn_scouting_reports.csv'

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
      Rails.logger.info("Starting import of CBS scouting reports from #{file_path}")

      unless File.exist?(file_path)
        Rails.logger.error("Error: File not found at #{file_path}")
        return
      end

      # Retrieve timeline
      timeline = Timeline.find_by(abbreviation: timeline_abbrev)
      unless timeline
        Rails.logger.error('Error: Timeline not found')
        return
      end

      # Find Kiley McDaniel scout
      scout = Scout.find_by(first_name: 'Kiley', last_name: 'McDaniel')
      unless scout
        Rails.logger.error("Error: Scout 'Kiley McDaniel' not found")
        return
      end

      # Process CSV file
      rows = CSV.parse(File.read(file_path), headers: true)
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

          # Extract and split attributes with present/future values
          future_value = row['future_value'].to_s.strip

          # Process fields with present/projection pattern (60/70)
          fastball_values = split_projection(row['fastball_proj'].to_s.strip)
          sweeper_values = split_projection(row['sweeper_proj'].to_s.strip)
          changeup_values = split_projection(row['changeup_proj'].to_s.strip)
          cutter_values = split_projection(row['cutter_proj'].to_s.strip)
          control_values = split_projection(row['control_proj'].to_s.strip)
          hit_values = split_projection(row['hit_proj'].to_s.strip)
          power_values = split_projection(row['power_proj'].to_s.strip)
          speed_values = split_projection(row['speed_proj'].to_s.strip)
          field_values = split_projection(row['field_proj'].to_s.strip)
          arm_values = split_projection(row['arm_proj'].to_s.strip)

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
          )

          # Set basic attributes
          scouting_report.overall_ranking = overall_ranking
          scouting_report.body = body
          scouting_report.reported_at = Time.zone.now
          scouting_report.future_value = future_value if scouting_report.respond_to?(:future_value=)

          # Set projection attributes
          scouting_report.fastball_pres = fastball_values[:present] if scouting_report.respond_to?(:fastball_pres=)
          scouting_report.fastball_proj = fastball_values[:projection] if scouting_report.respond_to?(:fastball_proj=)

          scouting_report.sweeper_pres = sweeper_values[:present] if scouting_report.respond_to?(:sweeper_pres=)
          scouting_report.sweeper_proj = sweeper_values[:projection] if scouting_report.respond_to?(:sweeper_proj=)

          scouting_report.changeup_pres = changeup_values[:present] if scouting_report.respond_to?(:changeup_pres=)
          scouting_report.changeup_proj = changeup_values[:projection] if scouting_report.respond_to?(:changeup_proj=)

          scouting_report.cutter_pres = cutter_values[:present] if scouting_report.respond_to?(:cutter_pres=)
          scouting_report.cutter_proj = cutter_values[:projection] if scouting_report.respond_to?(:cutter_proj=)

          scouting_report.control_pres = control_values[:present] if scouting_report.respond_to?(:control_pres=)
          scouting_report.control_proj = control_values[:projection] if scouting_report.respond_to?(:control_proj=)

          scouting_report.hit_pres = hit_values[:present] if scouting_report.respond_to?(:hit_pres=)
          scouting_report.hit_proj = hit_values[:projection] if scouting_report.respond_to?(:hit_proj=)

          scouting_report.power_pres = power_values[:present] if scouting_report.respond_to?(:power_pres=)
          scouting_report.power_proj = power_values[:projection] if scouting_report.respond_to?(:power_proj=)

          scouting_report.speed_pres = speed_values[:present] if scouting_report.respond_to?(:speed_pres=)
          scouting_report.speed_proj = speed_values[:projection] if scouting_report.respond_to?(:speed_proj=)

          scouting_report.field_pres = field_values[:present] if scouting_report.respond_to?(:field_pres=)
          scouting_report.field_proj = field_values[:projection] if scouting_report.respond_to?(:field_proj=)

          scouting_report.arm_pres = arm_values[:present] if scouting_report.respond_to?(:arm_pres=)
          scouting_report.arm_proj = arm_values[:projection] if scouting_report.respond_to?(:arm_proj=)

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

    def split_projection(value)
      return { present: nil, projection: nil } if value.blank?

      if value.include?('/')
        parts = value.split('/')
        { present: parts[0].strip, projection: parts[1].strip }
      else
        # If there's no split, use the value for both
        { present: value, projection: value }
      end
    end

    def sanitize_text(text)
      return '' if text.nil?

      # Fix common encoding issues
      text = text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

      # Fix special character sequences
      text = text.gsub('‚Äô', "'")   # Fix apostrophes
      text = text.gsub('‚Äú', '"')   # Fix opening quotes
      text = text.gsub('‚Äù', '"')   # Fix closing quotes
      text = text.gsub('‚Ä¶', '...') # Fix ellipsis
      text = text.gsub('‚Äî', '-')   # Fix em dash
      text = text.gsub('‚Äì', '-')   # Fix en dash

      # Additional replacements for common problematic characters
      text = text.gsub('Ã±', 'ñ')     # Fix Spanish n with tilde
      text = text.gsub('Ã¡', 'á')     # Fix a with accent
      text = text.gsub('Ã©', 'é')     # Fix e with accent
      text = text.gsub('Ã­', 'í')     # Fix i with accent
      text = text.gsub('Ã³', 'ó')     # Fix o with accent
      text.gsub('Ãº', 'ú') # Fix u with accent
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
      roster = Roster.find_by(abbreviation: 'FA')

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
