class ScoutingReport < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :scout
  belongs_to :player

  validates :reported_at, presence: true

  scope :select_order, -> { order(name: :asc) }
  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      first_name
      id
      last_name
      company
      updated_at
      ranking
      future_value
    ]
  end

  def self.ransackable_associations(*)
    %i[
      scouting_reports
    ]
  end

  def self.default_sort
    ['last_name asc', 'first_name desc']
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ').titleize.strip
  end
end
