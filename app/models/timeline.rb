class Timeline < ApplicationRecord
  include Archivable
  include Loggable

  validates :name, presence: true

  has_many :stats
  has_many :scouting_reports
  has_many :scouting_profiles

  scope :select_order, -> { order(weight: :asc) }
  scope :non_default, -> { where(default: false) }

  def self.ransackable_attributes(*)
    %w[
      abbreviation
      archived_at
      created_at
      default
      id
      name
      notes
      updated_at
      weight
    ]
  end

  def self.ransackable_associations(*)
    %w[
      stats
      scouting_reports
      scouting_profiles
    ]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['weight asc', 'name desc']
  end
end
