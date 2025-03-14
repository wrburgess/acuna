class Player < ApplicationRecord
  belongs_to :roster
  belongs_to :team
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :position, presence: true
  validates :birthdate, presence: true
end
