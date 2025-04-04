require 'roo'

module Maintenance
  class PlayersImportFangraphsContextTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'players_fangraphs_mlb_2025-04.xlsx'

    def process
      # Load the xlsx file using roo
      workbook = Roo::Excelx.new(Rails.root.join('db', 'sources', 'players', file_name))
      rows = workbook.sheet(0).parse(headers: true)

      # Track progress
      total_processed = 0
      total_created = 0
      total_updated = 0
      skipped_records = 0

      # Team abbreviation mapping
      team_abbreviation_map = {
        'WSN' => 'WAS',
        'KCR' => 'KC',
        'TBR' => 'TB',
        'SDP' => 'SD',
        'ATH' => 'OAK',
        'SFG' => 'SF'
      }

      rows.each_with_index do |row, index|
        total_processed += 1

        # Extract player attributes
        first_name = row['first_name'].to_s.strip
        last_name = row['last_name'].to_s.strip

        # Normalize encoded characters in names
        first_name = first_name.encode('ASCII', invalid: :replace, undef: :replace, replace: '').tr('√≠√±', 'in')
        last_name = last_name.encode('ASCII', invalid: :replace, undef: :replace, replace: '').tr('√≠√±', 'in')

        # Debugging log for specific row
        Rails.logger.info("Processing player: #{first_name} #{last_name} on row #{index + 1}") if first_name == 'Warren' && last_name == 'Calcano'

        # Skip rows with missing first or last name
        if first_name.blank? || last_name.blank?
          Rails.logger.info("Row #{index + 1} has missing first or last name, skipping")
          skipped_records += 1
          next
        end

        # Map team abbreviation
        team_abbreviation = row['team'].to_s.strip
        team_abbreviation = team_abbreviation_map[team_abbreviation] || team_abbreviation
        team = Team.find_by(abbreviation: team_abbreviation)

        # Adjust player position
        position = row['position'].to_s.strip
        position = 'SP' if position == 'SIRP'
        position = 'RP' if position == 'MIRP'

        # Determine player_type based on adjusted position
        player_type = %w[SP RP].include?(position) ? 'pitcher' : 'batter'

        # Adjust level abbreviation
        level_value = row['level']
        level_abbreviation_map = {
          'HSh' => 'PREP',
          'HSp' => 'PREP',
          'COLh' => 'NCAA',
          'COLp' => 'NCAA'
        }
        level_value = level_abbreviation_map[level_value] || level_value
        level = Level.find_by(abbreviation: level_value) || Level.find_by(abbreviation: 'N/A')

        # Find player by normalized first_name and last_name
        player = Player.find_by(first_name: first_name, last_name: last_name)

        # Special case for Max Muncy
        player = Player.find_by(first_name: first_name, last_name: last_name, team_id: team&.id) if first_name == 'Max' && last_name == 'Muncy'

        # Match by fg_id if no match found and fg_id is not nil
        fg_id = row['fg_id'].to_s.strip
        player ||= Player.find_by(fg_id: fg_id) if fg_id.present?

        if player
          # Update player attributes
          Rails.logger.info("Updating existing player: #{first_name} #{last_name}") if first_name == 'Warren' && last_name == 'Calcano'
          player.update(
            age: row['age'],
            height: row['height'],
            weight: row['weight'],
            bats: row['bats'],
            throws: row['throws'],
            fg_id: row['fg_id'].to_s.strip,
            level: level,
            team: team,
            player_type: player_type,
            position: position
          )
          total_updated += 1
        else
          # Create new player record
          new_player = Player.new(
            first_name: first_name,
            last_name: last_name,
            age: row['age'],
            height: row['height'],
            weight: row['weight'],
            bats: row['bats'],
            throws: row['throws'],
            fg_id: row['fg_id'].to_s.strip,
            level: level,
            team: team,
            player_type: player_type,
            position: position
          )

          if new_player.save
            total_created += 1
            Rails.logger.info("Successfully created player: #{first_name} #{last_name}") if first_name == 'Warren' && last_name == 'Calcano'
          else
            skipped_records += 1
            Rails.logger.info("Failed to save player #{first_name} #{last_name}: #{new_player.errors.full_messages.join(', ')}")
          end
        end
      end

      # Provide detailed stats at the end
      Rails.logger.info('Import completed:')
      Rails.logger.info("  Processed: #{total_processed}")
      Rails.logger.info("  Created: #{total_created}")
      Rails.logger.info("  Updated: #{total_updated}")
      Rails.logger.info("  Skipped: #{skipped_records}")
    end
  end
end
