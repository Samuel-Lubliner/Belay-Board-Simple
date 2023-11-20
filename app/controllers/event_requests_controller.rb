class EventRequestsController < ApplicationController
  before_action :set_event_request, only: %i[show edit update destroy]

  def create
    @event_request = current_user.event_requests.new(event_request_params)

    if @event_request.save
      # Handle success (e.g., redirect with a success message)
    else
      # Handle failure (e.g., render form again with error messages)
    end
  end

  def accept
    event_request = EventRequest.find(params[:id])
    if event_request.availability.user == current_user
      event_request.accept
      # Success message and redirect
    else
      # Error message and redirect
    end
  end
  
  def reject
    event_request = EventRequest.find(params[:id])
    if event_request.availability.user == current_user
      event_request.reject
      # Success message and redirect
    else
      # Error message and redirect
    end
  end

  private

  def event_request_params
    params.require(:event_request).permit(:availability_id)
    # Do not include :user_id, it's set automatically to current_user
  end
  
end
