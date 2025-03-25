class Player < ApplicationRecord
  include Archivable
  include Loggable

  validates :last_name, presence: true
  validates :first_name, presence: true

  belongs_to :roster, optional: true
  belongs_to :team, optional: true
  belongs_to :level, optional: true
  belongs_to :status, optional: true
  has_many :stats, dependent: :destroy
  has_many :scouting_profiles, dependent: :destroy
  has_many :scouting_reports, dependent: :destroy
  has_many :tracking_list_players, dependent: :destroy
  has_many :tracking_lists, through: :tracking_list_players

  scope :select_order, -> { order(url_type: :asc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_level, ->(level) { where(level: level) }

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      first_name
      middle_name
      id
      last_name
      level_id
      name_suffix
      notes
      position
      roster_id
      status_id
      team_id
      updated_at
      age
      hr
      ops
      rbi
      runs
      nsb
      errs
      wrc_plus
      pa
      ab
      hits
      bb
      bb_pct
      k
      k_pct
      sb
      cs
      bavg
      obp
      slg
      war
      risk
      eta
      game_pwr_proj
      raw_pwr_proj
      spd_proj
      fld_proj
      pit_sel
      bat_ctrl
      hard_hit
    ]
  end

  def self.ransackable_associations(*)
    %w[
      team
      roster
      level
      status
      tracking_list_players
      tracking_lists
    ]
  end

  # Stats ransackers
  %w[hr ops rbi runs nsb errs pa ab hits bb bb_pct k k_pct sb cs bavg obp slg war wrc_plus].each do |stat|
    ransacker stat.to_sym do
      Arel.sql("stats.#{stat}")
    end
  end

  # Scouting ransackers
  %w[risk eta game_pwr_proj raw_pwr_proj spd_proj fld_proj pit_sel bat_ctrl hard_hit].each do |attr|
    ransacker attr.to_sym do
      Arel.sql("scouting_profiles.#{attr}")
    end
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['last_name asc', 'first_name desc']
  end

  def name
    [first_name, last_name].join(' ').titleize.strip
  end

  def full_description
    "#{name}, #{team&.abbreviation} (#{eligible_positions.join(', ')})"
  end
end
