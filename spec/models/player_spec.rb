require 'rails_helper'
require 'concerns/archivable_shared'
require 'concerns/loggable_shared'
require 'concerns/commentable_shared'

describe Player, type: :model do
  it_behaves_like 'archivable'
  it_behaves_like 'loggable'
  it_behaves_like 'commentable'

  it 'has a valid factory' do
    expect(create(:player)).to be_valid
  end

  it 'is invalid without a last name' do
    expect(build(:player, last_name: nil)).not_to be_valid
  end

  it 'is invalid without a first name' do
    expect(build(:player, first_name: nil)).not_to be_valid
  end
end
