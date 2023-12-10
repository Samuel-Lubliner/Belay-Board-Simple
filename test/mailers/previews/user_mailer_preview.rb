class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/summary
  def summary
    # Ensure there's at least one user in your database for this to work
    user = User.first

    # You might want to add checks to ensure that the user exists
    return 'No users found' unless user.present?

    UserMailer.with(user: user).summary
  end
end
