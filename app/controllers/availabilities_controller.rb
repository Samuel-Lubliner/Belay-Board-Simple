class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: %i[ show edit update destroy ]

  # GET /availabilities or /availabilities.json
  def index
    @selected_host_id = params[:host_id]
    @selected_guest_id = params[:guest_id]
    @event_name_query = params[:event_name]

    @availabilities = Availability.all

    if @selected_host_id.present?
      @availabilities = @availabilities.where(user_id: @selected_host_id)
    end

    if @selected_guest_id.present?
      guest_availabilities = EventRequest.where(user_id: @selected_guest_id, status: 'accepted').pluck(:availability_id)
      @availabilities = @availabilities.where(id: guest_availabilities)
    end

    if @event_name_query.present?
      @availabilities = @availabilities.where('event_name ILIKE ?', "%#{@event_name_query}%")
    end
  end

  # GET /availabilities/1 or /availabilities/1.json
  def show
    @availability = Availability.find(params[:id])
    @event_requests = @availability.event_requests.includes(:user)
    @comments = @availability.comments.order(created_at: :desc)
  end
  

  # GET /availabilities/new
  def new
    @availability = Availability.new
    @availability.start_time = params[:start_date] if params[:start_date].present?
  end

  # GET /availabilities/1/edit
  def edit
  end

  # POST /availabilities or /availabilities.json
  def create
    @availability = current_user.availabilities.new(availability_params)

    respond_to do |format|
      if @availability.save
        format.html { redirect_to availability_url(@availability), notice: "Availability was successfully created." }
        format.json { render :show, status: :created, location: @availability }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /availabilities/1 or /availabilities/1.json
  def update
    authorize @availability
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to availability_url(@availability), notice: "Availability was successfully updated." }
        format.json { render :show, status: :ok, location: @availability }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1 or /availabilities/1.json
  def destroy
    authorize @availability

    @availability.destroy

    respond_to do |format|
      format.html { redirect_to availabilities_url, notice: "Availability was successfully destroyed." }
      format.json { head :no_content }
    end

  end

  private
    def set_availability
      @availability = Availability.find(params[:id])
    end

    def availability_params
      params.require(:availability).permit(:event_name, :start_time, :end_time)
      # Remove :user_id
    end
end
