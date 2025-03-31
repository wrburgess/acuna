require 'csv'
require 'i18n'

module Maintenance
  class ScoutingReportImportFangraphsScoutTask < MaintenanceTasks::Task
    no_collection

    attribute :timeline, :string, default: '2025'
    attribute :file_name, :string, default: 'fangraphs-the-board-scout.csv'

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
      Rails.logger.info("Starting import of Fangraphs scouting reports from #{file_path}")
      csv_path = Rails.root.join('db', 'sources', file_path)

      unless File.exist?(csv_path)
        Rails.logger.error("Error: File not found at #{csv_path}")
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
          full_name = sanitize_text(row['full_name'].to_s.strip)
          name_parts = split_full_name(full_name)
          first_name = name_parts[:first_name]
          last_name = name_parts[:last_name]

          # Extract other fields
          position = sanitize_text(row['pos'].to_s.strip)
          team_abbr = sanitize_text(row['team'].to_s.strip)
          overall_ranking = row['overall_ranking'].to_i
          team_ranking = row['team_ranking'].to_i
          fg_id = row['fg_id'].to_s.strip

          # Get tool grades
          hit_pres = row['hit_pres'].to_s.strip
          hit_proj = row['hit_proj'].to_s.strip
          pit_sel = row['pit_sel'].to_s.strip
          bat_ctrl = row['bat_ctrl'].to_s.strip
          game_pwr_pres = row['game_pwr_pres'].to_s.strip
          game_pwr_proj = row['game_pwr_proj'].to_s.strip
          raw_pwr_pres = row['raw_pwr_pres'].to_s.strip
          raw_pwr_proj = row['raw_pwr_proj'].to_s.strip
          spd_pres = row['spd_pres'].to_s.strip
          spd_proj = row['spd_proj'].to_s.strip
          fld_pres = row['fld_pres'].to_s.strip
          fld_proj = row['fld_proj'].to_s.strip
          hard_hit = row['hard_hit'].to_s.strip
          future_value = row['future_value'].to_s.strip

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
            timeline: timeline
          )

          # Set basic attributes
          scouting_report.overall_ranking = overall_ranking
          scouting_report.team_ranking = team_ranking if scouting_report.respond_to?(:team_ranking=)
          scouting_report.reported_at = Time.zone.now

          # Set Fangraphs-specific attributes
          scouting_report.future_value = future_value if scouting_report.respond_to?(:future_value=)

          # Set hitting tool attributes
          scouting_report.hit_pres = hit_pres if scouting_report.respond_to?(:hit_pres=)
          scouting_report.hit_proj = hit_proj if scouting_report.respond_to?(:hit_proj=)
          scouting_report.pit_sel = pit_sel if scouting_report.respond_to?(:pit_sel=)
          scouting_report.bat_ctrl = bat_ctrl if scouting_report.respond_to?(:bat_ctrl=)

          # Set power tool attributes
          scouting_report.pwr_pres = game_pwr_pres if scouting_report.respond_to?(:pwr_pres=)
          scouting_report.pwr_proj = game_pwr_proj if scouting_report.respond_to?(:pwr_proj=)
          scouting_report.power_pres = raw_pwr_pres if scouting_report.respond_to?(:power_pres=)
          scouting_report.power_proj = raw_pwr_proj if scouting_report.respond_to?(:power_proj=)

          # Set speed and fielding attributes
          scouting_report.spd_pres = spd_pres if scouting_report.respond_to?(:spd_pres=)
          scouting_report.spd_proj = spd_proj if scouting_report.respond_to?(:spd_proj=)
          scouting_report.fld_pres = fld_pres if scouting_report.respond_to?(:fld_pres=)
          scouting_report.fld_proj = fld_proj if scouting_report.respond_to?(:fld_proj=)

          # Set additional attributes
          scouting_report.hard_hit = hard_hit if scouting_report.respond_to?(:hard_hit=)

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
