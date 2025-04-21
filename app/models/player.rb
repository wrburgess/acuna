class Player < ApplicationRecord
  include Archivable
  include Loggable
  include Commentable

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
  has_many :comments, as: :commentable, class_name: 'Comment', dependent: :destroy

  scope :select_order, -> { order(url_type: :asc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_level, ->(level) { where(level: level) }

  ransacker :player_level_weight do
    Arel.sql('levels.weight')
  end

  ransacker :player_status_weight do
    Arel.sql('statuses.weight')
  end

  def self.ransackable_attributes(*)
    %w[
      ab
      age
      archived_at
      bp_id
      bat_ctrl
      bavg
      bb
      bb_pct
      birthdate
      bref_id
      cbs_id
      cbs_name
      created_at
      cs
      errs
      espn_id
      espn_name
      eta
      fangraphs_id
      fangraphs_name
      fantrax_id
      fantrax_name
      first_name
      fld_proj
      game_pwr_proj
      hard_hit
      hits
      hr
      id
      k
      k_pct
      last_name
      level_id
      middle_name
      mlb_id
      mlb_name
      mlbam_id
      mlbam_name
      name_suffix
      nfbc_id
      nfbc_name
      notes
      nsb
      obp
      ops
      pa
      pit_sel
      player_level_weight
      player_status_weight
      player_type
      playerid
      position
      raw_pwr_proj
      razzball_id
      razzball_name
      rbi
      retro_id
      risk
      roster_id
      rotowire_id
      rotowire_name
      runs
      sb
      sfbb_id
      sfbb_name
      slg
      spd_proj
      status_id
      team_id
      updated_at
      war
      wrc_plus
      yahoo_id
      yahoo_name
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

  # ransacker :id do
  #   Arel::Nodes::SqlLiteral.new(
  #     "regexp_replace(to_char(\"#{table_name}\".\"id\", '99999999'), ' ', '', 'g')"
  #   )
  # end

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

  def dynamic_name_ascii
    [first_name, middle_name, last_name, name_suffix].reject(&:blank?).join(' ')
  end

  def batter?
    player_type == 'batter'
  end

  def pitcher?
    player_type == 'pitcher'
  end
end
