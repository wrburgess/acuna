require 'csv'

module Maintenance
  class AggregateScoutingProfileDataTask < MaintenanceTasks::Task
    no_collection

    attribute :timeline_abbrev, :string, default: '2025'

    def process
      timeline = Timeline.find_by!(timeline_abbrev:)
      players = Player.all

      players.each do |player|
        # Find or create the scouting profile for the player and timeline
        scouting_profile = ScoutingProfile.find_or_initialize_by(player: player, timeline:)

        scout_fg = Scout.find_or_create_by!(first_name: 'Eric', last_name: 'Longenhagen')
        scout_ath = Scout.find_or_create_by!(first_name: 'Keith', last_name: 'Law')
        scout_cbs = Scout.find_or_create_by!(first_name: 'Scott', last_name: 'White')
        scout_ba = Scout.find_or_create_by!(first_name: 'JJ', last_name: 'Cooper')
        scout_espn = Scout.find_or_create_by!(first_name: 'Kiley', last_name: 'McDaniel')

        # Fetch scouting reports for the player
        fangraphs_report = player.scouting_reports.find_by(scout: scout_fg, timeline:)
        athletic_report = player.scouting_reports.find_by(scout: scout_ath, timeline:)
        cbs_report = player.scouting_reports.find_by(scout: scout_cbs, timeline:)
        ba_report = player.scouting_reports.find_by(scout: scout_ba, timeline:)
        espn_report = player.scouting_reports.find_by(scout: scout_espn, timeline:)

        # Copy data from Eric Longenhagen's scouting report
        if fangraphs_report
          scouting_profile.assign_attributes(
            risk: fangraphs_report.risk,
            eta: fangraphs_report.eta,
            fg_overall_rank: fangraphs_report.fg_overall_rank,
            fg_team_rank: fangraphs_report.fg_team_rank,
            fg_future_value: fangraphs_report.fg_future_value,
            sits: fangraphs_report.sits,
            tops: fangraphs_report.tops,
            bat_hit_pres: fangraphs_report.bat_hit_pres,
            bat_hit_proj: fangraphs_report.bat_hit_proj,
            bat_game_pwr_pres: fangraphs_report.bat_game_pwr_pres,
            bat_game_pwr_proj: fangraphs_report.bat_game_pwr_proj,
            bat_raw_pwr_pres: fangraphs_report.bat_raw_pwr_pres,
            bat_raw_pwr_proj: fangraphs_report.bat_raw_pwr_proj,
            bat_pit_sel: fangraphs_report.bat_pit_sel,
            bat_bat_ctrl: fangraphs_report.bat_bat_ctrl,
            bat_hard_hit: fangraphs_report.bat_hard_hit,
            bat_spd_pres: fangraphs_report.bat_spd_pres,
            bat_spd_proj: fangraphs_report.bat_spd_proj,
            bat_fld_pres: fangraphs_report.bat_fld_pres,
            bat_fld_proj: fangraphs_report.bat_fld_proj,
            pit_control_pres: fangraphs_report.pit_control_pres,
            pit_control_proj: fangraphs_report.pit_control_proj,
            pit_command_pres: fangraphs_report.pit_command_pres,
            pit_command_proj: fangraphs_report.pit_command_proj,
            pit_fastball_pres: fangraphs_report.pit_fastball_pres,
            pit_fastball_proj: fangraphs_report.pit_fastball_proj,
            pit_fastball_type: fangraphs_report.pit_fastball_type,
            pit_curve_pres: fangraphs_report.pit_curve_pres,
            pit_curve_proj: fangraphs_report.pit_curve_proj,
            pit_slider_pres: fangraphs_report.pit_slider_pres,
            pit_slider_proj: fangraphs_report.pit_slider_proj,
            pit_sweeper_pres: fangraphs_report.pit_sweeper_pres,
            pit_sweeper_proj: fangraphs_report.pit_sweeper_proj,
            pit_changeup_pres: fangraphs_report.pit_changeup_pres,
            pit_changeup_proj: fangraphs_report.pit_changeup_proj,
            pit_cutter_pres: fangraphs_report.pit_cutter_pres,
            pit_cutter_proj: fangraphs_report.pit_cutter_proj,
            pit_arm_pres: fangraphs_report.pit_arm_pres,
            pit_arm_proj: fangraphs_report.pit_arm_proj
          )
        end

        # Copy data from Keith Law's scouting report
        if athletic_report
          scouting_profile.assign_attributes(
            ath_overall_rank: athletic_report.ath_overall_rank,
            ath_team_rank: athletic_report.ath_team_rank,
            ath_future_value: athletic_report.ath_future_value
          )
        end

        # Copy data from Scott White's scouting report
        if cbs_report
          scouting_profile.assign_attributes(
            cbs_overall_rank: cbs_report.cbs_overall_rank,
            cbs_team_rank: cbs_report.cbs_team_rank,
            cbs_future_value: cbs_report.cbs_future_value
          )
        end

        # Copy data from JJ Coopers's scouting report
        if ba_report
          scouting_profile.assign_attributes(
            ba_overall_rank: ba_report.ba_overall_rank,
            ba_team_rank: ba_report.ba_team_rank,
            ba_future_value: ba_report.ba_future_value
          )
        end

        # Copy data from Kiley McDaniel's scouting report
        if espn_report
          scouting_profile.assign_attributes(
            espn_overall_rank: espn_report.espn_overall_rank,
            espn_team_rank: espn_report.espn_team_rank,
            espn_future_value: espn_report.espn_future_value
          )
        end

        # Save the scouting profile
        scouting_profile.save!
      end
    end
  end
end

# "player_id"
# "timeline_id"
# "risk"
# "eta"
# "espn_overall_rank"
# "ath_overall_rank"
# "ba_overall_rank"
# "pl_overall_rank"
# "cbs_overall_rank"
# "fg_overall_rank"
# "self_overall_rank"
# "espn_team_rank"
# "ath_team_rank"
# "ba_team_rank"
# "pl_team_rank"
# "cbs_team_rank"
# "fg_team_rank"
# "self_team_rank"
# "espn_future_value"
# "ath_future_value"
# "ba_future_value"
# "pl_future_value"
# "cbs_future_value"
# "fg_future_value"
# "self_future_value"
# "bat_hit_pres"
# "bat_hit_proj"
# "bat_game_pwr_pres"
# "bat_game_pwr_proj"
# "bat_raw_pwr_pres"
# "bat_raw_pwr_proj"
# "bat_pit_sel"
# "bat_bat_ctrl"
# "bat_hard_hit"
# "bat_spd_pres"
# "bat_spd_proj"
# "bat_fld_pres"
# "bat_fld_proj"
# "pit_control_pres"
# "pit_control_proj"
# "pit_command_pres"
# "pit_command_proj"
# "pit_fastball_pres"
# "pit_fastball_proj"
# "pit_fastball_type"
# "pit_curve_pres"
# "pit_curve_proj"
# "pit_slider_pres"
# "pit_slider_proj"
# "pit_sweeper_pres"
# "pit_sweeper_proj"
# "pit_changeup_pres"
# "pit_changeup_proj"
# "pit_cutter_pres"
# "pit_cutter_proj"
# "pit_arm_pres"
# "pit_arm_proj"
# "recorded_at"
# "sits"
# "tops"
