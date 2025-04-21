# app/models/concerns/commentable.rb

module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, class_name: 'Admin::Comment', dependent: :destroy
  end

  def add_comment(user, body)
    comments.create(user:, body:)
  end
end
