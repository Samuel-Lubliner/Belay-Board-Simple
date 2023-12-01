# == Schema Information
#
# Table name: climbers
#
#  id           :bigint           not null, primary key
#  advanced     :boolean          default(FALSE)
#  beginner     :boolean          default(FALSE)
#  bio          :string           default("add bio ...")
#  boulder      :boolean          default(FALSE)
#  indoor       :boolean          default(FALSE)
#  instructor   :boolean          default(FALSE)
#  intermediate :boolean          default(FALSE)
#  lead         :boolean          default(FALSE)
#  outdoor      :boolean          default(FALSE)
#  overhang     :boolean          default(FALSE)
#  slab         :boolean          default(FALSE)
#  sport        :boolean          default(FALSE)
#  top_rope     :boolean          default(FALSE)
#  trad         :boolean          default(FALSE)
#  vertical     :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_climbers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Climber < ApplicationRecord

  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    ["id", "username", "bio", "instructor", "boulder", "top_rope", "lead", "vertical", "slab", "overhang", "beginner", "intermediate", "advanced", "sport", "trad", "indoor", "outdoor"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["availability", "user"]
  end

end
