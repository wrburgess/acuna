FactoryBot.define do
  factory :storage_asset_session do
    setting { StorageAssetSession::DROPBOX_CURSOR }
    value { 'cursor_value' }

    trait :dropbox_access_token do
      setting { StorageAssetSession::DROPBOX_ACCESS_TOKEN }
      value { 'access_token_value' }
      expires_at { 4.hours.from_now }
    end

    trait :microsoft_graph_token do
      setting { StorageAssetSession::MICROSOFT_GRAPH_TOKEN }
      value { 'access_token_value' }
      expires_at { 1.hour.from_now }
    end
  end
end
