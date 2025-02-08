require 'rails_helper'
require 'concerns/archivable_shared'
require 'concerns/loggable_shared'

describe Report, type: :model do
  it_behaves_like 'archivable'
  it_behaves_like 'loggable'

  it 'has a valid factory' do
    expect(create(:report)).to be_valid
  end
end
