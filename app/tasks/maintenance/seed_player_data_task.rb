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

        player.update(level: Level.all.sample, age: rand(18..35), status: Status.all.sample)

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
      Rails.logger.info("  Stats with Timeline ID 1: #{Stat.where(timeline_id: 1).count}")
      Rails.logger.info("  Scouting profiles with Timeline ID 1: #{ScoutingProfile.where(timeline_id: 1).count}")
    end

    private

    def create_or_update_stats(player)
      # Use Timeline with ID 1
      timeline = Timeline.find(1)
      stat = Stat.find_or_initialize_by(player_id: player.id, timeline_id: timeline.id)
      is_new_record = stat.new_record?

      # Get available column names from the model's attributes
      available_columns = stat.attribute_names

      # Set timeline
      stat.timeline_id = timeline.id

      # Pitcher stats
      set_if_column_exists(stat, 'bat_ops', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_hr', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_runs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_rbi', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_nsb', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_error', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_pa', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_ab', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_avg', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_babip', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_bb', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_cs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_doubles', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_errors', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_gdp', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_hbp', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_hits', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_hr', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_iso', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_k', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_ops', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_obp', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_rbi', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_runs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_sb', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_sf', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_slg', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_triples', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_war', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_woba', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_wraa', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_wrc', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_wrc_plus', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_wsb', rand(0..20), available_columns)
      set_if_column_exists(stat, 'bat_xbh', rand(0..20), available_columns)

      set_if_column_exists(stat, 'pit_qs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_k_9', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_era', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_whip', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_nr', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_gs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_inn', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_cg', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_tbf', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_qs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_wins', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_losses', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_ha', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_whip', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_era', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_xera', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_baa', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_babip', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_ks', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_k_9', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_k_pct', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_k_bb_ratio', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_k_bb_pct_diff', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_bb_9', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_bb_k', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_bb_pct', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_bb', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_ibb', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_fip', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_xfip', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_gb_pct', rand(0.001..0.999), available_columns)
      set_if_column_exists(stat, 'pit_hra', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_hr_9', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_lob_pct', rand(0.001..0.999), available_columns)
      set_if_column_exists(stat, 'pit_saves', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_holds', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_rw', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_bs', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_nr', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_hit_bats', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_balks', rand(0..20), available_columns)
      set_if_column_exists(stat, 'pit_wilds', rand(0..20), available_columns)

      stat.save!
      Rails.logger.info("  #{is_new_record ? 'Created' : 'Updated'} stat record for player #{player.name} (ID: #{stat.id})")

      { created: is_new_record, stat: stat }
    rescue StandardError => e
      Rails.logger.error("Error creating stat for player #{player.id} - #{player.name}: #{e.message}")
      Rails.logger.error("Available columns: #{stat.attribute_names.join(', ')}")
      raise e
    end

    def create_or_update_scouting_profile(player)
      # Use Timeline with ID 1
      timeline = Timeline.find(1)
      profile = ScoutingProfile.find_or_initialize_by(player_id: player.id, timeline_id: timeline.id)
      is_new_record = profile.new_record?

      # Get available column names
      available_columns = profile.attribute_names

      # Set timeline
      profile.timeline_id = timeline.id

      # Only set these if they exist in the model
      set_if_column_exists(profile, 'risk', %w[Low Medium High].sample, available_columns)
      set_if_column_exists(profile, 'eta', %w[2025 2026 2027 2028 Ready].sample, available_columns)

      # Rankings - only set if columns exist
      ranking_sources = %w[espn ath ba pl cbs fg self]
      ranking_sources.each do |source|
        set_if_column_exists(profile, "#{source}_overall_rank", rand(1..100), available_columns)
        set_if_column_exists(profile, "#{source}_team_rank", rand(1..30), available_columns)
        set_if_column_exists(profile, "#{source}_future_value", rand(20..80), available_columns)
      end

      # Common scouting attributes
      set_if_column_exists(profile, 'bat_hard_hit', rand(20..50).to_f, available_columns)

      # Determine if player is a pitcher based on position
      is_pitcher = %w[LHP RHP P SP RP CL].include?(player.position)

      if is_pitcher
        # Pitcher abilities - only set if columns exist
        pitcher_present_attrs = %w[pit_fastball_pres pit_control_pres pit_command_pres pit_slider_pres pit_curve_pres pit_changeup_pres pit_cutter_pres pit_sweeper_pres pit_arm_pres]
        pitcher_present_attrs.each do |attr|
          set_if_column_exists(profile, attr, rand(20..80).to_f, available_columns)
        end

        # Projected abilities
        pitcher_proj_attrs = %w[pit_fastball_proj pit_control_proj pit_command_proj pit_slider_proj pit_curve_proj pit_changeup_proj pit_cutter_proj pit_sweeper_proj pit_arm_proj]
        pitcher_proj_attrs.each_with_index do |attr, index|
          next unless available_columns.include?(attr) && available_columns.include?(pitcher_present_attrs[index])

          # Calculate projection based on present value
          present_value = profile.send(pitcher_present_attrs[index])
          profile.send("#{attr}=", present_value + rand(-5..20))
        end

        # Pitch type
        set_if_column_exists(profile, 'pit_fastball_type', rand(1..3).to_f, available_columns)
      else
        # Position player abilities - only set if columns exist
        batter_present_attrs = %w[bat_hit_pres bat_game_pwr_pres bat_raw_pwr_pres bat_spd_pres bat_fld_pres]
        batter_present_attrs.each do |attr|
          set_if_column_exists(profile, attr, rand(20..80).to_f, available_columns)
        end

        # Projected abilities
        batter_proj_attrs = %w[bat_hit_proj bat_game_pwr_proj bat_raw_pwr_proj bat_spd_proj bat_fld_proj]
        batter_proj_attrs.each_with_index do |attr, index|
          next unless available_columns.include?(attr) && available_columns.include?(batter_present_attrs[index])

          # Calculate projection based on present value
          present_value = profile.send(batter_present_attrs[index])
          profile.send("#{attr}=", present_value + rand(-5..20))
        end

        # Batting attributes
        set_if_column_exists(profile, 'bat_pit_sel', rand(20..80).to_f, available_columns)
        set_if_column_exists(profile, 'bat_bat_ctrl', rand(20..80).to_f, available_columns)
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
