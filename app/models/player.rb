class Player < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :roster, optional: true
  belongs_to :team, optional: true
  has_many :stats, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :select_order, -> { order(url_type: :asc) }

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      first_name
      id
      last_name
      notes
      position
      roster_id
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
    "#{first_name} #{last_name}.titleize.strip"
  end
end
