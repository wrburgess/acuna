class Player < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :roster, optional: true
  belongs_to :team, optional: true
  has_many :stats, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true

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
    ]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['last_name asc', 'first_name desc']
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ').titleize.strip
  end
end
