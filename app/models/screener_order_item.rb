class ScreenerOrderItem < ApplicationRecord
  belongs_to :screener
  belongs_to :screener_order
end
