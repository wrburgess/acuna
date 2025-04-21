FactoryBot.define do
  factory :admin_comment, class: 'Admin::Comment' do
    body { Faker::Lorem.paragraph(sentence_count: 3) }
    association :user
    association :commentable, factory: :player
  end
end
