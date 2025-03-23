class TrackingList < ApplicationRecord
  include Archivable
  include Loggable

  belongs_to :user
  has_many :tracking_list_players
  has_many :players, through: :tracking_list_players

  validates :name, presence: true

  def self.ransackable_attributes(*)
    %w[
      archived_at
      created_at
      id
      name
      notes
      updated_at
      user_id
    ]
  end

  def self.ransackable_associations(*)
    %i[
      user
      players
      tracking_list_players
    ]
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    ['name asc']
  end
end
