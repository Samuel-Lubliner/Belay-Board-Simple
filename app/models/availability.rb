class Availability < ApplicationRecord
  belongs_to :user # The host of the event
  has_many :event_requests
  #has_many :guests, through: :event_requests, source: :user

  validates :event_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  # def accepted_guests
  # end

end
