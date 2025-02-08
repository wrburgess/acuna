FactoryBot.define do
  factory :link do
    url_type { UrlTypes.all.sample }
    url { Faker::Internet.url }
    notes { Faker::Lorem.sentence }
  end
end
