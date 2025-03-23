class TrackingListPlayer < ApplicationRecord
  belongs_to :tracking_list
  belongs_to :player

  validates :tracking_list_id, uniqueness: { scope: :player_id }

  def self.ransackable_attributes(*)
    %w[
      id
      player_id
      tracking_list_id
      user_id
    ]
  end

  def self.ransackable_associations(*)
    %i[
      user
      tracking_list_player
      tracking_list
    ]
  end
end
