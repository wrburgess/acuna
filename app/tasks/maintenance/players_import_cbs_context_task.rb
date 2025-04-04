require 'roo'

module Maintenance
  class PlayersImportCbsContextTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'players_cbs_batters_2025-04.xlsx'

    def process
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

      # Load the xlsx file using roo
      workbook = Roo::Excelx.new(Rails.root.join('db', 'sources', 'players', file_name))

      # Read rows from the worksheet
      rows = workbook.sheet(0).parse(headers: true)

      # Extract headers
      headers = rows.first.keys.map(&:to_s)

      # Find column indices
      roster_index = headers.index('roster')
      first_name_index = headers.index('first_name')
      middle_name_index = headers.index('middle_name')
      last_name_index = headers.index('last_name')
      name_suffix_index = headers.index('name_suffix')
      eligible_positions_index = headers.index('eligible_positions')
      team_index = headers.index('team')

      # Check if required headers exist
      if roster_index.nil? || first_name_index.nil? || middle_name_index.nil? || last_name_index.nil? || name_suffix_index.nil? || eligible_positions_index.nil? || team_index.nil?
        Rails.logger.info('Error: Required headers not found in xlsx file')
        Rails.logger.info("Headers found: #{headers.join(', ')}")
        return
      end

      rows.each_with_index do |row, index|
        total_processed += 1

        # Extract player attributes
        first_name = row['first_name'].to_s.strip
        middle_name = row['middle_name'].to_s.strip
        last_name = row['last_name'].to_s.strip
        name_suffix = row['name_suffix'].to_s.strip

        # Normalize encoded characters in names
        first_name = first_name.encode('ASCII', invalid: :replace, undef: :replace, replace: '').tr('√≠√±', 'in')
        middle_name = middle_name.encode('ASCII', invalid: :replace, undef: :replace, replace: '').tr('√≠√±', 'in')
        last_name = last_name.encode('ASCII', invalid: :replace, undef: :replace, replace: '').tr('√≠√±', 'in')
        name_suffix = name_suffix.encode('ASCII', invalid: :replace, undef: :replace, replace: '').tr('√≠√±', 'in')

        eligible_positions_info = row['eligible_positions'].to_s.strip
        eligible_positions = eligible_positions_info.split(',').map(&:strip)

        # Remove "U" from eligible positions
        eligible_positions.delete('U')

        team_abbreviation = row['team'].to_s.strip
        roster_name = row['roster'].to_s.strip

        # Skip if first_name or last_name is blank
        if first_name.blank? || last_name.blank?
          Rails.logger.info("Row #{index + 1} has missing first or last name, skipping")
          skipped_records += 1
          next
        end

        # Extract primary position from eligible_positions
        primary_position = eligible_positions.first.to_s.strip

        # Determine player_type based on position
        player_type = %w[SP RP].include?(primary_position) ? 'pitcher' : 'batter'

        # Find team by abbreviation
        team = Team.find_by(abbreviation: team_abbreviation)
        if team.nil?
          Rails.logger.info("Could not find team for abbreviation: #{team_abbreviation}, player: #{first_name} #{last_name}")
          no_team_records += 1
        end

        # Find roster by matching Avails with Location + Nickname
        roster = rosters.values.find { |r| r.name.strip == roster_name } || (roster_name == 'FA' ? fa_roster : nil)
        unless roster
          Rails.logger.info("Could not find roster matching Location + Nickname for: #{roster_name}, assigning to Free Agent roster")
          roster = fa_roster
        end

        # Check if player already exists (match by normalized first_name, last_name, and team)
        player = Player.find_by(first_name: first_name, last_name: last_name)

        if player
          Rails.logger.info("Updating existing player: #{first_name} #{last_name} with position: #{primary_position}")
          player.update(
            middle_name: middle_name,
            name_suffix: name_suffix,
            eligible_positions: eligible_positions, # Update as an array
            position: primary_position,
            player_type: player_type,
            team: team,
            roster: roster
          )
        else
          Rails.logger.info("Creating new player: #{first_name} #{last_name} with position: #{primary_position}")
          player = Player.new(
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            name_suffix: name_suffix,
            player_type: player_type,
            eligible_positions: eligible_positions, # Save as an array
            position: primary_position,
            team: team,
            roster: roster
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
