class Users::SessionsController < Devise::SessionsController
  def new
    @total_availabilities = Availability.count
    @total_climbers = Climber.count
    super
  end
end
