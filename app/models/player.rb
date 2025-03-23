class Player < ApplicationRecord
  include Archivable
  include Loggable

  validates :last_name, presence: true
  validates :first_name, presence: true

  belongs_to :roster, optional: true
  belongs_to :team, optional: true
  has_many :stats, dependent: :destroy
  has_many :scouting_profiles, dependent: :destroy
  has_many :scouting_reports, dependent: :destroy
  has_many :tracking_list_players, dependent: :destroy
  has_many :tracking_lists, through: :tracking_list_players

  # Status and level constants
  STATUSES = %w[prospect show retired].freeze
  LEVELS = ['CAR', 'MEX', 'KOR', 'JPN', 'INTL', 'USHS', 'NCAA', 'LOW A', 'HIGH A', 'AA', 'AAA', 'MLB'].freeze

  scope :select_order, -> { order(url_type: :asc) }

  # Add scopes for the new attributes
  scope :prospects, -> { where(status: 'prospect') }
  scope :active, -> { where(status: 'show') }
  scope :retired, -> { where(status: 'retired') }
  scope :by_level, ->(level) { where(level: level) }

  # Level scopes
  scope :mlb_level, -> { where(level: 'MLB') }
  scope :minor_league, -> { where(level: ['LOW A', 'HIGH A', 'AA', 'AAA']) }
  scope :international, -> { where(level: %w[CAR MEX KOR JPN INTL]) }
  scope :amateur, -> { where(level: %w[USHS NCAA]) }

  # Validation for allowed values
  validates :status, inclusion: { in: %w[prospect show retired] }, allow_nil: true
  validates :level, inclusion: { in: ['CAR', 'MEX', 'KOR', 'JPN', 'INTL', 'USHS', 'NCAA', 'LOW A', 'HIGH A', 'AA', 'AAA', 'MLB'] }, allow_nil: true

  # ransacker :tracking_list_id, formatter: proc { |v| v.to_i } do |_parent|
  #   Arel.sql(<<~SQL.squish)
  #     EXISTS (
  #       SELECT 1
  #       FROM tracking_list_players
  #       WHERE tracking_list_players.player_id = players.id
  #         AND tracking_list_players.tracking_list_id = #{ActiveRecord::Base.connection.quote(v.to_i)}
  #     )
  #   SQL
  # end

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      first_name
      middle_name
      id
      last_name
      level
      notes
      position
      roster_id
      status
      team_id
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %i[
      team
      roster
      tracking_list_players
      tracking_lists
    ]
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
