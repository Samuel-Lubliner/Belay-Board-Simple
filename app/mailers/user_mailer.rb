class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.summary.subject
  #
  def summary
    user = params[:user]
    @greeting = "Hi #{user.username}"

    # Fetch avaiabilities created by the user for the next day
    @user_availabilities = Availability.where(user_id: user.id)
                                       .where('start_time >= ? AND start_time < ?', Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day)

    # Fetch availabilities where user is accepted in event requests
    @accepted_availabilities = Availability.joins(:event_requests)
                                           .where(event_requests: { user_id: user.id, status: 'accepted' })
                                           .where('start_time >= ? AND start_time < ?', Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day)

    mail to: user.email, subject: "Your Next Day's Availabilities Summary"
  end
end
