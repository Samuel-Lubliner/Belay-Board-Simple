# == Schema Information
#
# Table name: availabilities
#
#  id           :bigint           not null, primary key
#  advanced     :boolean          default(FALSE)
#  beginner     :boolean          default(FALSE)
#  boulder      :boolean          default(FALSE)
#  end_time     :datetime
#  event_name   :string
#  indoor       :boolean          default(FALSE)
#  intermediate :boolean          default(FALSE)
#  lead         :boolean          default(FALSE)
#  learn        :boolean          default(FALSE)
#  location     :string
#  outdoor      :boolean          default(FALSE)
#  overhang     :boolean          default(FALSE)
#  slab         :boolean          default(FALSE)
#  sport        :boolean          default(FALSE)
#  start_time   :datetime
#  top_rope     :boolean          default(FALSE)
#  trad         :boolean          default(FALSE)
#  vertical     :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
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
  has_many :comments, dependent: :destroy

  #has_many :guests, through: :event_requests, source: :user

  validates :event_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "end_time", "event_name", "id", "start_time", "updated_at", "user_id", "advanced", "beginner", "boulder", "indoor", "instructor", "intermediate", "lead", "outdoor", "overhang", "slab", "sport", "top_rope", "trad", "vertical", "learn", "location"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "event_requests", "user"]
  end


  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

end
