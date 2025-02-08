FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    title { Faker::Job.title }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip }
    country { Faker::Address.country }
    direct_phone_number { Faker::PhoneNumber.phone_number }
    office_phone_number { Faker::PhoneNumber.phone_number }
    fax_phone_number { Faker::PhoneNumber.phone_number }
    email_address_1 { Faker::Internet.email }
    email_address_2 { Faker::Internet.email }
    notes { Faker::Lorem.sentence(word_count: 12) }
  end
end
