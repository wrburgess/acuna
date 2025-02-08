class Link < ApplicationRecord
  include Archivable
  include Loggable

  validates :url, presence: true

  scope :select_order, -> { order(url_type: :asc) }

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      id
      updated_at
      url
      url_type
    ]
  end

  def self.ransackable_associations(*)
    []
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['url asc', 'created_at desc']
  end

  def name
    url
  end
end
