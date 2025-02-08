FactoryBot.define do
  factory :storage_asset do
    service { StorageAssetServices::AZURE }
    sequence(:name) { |n| "movie_file_#{n}.mov" }
    full_path { "/movies/mov_files/#{name}" }
    size_bytes { 186_272_294_776 }
    asset_created_at { 1.week.ago }
    asset_updated_at { Time.current }

    trait :azure_archive do
      service { StorageAssetServices::AZURE }
      access_tier { StorageAssetServiceTiers::AZURE::ARCHIVE }
    end

    trait :s3_standard do
      service { StorageAssetServices::S3 }
      access_tier { StorageAssetServiceTiers::AWS::STANDARD }
    end

    trait :s3_glacier do
      service { StorageAssetServices::S3 }
      access_tier { StorageAssetServiceTiers::AWS::GLACIER }
    end

    trait :s3_unarchiving do
      service { StorageAssetServices::S3 }
      access_tier { StorageAssetServiceTiers::AWS::UNARCHIVING }
    end

    trait :s3_temp_restore do
      service { StorageAssetServices::S3 }
      access_tier { StorageAssetServiceTiers::AWS::TEMPORARILY_RESTORED }
    end
  end
end
