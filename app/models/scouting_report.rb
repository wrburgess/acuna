class ScoutingReport < ApplicationRecord
  include Archivable
  include Loggable
  include Commentable

  belongs_to :scout
  belongs_to :player
  belongs_to :timeline

  has_many :scouting_profile_reports, dependent: :destroy
  has_many :scouting_profiles, through: :scouting_profile_reports

  validates :reported_at, presence: true

  scope :select_order, -> { order(reported_at: :desc) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.ransackable_attributes(*)
    %w[
      archived_at
      arm_pres
      arm_proj
      bat_ctrl
      changeup_pres
      changeup_proj
      control_pres
      control_proj
      created_at
      cutter_pres
      cutter_proj
      fastball_pres
      fastball_proj
      field_pres
      field_proj
      fld_pres
      fld_proj
      future_value
      hard_hit
      hit_pres
      hit_proj
      id
      overall_ranking
      pit_sel
      power_pres
      power_proj
      pwr_pres
      pwr_proj
      reported_at
      risk
      spd_pres
      spd_proj
      speed_pres
      speed_proj
      sweeper_pres
      sweeper_proj
      team_ranking
      timeline
      title
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %w[
      scout
      player
      timeline
    ]
  end

  def self.default_sort
    ['reported_at desc']
  end

  def name
    "#{player.name} by #{scout.name} - #{reported_at}"
  end
end
