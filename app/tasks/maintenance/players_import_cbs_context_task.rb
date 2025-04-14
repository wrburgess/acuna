require 'csv'

module Maintenance
  class PlayersImportCbsContextTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'players_cbs_batters_2025-04.csv'

    def process
      # Track progress
      total_processed = 0
      total_imported = 0
      skipped_records = 0

      # Add counters for better diagnostics
      unparseable_records = 0
      invalid_position_records = 0
      no_team_records = 0
      validation_error_records = 0

      # Load the CSV file
      file_path = Rails.root.join('db', 'sources', 'players', file_name)
      raise "File not found: #{file_path}" unless File.exist?(file_path)

      rows = CSV.read(file_path, headers: true, encoding: 'bom|utf-8')

      # Extract headers
      headers = rows.headers.map(&:to_s)

      # Find column indices
      roster_index = headers.index('Avail')
      player_index = headers.index('Player')
      eligible_positions_index = headers.index('Eligible')

      # Check if required headers exist
      if roster_index.nil? || player_index.nil? || eligible_positions_index.nil?
        Rails.logger.info('Error: Required headers not found in CSV file')
        Rails.logger.info("Headers found: #{headers.join(', ')}")
        return
      end

      rows.each_with_index do |row, _|
        total_processed += 1

        # Extract the player name and positions
        player_data = row['Player'].to_s.strip
        player_name_and_positions, team_abbreviation = player_data.split('|').map(&:strip)

        # Handle cases where the name contains multiple parts (e.g., "De Los Santos")
        name_parts = player_name_and_positions.split(/[\s,]+/)
        first_name = name_parts[0]
        last_name = name_parts[1..].reject { |part| %w[SP,RP RP,SP SP RP C 1B 2B 3B SS LF RF CF DH U].include?(part) }.join(' ')

        # Extract eligible positions and team abbreviation
        eligible_positions_raw = row['Eligible'].split(',').map(&:strip)
        eligible_positions = eligible_positions_raw.reject { |position| position == 'U' }

        # Extract primary position from eligible_positions
        primary_position = eligible_positions[0]

        # Load rosters by name and find the FA roster
        roster = Roster.find_by(name: row['Avail'].to_s.strip) || Roster.find_by(abbreviation: 'FA')
        Rails.logger.info("WARNING: No roster with abbreviation 'FA' found. Free agents will not be assigned to any roster.") if roster.nil?

        # Determine player_type based on position
        player_type = %w[SP RP].include?(primary_position) ? 'pitcher' : 'batter'

        # Find team by abbreviation
        team = Team.find_by(abbreviation: team_abbreviation)

        # Check if player already exists
        cbs_name = "#{first_name} #{last_name}"
        player = Player.find_by(cbs_name: cbs_name) || Player.find_by(first_name: first_name, last_name: last_name)

        if player
          Rails.logger.info("Updating existing player: #{first_name} #{last_name} with position: #{primary_position}")
          player.update(
            eligible_positions: eligible_positions, # Update as an array
            position: primary_position,
            player_type: player_type,
            team: team,
            roster: roster,
            cbs_name: cbs_name
          )
        else
          Rails.logger.info("Creating new player: #{first_name} #{last_name} with position: #{primary_position}")
          player = Player.new(
            first_name: first_name,
            last_name: last_name,
            player_type: player_type,
            eligible_positions: eligible_positions, # Save as an array
            position: primary_position,
            team: team,
            roster: roster,
            cbs_name: cbs_name
          )
        end

        # Save the player
        if player.save
          total_imported += 1
        else
          Rails.logger.info("Failed to save player #{first_name} #{last_name}: #{player.errors.full_messages.join(', ')}")
          validation_error_records += 1
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
  end
end
