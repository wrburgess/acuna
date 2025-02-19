class ScreeningRequest < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :user, optional: true
  belongs_to :title, optional: true
  has_one :label, through: :title
  has_many :order_items, as: :itemable

  scope :active, -> { where(archived_at: nil) }
  scope :select_order, -> { order('created_at ASC') }

  def self.options_for_select
    select_order.active.map { |instance| [instance.name, instance.id] }
  end

  def name
    title.name
  end
end
