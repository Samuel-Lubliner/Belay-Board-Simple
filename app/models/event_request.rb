class EventRequest < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }

  validates :user_id, uniqueness: { scope: :availability_id }

  # def accept
  #   update(status: 'accepted')
  # end

  # def reject
  #   update(status: 'rejected')
  # end
  
end
