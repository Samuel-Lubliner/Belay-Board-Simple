# == Schema Information
#
# Table name: friend_requests
#
#  id          :bigint           not null, primary key
#  status      :string           default("pending")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint
#  sender_id   :bigint
#
class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :sender_id, uniqueness: { scope: :receiver_id, message: 'Friend request already sent.' }
  validate :not_self

  private

  def not_self
    errors.add(:receiver_id, "can't be equal to sender") if sender_id == receiver_id
  end
end
