module Maintenance
  class SeedPlayerDataTask < MaintenanceTasks::Task
    no_collection

    def process
      Stat.destroy_all
      ScoutingProfile.destroy_all

      # Track progress statistics
      stats_created = 0
      stats_updated = 0
      profiles_created = 0
      profiles_updated = 0
      errors = 0

      Rails.logger.info('Starting to seed player stats and scouting profiles...')

      # Get total count for progress tracking
      total_players = Player.count
      Rails.logger.info("Found #{total_players} players to process")

      # Process each player
      Player.find_each.with_index(1) do |player, index|
        Rails.logger.info("Processing player #{index}/#{total_players}: #{player.name}")

        player.update(level: Player::LEVELS.sample, age: rand(18..35))

        begin
          # Create or update stats
          stat_result = create_or_update_stats(player)
          if stat_result[:created]
            stats_created += 1
          else
            stats_updated += 1
          end

          # Create or update scouting profile
          profile_result = create_or_update_scouting_profile(player)
          if profile_result[:created]
            profiles_created += 1
          else
            profiles_updated += 1
          end
        rescue StandardError => e
          Rails.logger.error("Error processing player #{player.id} - #{player.name}: #{e.message}")
          Rails.logger.error("Backtrace: #{e.backtrace.join("\n")}")
          errors += 1
        end

        # Print progress every 10 players
        Rails.logger.info("Completed #{index}/#{total_players} players (#{(index.to_f / total_players * 100).round(1)}%)") if index % 10 == 0
      end

      # Report summary
      Rails.logger.info('✅ Seed player data process completed:')
      Rails.logger.info("  Total players processed: #{total_players}")
      Rails.logger.info("  Stats created: #{stats_created}")
      Rails.logger.info("  Stats updated: #{stats_updated}")
      Rails.logger.info("  Scouting profiles created: #{profiles_created}")
      Rails.logger.info("  Scouting profiles updated: #{profiles_updated}")
      Rails.logger.info("  Errors: #{errors}")
      Rails.logger.info("  Stats in 2025 ytd: #{Stat.where(timeline: '2025', timeline_type: 'ytd').count}")
      Rails.logger.info("  Scouting profiles in 2025 ytd: #{ScoutingProfile.where(timeline: '2025', timeline_type: 'ytd').count}")
    end

    private

    def create_or_update_stats(player)
      # Find existing or create new stat
      stat = Stat.find_or_initialize_by(player_id: player.id, timeline: '2025', timeline_type: 'ytd')
      is_new_record = stat.new_record?

      # Get available column names from the model's attributes
      available_columns = stat.attribute_names

      # Set common timeline attributes
      stat.timeline = '2025'
      stat.timeline_type = 'ytd'

      # Determine if player is a pitcher based on position
      is_pitcher = %w[LHP RHP P SP RP CL].include?(player.position)

      # Generate specific stats for batters or pitchers
      if is_pitcher
        set_if_column_exists(stat, 'w', rand(0..20), available_columns)
        set_if_column_exists(stat, 'l', rand(0..15), available_columns)
        set_if_column_exists(stat, 'era', (2.0 + rand * 4.0).round(2), available_columns)
        set_if_column_exists(stat, 'g', rand(20..80), available_columns)
        set_if_column_exists(stat, 'gs', rand(0..35), available_columns)
        set_if_column_exists(stat, 'inn', rand(20..220), available_columns)
        set_if_column_exists(stat, 'sv', rand(0..40), available_columns)
        set_if_column_exists(stat, 'bs', rand(0..10), available_columns)
        set_if_column_exists(stat, 'k', rand(40..300), available_columns)
        set_if_column_exists(stat, 'bb', rand(10..100), available_columns)
        set_if_column_exists(stat, 'ha', rand(20..200), available_columns)
        set_if_column_exists(stat, 'hra', rand(5..40), available_columns)
        set_if_column_exists(stat, 'rw', rand(0..15), available_columns)
        set_if_column_exists(stat, 'whip', (0.9 + rand * 0.6).round(2), available_columns)
        set_if_column_exists(stat, 'k_per_nine', (7.0 + rand * 5.0).round(1), available_columns)
        set_if_column_exists(stat, 'bb_per_nine', (2.0 + rand * 3.0).round(1), available_columns)
        set_if_column_exists(stat, 'k_bb_ratio', (2.0 + rand * 3.0).round(1), available_columns)
        set_if_column_exists(stat, 'hr_per_nine', (0.5 + rand * 1.5).round(1), available_columns)
        set_if_column_exists(stat, 'baa', (0.150 + rand * 0.150).round(3), available_columns)
        set_if_column_exists(stat, 'qs', rand(0..25), available_columns)
        set_if_column_exists(stat, 'war', (rand * 5.0).round(1), available_columns)
        set_if_column_exists(stat, 'nr', rand(10..80), available_columns)
        set_if_column_exists(stat, 'errs', rand(10..80), available_columns)
      else
        # Batter stats
        set_if_column_exists(stat, 'pa', rand(200..700), available_columns)
        set_if_column_exists(stat, 'ab', rand(150..600), available_columns)
        set_if_column_exists(stat, 'bavg', (0.200 + rand * 0.150).round(3), available_columns)
        # Don't use h= if it doesn't exist as a method
        set_if_column_exists(stat, 'hits', rand(40..200), available_columns)
        set_if_column_exists(stat, 'singles', rand(20..120), available_columns)
        set_if_column_exists(stat, 'doubles', rand(10..40), available_columns)
        set_if_column_exists(stat, 'triples', rand(0..10), available_columns)
        set_if_column_exists(stat, 'xbh', rand(0..10), available_columns)
        set_if_column_exists(stat, 'hr', rand(5..50), available_columns)
        set_if_column_exists(stat, 'runs', rand(20..120), available_columns)
        set_if_column_exists(stat, 'rbi', rand(10..120), available_columns)
        set_if_column_exists(stat, 'bb', rand(20..100), available_columns)
        set_if_column_exists(stat, 'k', rand(30..180), available_columns)
        set_if_column_exists(stat, 'sb', rand(0..40), available_columns)
        set_if_column_exists(stat, 'cs', rand(0..15), available_columns)
        set_if_column_exists(stat, 'nsb', rand(0..35), available_columns)
        set_if_column_exists(stat, 'ba', (0.200 + rand * 0.150).round(3), available_columns)
        set_if_column_exists(stat, 'obp', (0.300 + rand * 0.150).round(3), available_columns)
        set_if_column_exists(stat, 'slg', (0.350 + rand * 0.250).round(3), available_columns)
        set_if_column_exists(stat, 'ops', (0.700 + rand * 0.300).round(3), available_columns)
        set_if_column_exists(stat, 'bb_pct', (rand * 0.15 + 0.05).round(3), available_columns)
        set_if_column_exists(stat, 'k_pct', (rand * 0.20 + 0.10).round(3), available_columns)
        set_if_column_exists(stat, 'iso', (0.100 + rand * 0.250).round(3), available_columns)
        set_if_column_exists(stat, 'babip', (0.280 + rand * 0.080).round(3), available_columns)
        set_if_column_exists(stat, 'wrc_plus', rand(80..150), available_columns)
        set_if_column_exists(stat, 'war', (rand * 8.0).round(1), available_columns)
      end

      stat.save!
      Rails.logger.info("  #{is_new_record ? 'Created' : 'Updated'} stat record for player #{player.name} (ID: #{stat.id})")

      { created: is_new_record, stat: stat }
    rescue StandardError => e
      Rails.logger.error("Error creating stat for player #{player.id} - #{player.name}: #{e.message}")
      Rails.logger.error("Available columns: #{stat.attribute_names.join(', ')}")
      raise e
    end

    def create_or_update_scouting_profile(player)
      # Find existing or create new scouting profile
      profile = ScoutingProfile.find_or_initialize_by(player_id: player.id, timeline: '2025', timeline_type: 'ytd')
      is_new_record = profile.new_record?

      # Get available column names
      available_columns = profile.attribute_names

      # Set common attributes
      profile.timeline = '2025'
      profile.timeline_type = 'ytd'

      # Only set these if they exist in the model
      set_if_column_exists(profile, 'risk', %w[Low Medium High].sample, available_columns)
      set_if_column_exists(profile, 'eta', %w[2025 2026 2027 2028 Ready].sample, available_columns)

      # Rankings - only set if columns exist
      ranking_sources = %w[espn ath ba pl cbs fg self]
      ranking_sources.each do |source|
        set_if_column_exists(profile, "#{source}_ovr_rnk", rand(1..100), available_columns)
        set_if_column_exists(profile, "#{source}_tm_rnk", rand(1..30), available_columns)
        set_if_column_exists(profile, "#{source}_fv", rand(20..80), available_columns)
      end

      # Common scouting attributes
      set_if_column_exists(profile, 'hard_hit', rand(20..50).to_f, available_columns)

      # Determine if player is a pitcher based on position
      is_pitcher = %w[LHP RHP P SP RP CL].include?(player.position)

      if is_pitcher
        # Pitcher abilities - only set if columns exist
        pitcher_present_attrs = %w[fastball_pres control_pres command_pres slider_pres curve_pres changeup_pres cutter_pres sweeper_pres arm_pres]
        pitcher_present_attrs.each do |attr|
          set_if_column_exists(profile, attr, rand(20..80).to_f, available_columns)
        end

        # Projected abilities
        pitcher_proj_attrs = %w[fastball_proj control_proj command_proj slider_proj curve_proj changeup_proj cutter_proj sweeper_proj arm_proj]
        pitcher_proj_attrs.each_with_index do |attr, index|
          next unless available_columns.include?(attr) && available_columns.include?(pitcher_present_attrs[index])

          # Calculate projection based on present value
          present_value = profile.send(pitcher_present_attrs[index])
          profile.send("#{attr}=", present_value + rand(-5..20))
        end

        # Pitch type
        set_if_column_exists(profile, 'fastball_type', rand(1..3).to_f, available_columns)
      else
        # Position player abilities - only set if columns exist
        batter_present_attrs = %w[hit_pres game_pwr_pres raw_pwr_pres spd_pres fld_pres]
        batter_present_attrs.each do |attr|
          set_if_column_exists(profile, attr, rand(20..80).to_f, available_columns)
        end

        # Projected abilities
        batter_proj_attrs = %w[hit_proj game_pwr_proj raw_pwr_proj spd_proj fld_proj]
        batter_proj_attrs.each_with_index do |attr, index|
          next unless available_columns.include?(attr) && available_columns.include?(batter_present_attrs[index])

          # Calculate projection based on present value
          present_value = profile.send(batter_present_attrs[index])
          profile.send("#{attr}=", present_value + rand(-5..20))
        end

        # Batting attributes
        set_if_column_exists(profile, 'pit_sel', rand(20..80).to_f, available_columns)
        set_if_column_exists(profile, 'bat_ctrl', rand(20..80).to_f, available_columns)
      end

      profile.save!
      Rails.logger.info("  #{is_new_record ? 'Created' : 'Updated'} scouting profile for player #{player.name} (ID: #{profile.id})")

      { created: is_new_record, profile: profile }
    rescue StandardError => e
      Rails.logger.error("Error creating scouting profile for player #{player.id} - #{player.name}: #{e.message}")
      Rails.logger.error("Available columns: #{profile.attribute_names.join(', ')}")
      raise e
    end

    # Helper method to safely set a column value only if it exists
    def set_if_column_exists(model, column_name, value, available_columns)
      return unless available_columns.include?(column_name)

      model[column_name] = value
    end
  end
end
