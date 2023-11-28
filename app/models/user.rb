# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  advanced               :boolean          default(FALSE)
#  beginner               :boolean          default(FALSE)
#  bio                    :string           default("add bio ...")
#  boulder                :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  indoor                 :boolean          default(FALSE)
#  intermediate           :boolean          default(FALSE)
#  is_staff               :boolean          default(FALSE)
#  lead                   :boolean          default(FALSE)
#  outdoor                :boolean          default(FALSE)
#  overhang               :boolean          default(FALSE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  slab                   :boolean          default(FALSE)
#  sport                  :boolean          default(FALSE)
#  top_rope               :boolean          default(FALSE)
#  trad                   :boolean          default(FALSE)
#  username               :citext           not null
#  vertical               :boolean          default(FALSE)
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

  has_many :availabilities # Events they are hosting
  has_many :event_requests # Requests they've made to join events
  has_many :comments, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["id", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "event_requests", "availability"]
  end

end
