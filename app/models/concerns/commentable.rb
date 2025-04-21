module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, class_name: 'Comment', dependent: :destroy
  end

  def add_comment(user, body)
    comments.create(user:, body:)
  end
end
