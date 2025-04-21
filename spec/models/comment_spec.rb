require 'rails_helper'
require 'concerns/archivable_shared'
require 'concerns/loggable_shared'

describe Comment, type: :model do
  it_behaves_like 'archivable'
  it_behaves_like 'loggable'

  it 'has a valid factory' do
    expect(create(:comment)).to be_valid
  end

  it 'is invalid without a body' do
    expect(build(:comment, body: nil)).not_to be_valid
  end

  it 'belongs to a commentable object' do
    comment = create(:comment)
    expect(comment.commentable).to be_present
  end

  it 'belongs to a user' do
    comment = create(:comment)
    expect(comment.user).to be_present
  end

  describe '#user_initials' do
    it 'returns the first letter of first and last name' do
      user = create(:user, first_name: 'John', last_name: 'Doe')
      comment = create(:comment, user: user)
      expect(comment.user_initials).to eq('JD')
    end
  end

  describe '#formatted_date' do
    it 'returns the date in yyyy-mm-dd format' do
      comment = create(:comment)
      expect(comment.formatted_date).to eq(comment.created_at.strftime('%Y-%m-%d'))
    end
  end

  describe '#truncated_body' do
    it 'truncates the body to the specified length' do
      comment = create(:comment, body: 'A' * 150)
      expect(comment.truncated_body(100).length).to be <= 100
    end

    it 'does not truncate if body is shorter than max length' do
      comment = create(:comment, body: 'Short comment')
      expect(comment.truncated_body(100)).to eq('Short comment')
    end
  end
end
