class StaysController < ApplicationController
  before_action :set_stay, only: %i[ show edit update enable disable ]
  before_action :authenticate_user!, only: %i[ new edit create update enable disable ]

  # GET /stays or /stays.json
  def index
    if params[:check_in] && params[:check_out] && !params[:check_in].strip.empty? && !params[:check_in].strip.empty?
      begin
        start_date = params[:check_in].to_date
        end_date = params[:check_out].to_date
      rescue Date::Error
        redirect_to root_path, notice: "Invalid dates provided, please try again"
        return
      else
        if !start_date || !end_date
          redirect_to root_path, notice: "Please provide both check in and check out dates"
          return
        end

        if end_date < start_date
          redirect_to root_path, notice: "Check in cannot be after check out, please try again"
          return
        else
          get_available_stays(start_date, end_date)
        end
      end
    else
      if user_signed_in?
        @stays = Stay.all
      else
        @stays = Stay.enabled
        flash[:notice] = "Dates not supplied. Showing all stays."
      end
    end
    @pagy, @stays = pagy(@stays)
  end

  # GET /stays/1 or /stays/1.json
  def show
  end

  # GET /stays/new
  def new
    @stay = Stay.new
  end

  # GET /stays/1/edit
  def edit
  end

  # POST /stays or /stays.json
  def create
    @stay = Stay.new(stay_params)

    respond_to do |format|
      if @stay.save
        format.html { redirect_to stay_url(@stay), notice: "Stay was successfully created." }
        format.json { render :show, status: :created, location: @stay }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stays/1 or /stays/1.json
  def update
    respond_to do |format|
      if @stay.update(stay_params)
        format.html { redirect_to stay_url(@stay), notice: "Stay was successfully updated." }
        format.json { render :show, status: :ok, location: @stay }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stays/1 or /stays/1.json
  def disable
    @stay.enabled = false

    respond_to do |format|
      if @stay.save!
        format.html { redirect_to stay_url(@stay), notice: "Stay was successfully disabled." }
        format.json { render :show, status: :ok, location: @stay }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stays/1 or /stays/1.json
  def enable
    @stay.enabled = true

    if @stay.save!
      format.html { redirect_to stay_url(@stay), notice: "Stay was successfully enabled." }
      format.json { render :show, status: :ok, location: @stay }
    else
      format.html { render :show, status: :unprocessable_entity }
      format.json { render json: @stay.errors, status: :unprocessable_entity }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stay
    @stay = Stay.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  # Only allow a list of trusted parameters through.
  def stay_params
    params.require(:stay).permit(:name, :address, :description, :image_url, :max_persons, :pet_friendly, :bedrooms, :bathrooms, :area, :price)
  end

  def get_available_stays(start_date, end_date)
    reserved_stays = Reservation.where(check_in: start_date..(end_date-1))
      .or(Reservation.where(check_out: (start_date+1)..end_date))
      .or(
        (Reservation.where(check_out: end_date..)
        .and(Reservation.where(check_in: ..start_date)))
      )
    reserved_stays = reserved_stays.map { |rs| rs.stay_id }
    @stays = Stay.where.not(id: reserved_stays).enabled
  end
end
