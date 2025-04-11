require 'csv'

module Maintenance
  class PlayersImportSfbbContextTask < MaintenanceTasks::Task
    no_collection

    attribute :file_name, :string, default: 'players_sfbb_2025-04.csv'

    def process
      file_path = Rails.root.join('db', 'sources', 'players', file_name)
      raise "File not found: #{file_path}" unless File.exist?(file_path)

      skipped_rows = []
      processed_count = 0

      CSV.foreach(file_path, headers: true).with_index(1) do |row, row_number|
        # Map CSV headers to player attributes
        player_attributes = {
          birthdate: row['BIRTHDATE'],
          fangraphs_id: row['IDFANGRAPHS'],
          fangraphs_name: row['FANGRAPHSNAME'],
          mlbam_id: row['MLBID'],
          mlb_name: row['MLBNAME'],
          cbs_id: row['CBSID'],
          cbs_name: row['CBSNAME'],
          retro_id: row['RETROID'],
          bref_id: row['BREFID'],
          nfbc_id: row['NFBCID'],
          nfbc_name: row['NFBCNAME'],
          espn_id: row['ESPNID'],
          espn_name: row['ESPNNAME'],
          yahoo_id: row['YAHOOID'],
          yahoo_name: row['YAHOONAME'],
          bats: row['BATS'],
          throws: row['THROWS'],
          active: row['ACTIVE'].to_s.strip.upcase == 'Y',
          position: row['POS']
        }

        # Match player by various identifiers before creating a new record
        player = Player.find_by(fangraphs_id: player_attributes[:fangraphs_id]) ||
                 Player.find_by(fangraphs_name: player_attributes[:fangraphs_name]) ||
                 Player.find_by(cbs_id: player_attributes[:cbs_id]) ||
                 Player.find_by(cbs_name: player_attributes[:cbs_name]) ||
                 Player.find_by(yahoo_id: player_attributes[:yahoo_id]) ||
                 Player.find_by(espn_id: player_attributes[:espn_id])

        if player.nil?
          # Split CBS name into first_name, middle_name, last_name, and name_suffix
          cbs_name_parts = player_attributes[:cbs_name].to_s.strip.split(' ')
          first_name = cbs_name_parts[0]
          middle_name = cbs_name_parts[1] if cbs_name_parts.size > 2
          last_name = cbs_name_parts[-1]
          name_suffix = cbs_name_parts[-1] if cbs_name_parts.size > 3

          # Use the POS column for the position attribute if it's not P or OF
          position = row['POS'].to_s.strip
          position = nil if %w[P OF].include?(position)

          # Create a new player record
          player = Player.new(
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            name_suffix: name_suffix,
            fangraphs_id: player_attributes[:fangraphs_id],
            cbs_id: player_attributes[:cbs_id],
            yahoo_id: player_attributes[:yahoo_id],
            espn_id: player_attributes[:espn_id],
            position: position
          )
        else
          # Update player attributes only if they are present in the CSV
          player_attributes.each do |key, value|
            player[key] = value if value.present?
          end

          # Do not update the position if the player already has one
          if player.position.blank?
            position = row['POS'].to_s.strip
            player.position = position unless %w[P OF].include?(position)
          end
        end

        player.save!
        processed_count += 1
      rescue StandardError => e
        Rails.logger.error("Error processing row #{row_number}: #{e.message}")
        skipped_rows << row_number
      end

      # Log summary
      Rails.logger.info("Import completed: #{processed_count} players processed.")
      Rails.logger.info("Skipped rows: #{skipped_rows.join(', ')}") if skipped_rows.any?
    end
  end
end
