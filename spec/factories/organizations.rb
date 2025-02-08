FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip }
    country { Faker::Address.country }
    fax_phone_number { Faker::PhoneNumber.phone_number }
    office_phone_number_1 { Faker::PhoneNumber.phone_number }
    office_phone_number_2 { Faker::PhoneNumber.phone_number }
    email_address_1 { Faker::Internet.email }
    email_address_2 { Faker::Internet.email }
    website_url { Faker::Internet.url }
    notes { Faker::Lorem.sentence(word_count: 12) }
  end
end
