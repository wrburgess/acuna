class Status < ApplicationRecord
  include Archivable
  include Loggable

  validates :name, presence: true

  has_many :players

  scope :select_order, -> { order(weight: :asc) }

  def self.ransackable_attributes(*)
    %w[
      abbreviation
      archived_at
      created_at
      id
      name
      updated_at
      weight
    ]
  end

  def self.ransackable_associations(*)
    %w[
      players
    ]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['weight asc', 'name desc']
  end
end
