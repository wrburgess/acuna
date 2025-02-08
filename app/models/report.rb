class Report < ApplicationRecord
  include Archivable
  include Loggable

  scope :select_order, -> { order(name: :asc) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end
end
