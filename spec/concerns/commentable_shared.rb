require 'rails_helper'

shared_examples 'commentable' do
  it 'has many comments' do
    instance_of_class = FactoryBot.create(described_class.to_s.underscore.to_sym)
    comment = FactoryBot.create(:comment, commentable: instance_of_class)

    instance_of_class.reload
    expect(instance_of_class.comments).to include(comment)
  end

  it 'destroys dependent comments when destroyed' do
    instance_of_class = FactoryBot.create(described_class.to_s.underscore.to_sym)
    FactoryBot.create(:comment, commentable: instance_of_class)

    expect do
      instance_of_class.destroy
    end.to change(Comment, :count).by(-1)
  end
end
