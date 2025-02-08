FactoryBot.define do
  factory :report do
    name { Faker::Company.bs }
    description { Faker::Lorem.sentence(word_count: 12) }
    sql { generate_fake_sql }
    notes { Faker::Lorem.sentence(word_count: 12) }
  end
end

def generate_fake_sql
  table_name = Faker::Lorem.word
  column_names = Array.new(3) { Faker::Lorem.word }
  conditions = Array.new(2) { "#{Faker::Lorem.word} = '#{Faker::Lorem.word}'" }

  "SELECT #{column_names.join(', ')} FROM #{table_name} WHERE #{conditions.join(' AND ')};"
end
