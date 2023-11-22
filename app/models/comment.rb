# == Schema Information
#
# Table name: comments
#
#  id              :bigint           not null, primary key
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  availability_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_comments_on_availability_id  (availability_id)
#  index_comments_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (availability_id => availabilities.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates :body, presence: true

end
