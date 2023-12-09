class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend_request, only: [:update, :destroy]

  def index
    @accepted_requests = current_user.sent_friend_requests.where(status: 'accepted') + current_user.received_friend_requests.where(status: 'accepted')
    @received_requests = current_user.received_friend_requests.where(status: 'pending')
    @sent_requests = current_user.sent_friend_requests.where(status: 'pending')
  end
  

  # POST /friend_requests
  # Creates a new friend request
  def create
    @friend_request = current_user.sent_friend_requests.new(receiver_id: params[:receiver_id])

    if @friend_request.save
      redirect_to climber_path(@friend_request.receiver.climber), notice: 'Friend request sent.'
    else
      redirect_to climbers_path, alert: 'Unable to send friend request.'
    end
  end

  # PATCH/PUT /friend_requests/1
  # Accepts a friend request
  def update
    if @friend_request.receiver == current_user
      @friend_request.update(status: 'accepted')
      redirect_to friend_requests_path, notice: 'Friend request accepted.'
    else
      redirect_to friend_requests_path, alert: 'Unable to accept this friend request.'
    end
  end

  # DELETE /friend_requests/1
  # Declines or cancels a friend request
  def destroy
    if @friend_request.receiver == current_user || @friend_request.sender == current_user
      @friend_request.destroy
      redirect_to friend_requests_path, notice: 'Friend request canceled.'
    else
      redirect_to friend_requests_path, alert: 'Unable to decline this friend request.'
    end
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
