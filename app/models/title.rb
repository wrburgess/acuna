class Title < ApplicationRecord
  include Loggable

  belongs_to :label

  def self.ransackable_attributes(*)
    %w[
      created_at
      name
      updated_at
    ]
  end

  def self.ransackable_associations(*)
    [:label]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['name asc', 'created_at desc']
  end
end
