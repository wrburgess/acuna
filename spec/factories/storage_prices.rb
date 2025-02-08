FactoryBot.define do
  factory :storage_price do
    storage_service { 'MyString' }
    storage_service_class { 'MyString' }
    storage_service_region { 'MyString' }
    price_per_gb_hour { '9.99' }
  end
end
