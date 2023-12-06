# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  is_public              :boolean          default(TRUE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :citext           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_one :climber, dependent: :destroy
  after_create :create_climber_profile

  has_many :availabilities # Events they are hosting
  has_many :event_requests # Requests they've made to join events
  has_many :comments, dependent: :destroy

  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: :sender_id
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: :receiver_id

  def self.ransackable_attributes(auth_object = nil)
    ["id", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "event_requests", "availability", "climbers"]
  end

  private

  def create_climber_profile
    build_climber.save
  end

end
