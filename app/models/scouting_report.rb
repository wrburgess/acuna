class ScoutingReport < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :scout
  belongs_to :player

  validates :reported_at, presence: true

  scope :select_order, -> { order(reported_at: :desc) }
  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.ransackable_attributes(*)
    %w[
      archived_at
      bat_ctrl
      created_at
      fld_pres
      fld_proj
      future_value
      hard_hit
      hit_pres
      hit_proj
      id
      overall_ranking
      pit_sel
      pwr_pres
      pwr_proj
      reported_at
      spd_pres
      spd_proj
      team_ranking
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %i[
      scout
      player
    ]
  end

  def self.default_sort
    ['reported_at desc']
  end

  def name
    "#{player.name} by #{scout.name} - #{reported_at}"
  end
end
