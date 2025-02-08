class Contact < ApplicationRecord
  include Archivable
  include Loggable

  validates :first_name, presence: true
  belongs_to :organization, optional: true

  scope :active, -> { where(archived_at: nil) }
  scope :select_order, -> { order(last_name: :asc, first_name: :asc) }

  def name
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_last_first
    "#{last_name}, #{first_name}"
  end

  def self.options_for_select
    select_order.active.map { |contact| [contact.full_name_last_first, contact.id] }
  end
end
