require 'rails_helper'

RSpec.describe EmailNormalizer do
  subject(:normalizer) { described_class.new }

  describe '#call' do
    it 'normalizes email address' do
      expect(normalizer.call('  USER@EXAMPLE.COM  ')).to eq('user@example.com')
    end
  end

  describe 'integration with User model' do
    it 'normalizes email before validation' do
      user = User.new(email: '  USER@EXAMPLE.COM  ')
      user.valid?
      expect(user.email).to eq('user@example.com')
    end

    it 'handles multiple normalizations' do
      user = User.new(email: '  First@EXAMPLE.COM  ')
      user.valid?
      expect(user.email).to eq('first@example.com')

      user.email = '  SECOND@EXAMPLE.COM  '
      user.valid?
      expect(user.email).to eq('second@example.com')
    end
  end
end
