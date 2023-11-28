class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @q = Availability.ransack(params[:q])
    @availabilities = @q.result.includes(:user, event_requests: :user)
  end

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end
    
end
