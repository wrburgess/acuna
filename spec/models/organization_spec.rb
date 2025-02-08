require 'rails_helper'
require 'concerns/archivable_shared'
require 'concerns/loggable_shared'

describe Organization, type: :model do
  it_behaves_like 'archivable'
  it_behaves_like 'loggable'

  it 'has a valid factory' do
    expect(create(:organization)).to be_valid
  end

  it 'is invalid without a name' do
    expect(FactoryBot.build(:organization, name: nil)).not_to be_valid
  end
end
