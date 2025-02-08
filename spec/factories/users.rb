FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'foobar12' }
    password_confirmation { 'foobar12' }
    notes { Faker::Lorem.sentence(word_count: 12) }
    confirmed_at { Time.zone.now - 1.day }

    trait :owner do
      transient do
        resource { Link } # Default model
        operations { [:new] } # Default action
      end

      after(:create) do |user, evaluator|
        resource = evaluator.resource
        operations = evaluator.operations

        # Create system group, system role, and system_permission
        system_group = create(:system_group)
        system_role = create(:system_role)
        system_permissions = operations.map do |operation|
          create(:system_permission, name: "#{resource.name} #{operation.capitalize}", resource:, operation:)
        end

        # Associate system permissions with the system role
        system_role.system_permissions << system_permissions

        # Associate system role with the system group
        system_group.system_roles << system_role

        # Associate system group with the user
        system_group.users << user
      end
    end
  end
end
