class Widget < ApplicationRecord
  include Archivable
  include Loggable

  has_many :order_items, as: :itemable

  scope :active, -> { where(archived_at: nil) }
  scope :select_order, -> { order(created_at: :asc) }

  def self.options_for_select
    select_order.active.map { |instance| [instance.name, instance.id] }
  end
end
