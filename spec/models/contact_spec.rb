require 'rails_helper'
require 'concerns/archivable_shared'
require 'concerns/loggable_shared'

describe Contact, type: :model do
  it_behaves_like 'archivable'
  it_behaves_like 'loggable'

  it { is_expected.to validate_presence_of :first_name }

  it 'has a valid factory' do
    expect(create(:contact)).to be_valid
  end

  it 'is invalid without a first_name' do
    expect(FactoryBot.build(:contact, first_name: nil)).not_to be_valid
  end
end
