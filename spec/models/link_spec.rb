require 'rails_helper'
require 'concerns/archivable_shared'
require 'concerns/loggable_shared'

describe Link, type: :model do
  it_behaves_like 'archivable'
  it_behaves_like 'loggable'

  it 'has a valid factory' do
    expect(create(:link, url: Faker::Internet.url)).to be_valid
  end

  it 'is invalid without a url' do
    expect(FactoryBot.build(:link, url: nil)).not_to be_valid
  end
end
