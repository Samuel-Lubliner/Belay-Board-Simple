class EventRequestsController < ApplicationController
  before_action :set_event_request, only: %i[show edit update destroy]

  def create
    @event_request = current_user.event_requests.new(event_request_params)

    respond_to do |format|
      if @event_request.save
        format.html { redirect_to @event_request.availability, notice: 'Request submitted.' }
        format.js
      else
        format.html { render 'availabilities/show', status: :unprocessable_entity }
        format.js
      end
    end
  end

  def accept
    @event_request = EventRequest.find(params[:id])
    if @event_request.availability.user == current_user
      @event_request.update(status: 'accepted')
  
      respond_to do |format|
        format.html { redirect_to availability_path(@event_request.availability), notice: 'Request accepted.' }
        format.js
      end
    end
  end
  
  def reject
    @event_request = EventRequest.find(params[:id])
    if @event_request.availability.user == current_user
      @event_request.update(status: 'rejected')
  
      respond_to do |format|
        format.html { redirect_to availability_path(@event_request.availability), notice: 'Request rejected.' }
        format.js
      end
    end
  end
  
  private
  
  def event_request_params
    params.require(:event_request).permit(:availability_id)
    # Do not include :user_id
  end  
end
