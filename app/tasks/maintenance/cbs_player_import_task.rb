require 'csv'

module Maintenance
  class CbsPlayerImportTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string

    def process
      # Load reference data
      valid_positions = load_valid_positions
      mlb_teams_map = load_mlb_teams_map

      # Load rosters by name and find the FA roster
      rosters = Roster.all.index_by(&:name)
      fa_roster = Roster.find_by(abbreviation: 'FA')

      Rails.logger.info("WARNING: No roster with abbreviation 'FA' found. Free agents will not be assigned to any roster.") if fa_roster.nil?

      # Track progress
      total_processed = 0
      total_imported = 0
      skipped_records = 0

      # Add counters for better diagnostics
      unparseable_records = 0
      invalid_position_records = 0
      no_team_records = 0
      validation_error_records = 0

      # Process CSV file
      rows = CSV.read(Rails.root.join('db', 'sources', file_name))

      # Skip first row completely
      rows.shift

      # Second row contains headers - remove nil values before stripping
      headers = rows.shift.compact.map(&:strip)

      # Find column indices
      player_index = headers.index('Player')
      avail_index = headers.index('Avail')

      # Check if required headers exist
      if player_index.nil? || avail_index.nil?
        Rails.logger.info('Error: Required headers not found in CSV file')
        Rails.logger.info("Headers found: #{headers.join(', ')}")
        Rails.logger.info("Missing: #{'Player' if player_index.nil?} #{'Avail' if avail_index.nil?}")
        return
      end

      rows.each do |row|
        total_processed += 1

        # Skip row if it only has a single value in the first column and others are empty
        non_empty_values = row.compact.reject(&:blank?).size
        if non_empty_values <= 1 && row[0].to_s.present?
          Rails.logger.info("Skipping summary row: #{row[0]}")
          skipped_records += 1
          next
        end

        # Ensure row has enough columns
        if row.size <= [player_index, avail_index].max
          Rails.logger.info("Row #{total_processed} has insufficient columns (#{row.size}), skipping")
          skipped_records += 1
          next
        end

        player_info = row[player_index].to_s.strip
        avail_info = row[avail_index].to_s.strip

        # Skip if player info is blank
        next if player_info.blank?

        # Parse player information with a more flexible regex that can handle multiple positions
        # Example: "Ronald Acuña Jr. 2B,3B,CF | ATL"
        if player_info.match(%r{^(\S+)\s+(.*?)(?:\s+([A-Z0-9/,-]{1,15}))?\s*\|\s*([A-Z]{1,3})$})
          first_name = ::Regexp.last_match(1).strip
          last_name = ::Regexp.last_match(2).strip
          position_string = ::Regexp.last_match(3).to_s.strip
          mlb_code = ::Regexp.last_match(4).strip

          # Handle multiple positions (comma-separated)
          position_codes = position_string.split(',').map(&:strip)

          # Validate positions - check if ANY position is valid
          valid_position_found = false
          valid_position_codes = []

          position_codes.each do |pos|
            if valid_positions.include?(pos)
              valid_position_found = true
              valid_position_codes << pos
            else
              Rails.logger.info("Skipping invalid position '#{pos}' for player #{player_info}")
            end
          end

          # If no valid positions were found, use utility as fallback
          if !valid_position_found || valid_position_codes.empty?
            Rails.logger.info("No valid positions found for player #{player_info}, assigning default position")
            position_code = 'U' # Set to Utility as fallback
            invalid_position_records += 1
          else
            # Use all valid positions as a comma-separated string
            position_code = valid_position_codes.join(',')
          end

          # Find associated team - try alternate abbreviation if first lookup fails
          team = nil
          if mlb_teams_map[mlb_code]
            team = Team.find_by(id: mlb_teams_map[mlb_code])
          else
            # Try to find team by direct lookup
            team = Team.find_by(abbreviation: mlb_code)
            Rails.logger.info("Found team by direct lookup: #{team&.name}") if team
          end

          if team.nil?
            Rails.logger.info("Could not find team for MLB code: #{mlb_code}, player: #{player_info}")
            no_team_records += 1
          end

          # Check if player already exists
          player = Player.find_by(first_name: first_name, last_name: last_name)

          if player
            Rails.logger.info("Updating existing player: #{first_name} #{last_name} with position(s): #{position_code}")
            player.position = position_code
            player.team = team if team
          else
            Rails.logger.info("Creating new player: #{first_name} #{last_name} with position(s): #{position_code}")
            player = Player.new(
              first_name: first_name,
              last_name: last_name,
              position: position_code,
              team: team
            )
          end

          # Associate with roster - handle FA case separately
          if avail_info == 'FA'
            if fa_roster
              player.roster = fa_roster
              Rails.logger.info('  Assigned to Free Agent roster')
            else
              Rails.logger.info('  Player is a Free Agent but no FA roster exists')
            end
          elsif rosters[avail_info]
            player.roster = rosters[avail_info]
            Rails.logger.info("  Assigned to roster: #{avail_info}")
          else
            Rails.logger.info("  No matching roster found for: #{avail_info}")
          end

          # Save the player
          if player.save
            total_imported += 1
          else
            Rails.logger.info("Failed to save player #{player_info}: #{player.errors.full_messages.join(', ')}")
            validation_error_records += 1
            skipped_records += 1
          end
        else
          Rails.logger.info("Could not parse player info: #{player_info}")
          unparseable_records += 1
          skipped_records += 1
        end
      end

      # Provide detailed stats at the end
      Rails.logger.info('Import completed:')
      Rails.logger.info("  Processed: #{total_processed}")
      Rails.logger.info("  Imported: #{total_imported}")
      Rails.logger.info("  Skipped: #{skipped_records}")
      Rails.logger.info('  Details of skipped records:')
      Rails.logger.info("    Unparseable format: #{unparseable_records}")
      Rails.logger.info("    Invalid position: #{invalid_position_records}")
      Rails.logger.info("    No team found: #{no_team_records}")
      Rails.logger.info("    Validation errors: #{validation_error_records}")
    end

    private

    def load_valid_positions
      positions_file = Rails.root.join('db', 'sources', 'ppmlb_fantasy_baseball_positions.csv')
      positions = []

      CSV.foreach(positions_file, headers: true) do |row|
        positions << row['Position'] if row['Position'] # Use 'Position' instead of 'code'
      end

      positions
    end

    def load_mlb_teams_map
      teams_file = Rails.root.join('db', 'sources', 'mlb_teams.csv')
      mlb_teams = {}

      # Find teams in the database first
      db_teams = Team.all.index_by(&:abbreviation)

      # Create a map of all possible abbreviations to team IDs
      CSV.foreach(teams_file, headers: true) do |row|
        abbreviation = row['Abbreviation']
        alt_abbreviation = row['Alt Abbreviation']

        if abbreviation && db_teams[abbreviation]
          mlb_teams[abbreviation] = db_teams[abbreviation].id

          # Also map alternate abbreviation if it exists
          mlb_teams[alt_abbreviation] = db_teams[abbreviation].id if alt_abbreviation.present? && db_teams[alt_abbreviation]
        end
      end

      mlb_teams
    end
  end
end
