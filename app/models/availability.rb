class Availability < ApplicationRecord
  belongs_to :user # The host of the event
  has_many :guests, through: :event_requests
end
