class Label < ApplicationRecord
  include Archivable
  include Loggable

  validates :name, presence: true

  has_many :titles

  scope :select_order, -> { order('name ASC') }

  def self.options_for_select
    select_order.map { |label| [label.name, label.id] }
  end
end
