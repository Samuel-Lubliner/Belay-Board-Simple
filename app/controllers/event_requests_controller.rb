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
    @event_request = EventRequest.find(params[:id])
    if @event_request.availability.user == current_user
      @event_request.update(status: 'accepted')
  
      respond_to do |format|
        format.html { redirect_to some_path, notice: 'Request accepted.' }
        format.js
      end
    else
      handle_error_for_non_authorized_user
    end
  end
  
  def reject
    event_request = EventRequest.find(params[:id])
    if event_request.availability.user == current_user
      event_request.update(status: 'rejected')
  
      respond_to do |format|
        format.html { redirect_to some_path, notice: 'Request rejected.' }
        format.js
      end
    else
      handle_error_for_non_authorized_user
    end
  end
  
  private
  
  def handle_error_for_non_authorized_user
    respond_to do |format|
      format.html { redirect_to some_path, alert: 'Not authorized.' }
      format.js { render js: "alert('Not authorized.');" }
    end
  end
  
  

  def event_request_params
    params.require(:event_request).permit(:availability_id)
    # Do not include :user_id, it's set automatically to current_user
  end
  
end
