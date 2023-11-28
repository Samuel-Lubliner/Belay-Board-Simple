# == Schema Information
#
# Table name: event_requests
#
#  id              :bigint           not null, primary key
#  status          :string           default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  availability_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_event_requests_on_availability_id  (availability_id)
#  index_event_requests_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (availability_id => availabilities.id)
#  fk_rails_...  (user_id => users.id)
#
class EventRequest < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }

  validates :user_id, uniqueness: { scope: :availability_id }

  def accept
    update(status: 'accepted')
  end

  def reject
    update(status: 'rejected')
  end

  def self.ransackable_attributes(auth_object = nil)
    ["availability_id", "created_at", "id", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["availability", "user"]
  end

end
