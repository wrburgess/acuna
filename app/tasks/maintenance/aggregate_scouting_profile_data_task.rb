require 'csv'

module Maintenance
  class AggregateScoutingProfileDataTask < MaintenanceTasks::Task
    no_collection

    attribute :timeline_abbrev, :string, default: '2025'

    def process
      timeline = Timeline.find_by!(abbreviation: timeline_abbrev)
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
            tj_at: fangraphs_report.tj_at,
            fg_overall_rank: fangraphs_report.overall_ranking,
            fg_team_rank: fangraphs_report.team_ranking,
            fg_future_value: fangraphs_report.future_value,
            sits: fangraphs_report.sits,
            tops: fangraphs_report.tops,
            bat_hit_pres: fangraphs_report.hit_pres,
            bat_hit_proj: fangraphs_report.hit_proj,
            bat_game_pwr_pres: fangraphs_report.game_pwr_pres,
            bat_game_pwr_proj: fangraphs_report.game_pwr_proj,
            bat_raw_pwr_pres: fangraphs_report.raw_pwr_pres,
            bat_raw_pwr_proj: fangraphs_report.raw_pwr_proj,
            bat_pit_sel: fangraphs_report.pit_sel,
            bat_bat_ctrl: fangraphs_report.bat_ctrl,
            bat_hard_hit: fangraphs_report.hard_hit,
            bat_spd_pres: fangraphs_report.spd_pres,
            bat_spd_proj: fangraphs_report.spd_proj,
            bat_fld_pres: fangraphs_report.fld_pres,
            bat_fld_proj: fangraphs_report.fld_proj,
            pit_control_pres: fangraphs_report.control_pres,
            pit_control_proj: fangraphs_report.control_proj,
            pit_command_pres: fangraphs_report.command_pres,
            pit_command_proj: fangraphs_report.command_proj,
            pit_fastball_pres: fangraphs_report.fastball_pres,
            pit_fastball_proj: fangraphs_report.fastball_proj,
            pit_fastball_type: fangraphs_report.fastball_type,
            pit_curve_pres: fangraphs_report.curve_pres,
            pit_curve_proj: fangraphs_report.curve_proj,
            pit_slider_pres: fangraphs_report.slider_pres,
            pit_slider_proj: fangraphs_report.slider_proj,
            pit_sweeper_pres: fangraphs_report.sweeper_pres,
            pit_sweeper_proj: fangraphs_report.sweeper_proj,
            pit_changeup_pres: fangraphs_report.changeup_pres,
            pit_changeup_proj: fangraphs_report.changeup_proj,
            pit_cutter_pres: fangraphs_report.cutter_pres,
            pit_cutter_proj: fangraphs_report.cutter_proj,
            pit_arm_pres: fangraphs_report.arm_pres,
            pit_arm_proj: fangraphs_report.arm_proj
          )
        end

        # Copy data from Keith Law's scouting report
        if athletic_report
          scouting_profile.assign_attributes(
            ath_overall_rank: athletic_report.overall_ranking,
            ath_team_rank: athletic_report.team_ranking,
            ath_future_value: athletic_report.future_value
          )
        end

        # Copy data from Scott White's scouting report
        if cbs_report
          scouting_profile.assign_attributes(
            cbs_overall_rank: cbs_report.overall_ranking,
            cbs_team_rank: cbs_report.team_ranking,
            cbs_future_value: cbs_report.future_value
          )
        end

        # Copy data from JJ Coopers's scouting report
        if ba_report
          scouting_profile.assign_attributes(
            ba_overall_rank: ba_report.overall_ranking,
            ba_team_rank: ba_report.team_ranking,
            ba_future_value: ba_report.future_value
          )
        end

        # Copy data from Kiley McDaniel's scouting report
        if espn_report
          scouting_profile.assign_attributes(
            espn_overall_rank: espn_report.overall_ranking,
            espn_team_rank: espn_report.team_ranking,
            espn_future_value: espn_report.future_value
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
# "espn_overall_ranking"
# "ath_overall_ranking"
# "ba_overall_ranking"
# "pl_overall_ranking"
# "cbs_overall_ranking"
# "fg_overall_ranking"
# "self_overall_ranking"
# "espn_team_ranking"
# "ath_team_ranking"
# "ba_team_ranking"
# "pl_team_ranking"
# "cbs_team_ranking"
# "fg_team_ranking"
# "self_team_ranking"
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
