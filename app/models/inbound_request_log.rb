class InboundRequestLog < ApplicationRecord
  validates :service, presence: true
  validates :meta, presence: true
end
