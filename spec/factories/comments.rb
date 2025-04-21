FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 3) }
    association :user
    association :commentable, factory: :player
  end
end
