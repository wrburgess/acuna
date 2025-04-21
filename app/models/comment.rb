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

  def user_initials
    user&.first_name.to_s[0] + user&.last_name.to_s[0]
  end

  def formatted_date
    created_at.strftime('%Y-%m-%d')
  end

  def truncated_body(max_length = 100)
    body.truncate(max_length)
  end
end
