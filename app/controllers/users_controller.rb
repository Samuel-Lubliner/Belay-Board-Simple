class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @climbers_data = {
      'Beginner' => Climber.where(beginner: true).count,
      'Intermediate' => Climber.where(intermediate: true).count,
      'Advanced' => Climber.where(advanced: true).count,

    }

    @availability_data = {
      'Boulder' => Availability.where(boulder: true).count,
      'Top Rope' => Availability.where(top_rope: true).count,
      'Lead' => Availability.where(lead: true).count
    }

    @climbing_styles_data = {
      'Boulder' => Climber.where(boulder: true).count,
      'Top Rope' => Climber.where(top_rope: true).count,
      'Lead' => Climber.where(lead: true).count
    }


  end
end
