class ScoutingProfile < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :player
  has_many :scouting_profile_reports, dependent: :destroy
  has_many :scouting_reports, through: :scouting_profile_reports

  validates :player_id, presence: true

  scope :select_order, -> { order(reported_at: :desc) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.ransackable_attributes(*)
    %w[
      archived_at
      arm_pres
      arm_proj
      ath_fv
      ath_ovr_rnk
      ath_tm_rnk
      ba_fv
      ba_ovr_rnk
      ba_tm_rnk
      bat_ctrl
      cbs_fv
      cbs_ovr_rnk
      cbs_tm_rnk
      changeup_pres
      changeup_proj
      command_pres
      command_proj
      control_pres
      control_proj
      created_at
      curve_pres
      curve_proj
      cutter_pres
      cutter_proj
      espn_fv
      espn_ovr_rnk
      espn_tm_rnk
      eta
      fastball_pres
      fastball_proj
      fastball_type
      field_pres
      field_proj
      fld_pres
      fld_proj
      future_value
      game_pwr_pres
      game_pwr_proj
      hard_hit
      hit_pres
      hit_proj
      id
      overall_ranking
      pit_sel
      pl_fv
      pl_ovr_rnk
      pl_tm_rnk
      player_id
      power_pres
      power_proj
      pwr_pres
      pwr_proj
      raw_pwr_pres
      raw_pwr_proj
      risk
      self_fv
      self_ovr_rnk
      self_tm_rnk
      slider_pres
      slider_proj
      spd_pres
      spd_proj
      speed_pres
      speed_proj
      sweeper_pres
      sweeper_proj
      team_ranking
      timeline
      timeline_type
      title
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %i[
      scouting_reports
      player
    ]
  end

  def self.default_sort
    ['created_at desc']
  end

  def name
    "#{player.name} - #{created_at}"
  end
end
