class Scout < ApplicationRecord
  include Archivable
  include Loggable

  has_many :scouting_reports, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :select_order, -> { order(last_name: :asc) }

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      first_name
      id
      last_name
      company
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    %i[
      scouting_reports
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
