class Comment < ApplicationRecord
  include Loggable
  include Archivable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  # Scopes
  scope :active, -> { where(archived_at: nil) }

  # Methods
  def truncated_body
    body.truncate(100)
  end
end
