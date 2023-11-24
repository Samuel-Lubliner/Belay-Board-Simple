class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @event_requests = current_user.event_requests.includes(:availability)
  
    if params[:status].present?
      @event_requests = @event_requests.where(status: params[:status])
    end
  
    if params[:event_name].present?
      @event_requests = @event_requests.joins(:availability).where('availabilities.event_name ILIKE ?', "%#{params[:event_name]}%")
    end
  
    if params[:start_time].present? && params[:end_time].present?
      start_time = Date.parse(params[:start_time])
      end_time = Date.parse(params[:end_time])
      @event_requests = @event_requests.joins(:availability).where('availabilities.start_time >= ? AND availabilities.end_time <= ?', start_time, end_time)
    end

    @event_requests = @event_requests.joins(:availability).order('availabilities.start_time ASC')

  end
  
  
end
