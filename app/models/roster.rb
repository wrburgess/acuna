class Roster < ApplicationRecord
  has_many :players
  validates :name, presence: true
  validates :abbreviation, presence: true
end
