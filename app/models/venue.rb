class Venue < ApplicationRecord
  include Loggable

  validates :name, presence: true

  scope :select_order, -> { order('name ASC') }

  def self.ransackable_attributes(*)
    %w[
      created_at
      name
      updated_at
    ]
  end

  def self.ransackable_associations(*); end

  def self.options_for_select
    select_order.map { [it.name, it.id] }
  end

  def self.default_sort
    ['name asc', 'created_at desc']
  end
end
