require 'csv'

module Maintenance
  class CbsBatterImportTask < MaintenanceTasks::Task
    no_collection

    def process
      # Load reference data
      valid_positions = load_valid_positions
      mlb_teams_map = load_mlb_teams_map
      rosters = Roster.all.index_by(&:name)

      # Track progress
      total_processed = 0
      total_imported = 0
      skipped_records = 0

      # Process CSV file
      csv_file_path = Rails.root.join('db', 'sources', 'cbs_batter_import_2024.csv')
      rows = CSV.read(csv_file_path)

      # Skip first row completely
      rows.shift

      # Second row contains headers
      headers = rows.shift.map(&:strip)

      # Find column indices
      player_index = headers.index('Player')
      avail_index = headers.index('Avail')

      rows.each do |row|
        total_processed += 1
        player_info = row[player_index].to_s.strip
        avail_info = row[avail_index].to_s.strip

        # Skip if player info is blank
        next if player_info.blank?

        # Parse player information
        # Format: "Ronald Acuña Jr. OF | ATL"
        if player_info.match(%r{^(.+?)\s+([\w\s.\-'`]+?)\s+([A-Z0-9/]+)\s+\|\s+([A-Z]+)$})
          first_name = ::Regexp.last_match(1).strip
          last_name = ::Regexp.last_match(2).strip
          position_code = ::Regexp.last_match(3).strip
          mlb_code = ::Regexp.last_match(4).strip

          # Validate position
          unless valid_positions.include?(position_code)
            log("Invalid position #{position_code} for player #{player_info}, skipping")
            skipped_records += 1
            next
          end

          # Find associated team
          team = nil
          team = Team.find_by(id: mlb_teams_map[mlb_code]) if mlb_teams_map[mlb_code]

          log("Could not find team for MLB code: #{mlb_code}, player: #{player_info}") unless team

          # Check if player already exists
          player = Player.find_by(first_name: first_name, last_name: last_name)

          if player
            log("Updating existing player: #{first_name} #{last_name}")
            player.position = position_code
            player.team = team if team
          else
            log("Creating new player: #{first_name} #{last_name}")
            player = Player.new(
              first_name: first_name,
              last_name: last_name,
              position: position_code,
              team: team
            )
          end

          # Associate with roster if not FA
          if avail_info != 'FA' && rosters[avail_info]
            player.roster = rosters[avail_info]
            log("  Assigned to roster: #{avail_info}")
          end

          # Save the player
          if player.save
            total_imported += 1
          else
            log("Failed to save player #{player_info}: #{player.errors.full_messages.join(', ')}")
            skipped_records += 1
          end
        else
          log("Could not parse player info: #{player_info}")
          skipped_records += 1
        end
      end

      log("Import completed. Processed: #{total_processed}, Imported: #{total_imported}, Skipped: #{skipped_records}")
    end

    private

    def load_valid_positions
      positions_file = Rails.root.join('db', 'sources', 'ppmlb_fantasy_baseball_positions.csv')
      positions = []

      CSV.foreach(positions_file, headers: true) do |row|
        positions << row['code'] if row['code']
      end

      positions
    end

    def load_mlb_teams_map
      teams_file = Rails.root.join('db', 'sources', 'mlb_teams.csv')
      mlb_teams = {}

      CSV.foreach(teams_file, headers: true) do |row|
        mlb_teams[row['mlb_code']] = row['id'] if row['mlb_code'] && row['id']
      end

      mlb_teams
    end
  end
end
