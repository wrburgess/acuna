FactoryBot.define do
  factory :screener_order_item do
    screener { nil }
    screener_order { nil }
    amount { 1 }
  end
end
