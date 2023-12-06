module ApplicationHelper
  def display_username(user)
    # Show the actual username if the user is the current user or if the profile is public
    # or if the current user is friends with the user.
    if user == current_user || user.is_public || current_user.friends_with?(user)
      user.username
    else
      'Anonymous'
    end
  end
end
