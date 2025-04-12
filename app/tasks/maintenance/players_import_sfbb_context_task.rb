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
          bp_id: row['BPID'],
          bref_id: row['BREFID'],
          cbs_id: row['CBSID'],
          cbs_name: row['CBSNAME'],
          espn_id: row['ESPNID'],
          espn_name: row['ESPNNAME'],
          fangraphs_id: row['IDFANGRAPHS'],
          fangraphs_name: row['FANGRAPHSNAME'],
          fantrax_id: row['FANTRAXID'],
          fantrax_name: row['FANTRAXNAME'],
          mlb_id: row['MLBID'],
          mlb_name: row['MLBNAME'],
          nfbc_id: row['NFBCID'],
          nfbc_name: row['NFBCNAME'],
          razzball_id: row['RAZZBALLID'],
          razzball_name: row['RAZZBALLNAME'],
          retro_id: row['RETROID'],
          rotowire_id: row['ROTOWIREID'],
          rotowire_name: row['ROTOWIRENAME'],
          sfbb_id: row['IDPLAYER'],
          sfbb_name: row['PLAYERNAME'],
          yahoo_id: row['YAHOOID'],
          yahoo_name: row['YAHOONAME'],
          birthdate: row['BIRTHDATE'],
          bats: row['BATS'],
          throws: row['THROWS'],
          position: row['POS'],
          active: (row['ACTIVE'] == 'Y')
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
            position: position,
            bats: player_attributes[:bats],
            throws: player_attributes[:throws],
            birthdate: Date.strptime(player_attributes[:birthdate], '%m/%d/%y'),
            active: player_attributes[:active],
            bp_id: player_attributes[:bp_id],
            bref_id: player_attributes[:bref_id],
            cbs_id: player_attributes[:cbs_id],
            cbs_name: player_attributes[:cbs_name],
            espn_id: player_attributes[:espn_id],
            espn_name: player_attributes[:espn_name],
            fangraphs_id: player_attributes[:fangraphs_id],
            fangraphs_name: player_attributes[:fangraphs_id],
            fantrax_id: player_attributes[:fantrax_id],
            fantrax_name: player_attributes[:fantrax_name],
            mlb_id: player_attributes[:mlb_id],
            mlb_name: player_attributes[:mlb_name],
            nfbc_id: player_attributes[:nfbc_id],
            nfbc_name: player_attributes[:nfbc_name],
            razzball_id: player_attributes[:razzball_id],
            razzball_name: player_attributes[:razzball_name],
            retro_id: player_attributes[:retro_id],
            rotowire_id: player_attributes[:rotowire_id],
            rotowire_name: player_attributes[:rotowire_name],
            sfbb_id: player_attributes[:sfbb_id],
            sfbb_name: player_attributes[:sfbb_name],
            yahoo_id: player_attributes[:yahoo_id],
            yahoo_name: player_attributes[:yahoo_name]
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
