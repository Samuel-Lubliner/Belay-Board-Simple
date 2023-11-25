class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :username

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :availabilities # Events they are hosting
  has_many :event_requests # Requests they've made to join events
end
