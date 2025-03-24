class Team < ApplicationRecord
  include Archivable
  include Loggable

  has_many :players
  validates :name, presence: true
  validates :abbreviation, presence: true

  def self.ransackable_attributes(*)
    %w[
      abbreviation
      archived_at
      created_at
      id
      name
      notes
      updated_at
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
    ['name asc']
  end
end
