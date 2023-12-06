class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: %i[ show edit update destroy ]

  # app/controllers/availabilities_controller.rb


  # app/controllers/availabilities_controller.rb
  def on_date
    @date = Date.parse(params[:date])
    @availabilities_on_date = Availability.includes(user: :climber)
                                          .where('DATE(start_time) = ?', @date)
                                          .order(start_time: :asc)
  end

  # GET /availabilities or /availabilities.json

  def index
    @q = Availability.ransack(params[:q])
    @availabilities = @q.result.includes(:user, event_requests: :user)
                        .distinct
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
    @availability = Availability.find(params[:id])
    authorize @availability
  rescue Pundit::NotAuthorizedError
    redirect_to root_path
  end
  

  # POST /availabilities or /availabilities.json
  def create
    @availability = current_user.availabilities.new(availability_params)
    authorize @availability

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
    authorize @availability unless action_name == 'show'
  end
  

  def availability_params
    params.require(:availability).permit(:event_name, :start_time, :end_time, :user_id, :advanced, :beginner, :boulder, :indoor, :instructor, :intermediate, :lead, :outdoor, :overhang, :slab, :sport, :top_rope, :trad, :vertical, :learn, :location, :description)
  end
    
end
