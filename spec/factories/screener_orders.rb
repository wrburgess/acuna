FactoryBot.define do
  factory :screener_order do
    user { nil }
    amount { 1 }
    card_brand { "MyString" }
    card_last4 { "MyString" }
    card_exp_month { "MyString" }
    card_exp_year { "MyString" }
    stripe_id { "MyString" }
  end
end
