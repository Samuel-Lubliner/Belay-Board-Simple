module ApplicationHelper
  def display_username(user)
    return 'Anonymous' if user.private_profile? && !current_user.friends_with?(user)
    user.username
  end
end
