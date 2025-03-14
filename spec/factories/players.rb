FactoryBot.define do
  factory :player do
    first_name { "MyString" }
    last_name { "MyString" }
    position { "MyString" }
    birthdate { "2025-03-14" }
    roster { nil }
    team { nil }
  end
end
