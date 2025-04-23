class Comment < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  scope :select_order, -> { order(created_at: :desc) }

  def self.ransackable_attributes(*)
    %w[
      archived_at
      body
      commentable_id
      commentable_type
      created_at
      id
      updated_at
      user_id
    ]
  end

  def self.ransackable_associations(*)
    %w[
      commentable
      user
    ]
  end

  def self.default_sort
    ['created_at desc']
  end
end