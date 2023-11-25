# == Schema Information
#
# Table name: availabilities
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  event_name :string
#  start_time :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_availabilities_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Availability < ApplicationRecord
  belongs_to :user # The host of the event
  has_many :event_requests, dependent: :destroy
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
