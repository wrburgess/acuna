class OrderItem < ApplicationRecord
  belongs_to :itemable, polymorphic: true
  belongs_to :order
end
