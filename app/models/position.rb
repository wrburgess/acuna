class Position < ApplicationRecord
  include Archivable
  include Loggable

  validates :name, presence: true

  has_many :players

  scope :select_order, -> { order(weight: :asc) }
  scope :by_player_type, ->(player_type) { where(player_type: player_type) }

  def self.ransackable_attributes(*)
    %w[
      abbreviation
      alternate_names
      archived_at
      collective_values
      created_at
      id
      name
      notes
      player_type
      position_type
      updated_at
      weight
    ]
  end

  def self.ransackable_associations(*)
    %w[]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['weight asc', 'name desc']
  end
end
