class Organization < ApplicationRecord
  include Archivable
  include Loggable

  validates :name, presence: true

  has_many :contacts

  scope :select_order, -> { order(name: :asc) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end
end
