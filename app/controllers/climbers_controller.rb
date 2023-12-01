class ClimbersController < ApplicationController
  before_action :set_climber, only: %i[ show edit update destroy ]

  # GET /climbers or /climbers.json
  def index
    @q = Climber.ransack(params[:q])
    @climbers = @q.result(distinct: true)
  end

  # GET /climbers/1 or /climbers/1.json
  def show
  end

  # GET /climbers/new
  def new
    @climber = Climber.new
  end

  # GET /climbers/1/edit
  def edit
  end

  # POST /climbers or /climbers.json
  def create
    @climber = Climber.new(climber_params)

    respond_to do |format|
      if @climber.save
        format.html { redirect_to climber_url(@climber), notice: "Climber was successfully created." }
        format.json { render :show, status: :created, location: @climber }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @climber.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /climbers/1 or /climbers/1.json
  def update
    respond_to do |format|
      if @climber.update(climber_params)
        format.html { redirect_to climber_url(@climber), notice: "Climber was successfully updated." }
        format.json { render :show, status: :ok, location: @climber }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @climber.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /climbers/1 or /climbers/1.json
  def destroy
    @climber.destroy

    respond_to do |format|
      format.html { redirect_to climbers_url, notice: "Climber was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_climber
      @climber = Climber.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def climber_params
      params.require(:climber).permit(:bio, :instructor, :boulder, :top_rope, :lead, :vertical, :slab, :overhang, :beginner, :intermediate, :advanced, :sport, :trad, :indoor, :outdoor)
    end
end
