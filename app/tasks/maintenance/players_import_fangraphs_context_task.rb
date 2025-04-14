require 'csv'

module Maintenance
  class PlayersImportFangraphsContextTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'players_fangraphs_prospects_2025-04.csv'

    def process
      file_path = Rails.root.join('db', 'sources', 'players', file_name)
      raise "File not found: #{file_path}" unless File.exist?(file_path)

      # Team abbreviation mapping
      team_abbreviation_map = {
        'WSN' => 'WAS',
        'KCR' => 'KC',
        'TBR' => 'TB',
        'SDP' => 'SD',
        'ATH' => 'OAK',
        'SFG' => 'SF'
      }

      level_abbreviation_map = {
        'HSh' => 'PREP',
        'HSp' => 'PREP',
        'COLh' => 'NCAA',
        'COLp' => 'NCAA',
        "Int'l Amateur" => 'INTL'
      }

      total_created = 0
      total_updated = 0
      skipped_rows = []

      CSV.foreach(file_path, headers: true, encoding: 'bom|utf-8').with_index(1) do |row, row_number|
        # Convert Name field to UTF-8 BOM encoding
        name_utf8 = row['Name'].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

        # Attempt to match an existing player record
        player = Player.find_by(fangraphs_id: row['PlayerId']) ||
                 Player.find_by(fangraphs_name: name_utf8)

        if player.nil?
          # Create a new player record if no match is found
          name_parts = name_utf8.split(' ')
          first_name = name_parts[0]
          middle_name = name_parts[1] if name_parts.size > 2
          last_name = name_parts[-1]
          name_suffix = name_parts[-1] if name_parts.size > 3

          player = Player.new(
            fangraphs_id: row['PlayerId'],
            fangraphs_name: name_utf8,
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            name_suffix: name_suffix
          )
        end

        # Map team abbreviation
        team_abbreviation = row['Org'].to_s.strip
        team_abbreviation = team_abbreviation_map[team_abbreviation] || team_abbreviation
        team = Team.find_by(abbreviation: team_abbreviation)

        # Adjust player position
        position = row['Pos'].to_s.strip
        position = 'SP' if position == 'SIRP'
        position = 'RP' if position == 'MIRP'

        # Determine player_type based on adjusted position
        player_type = %w[SP RP].include?(position) ? 'pitcher' : 'batter'

        # Adjust level abbreviation
        level_value = row['Current Level'] || row['Player Type']
        level_value = level_abbreviation_map[level_value] || level_value
        level = Level.find_by(abbreviation: level_value) || Level.find_by(abbreviation: 'N/A')

        # Update player attributes only if they are present in the CSV
        player.assign_attributes(
          team: team,
          position: position,
          level: level,
          player_type: player_type,
          height: row['Ht'],
          weight: row['Wt'],
          bats: row['B'],
          throws: row['T'],
          age: row['Age'],
          active: true
        )

        if player.new_record?
          total_created += 1
        else
          total_updated += 1
        end

        player.save!
      rescue StandardError => e
        Rails.logger.error("Error processing row #{row_number}: #{e.message}")
        skipped_rows << row_number
      end

      # Log summary
      Rails.logger.info("Import completed: #{total_created} players created, #{total_updated} players updated.")
      Rails.logger.info("Skipped rows: #{skipped_rows.join(', ')}") if skipped_rows.any?
    end
  end
end
