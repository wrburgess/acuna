class Stat < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :player

  validates :timeline, presence: true
  validates :timeline_type, presence: true

  scope :archived, -> { where.not(archived_at: nil) }
  scope :unarchived, -> { where(archived_at: nil) }
  scope :select_order, -> { order(timeline: :asc) }

  def archive
    update(archived_at: Time.current)
  end

  def unarchive
    update(archived_at: nil)
  end

  def self.ransackable_attributes(*)
    %w[
      _2b
      _3b
      ab
      archived_at
      avg
      ba_rank
      bb
      cbs_rank
      created_at
      cs
      fg_bat_ctrl
      fg_fld_pres
      fg_fld_proj
      fg_fv
      fg_hard_hit
      fg_hit_pres
      fg_hit_proj
      fg_org_rank
      fg_pit_sel
      fg_pwr_pres
      fg_pwr_proj
      fg_spd_pres
      fg_spd_proj
      fg_top_rank
      hits
      hr
      id
      k
      kl_rank
      mcd_fv
      mcd_rank
      mlb_rank
      obp
      pa
      player_id
      rbi
      runs
      sb
      slg
      team_id
      timeline
      timeline_type
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %i[
      player
      team
    ]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.display_name, instance.id] }
  end

  def self.default_sort
    'created_at desc'
  end

  def display_name
    "#{player.try(:name)} - #{timeline} (#{timeline_type})"
  end

  def class_name_title
    self.class.name
  end
end
