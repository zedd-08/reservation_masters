class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit update destroy ]
  before_action :set_stay, only: %i[ new create ]
  before_action :set_stay_reserved, only: %i[ show edit ]

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.stay_id = @stay.id
    @reservation.price = @stay.price

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, stay: @stay, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy!

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_stay
      begin
        if params[:stay_id]
          @stay = Stay.find(params[:stay_id])
        else
          redirect_to root_path, notice: "Please select a stay to create a reservation"
        end
        rescue ActiveRecord::RecordNotFound
          redirect_to root_path, notice: "Invalid stay selected"
      end
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:stay_id, :name, :email, :address, :check_in, :check_out, :pay_type)
    end

    def set_stay_reserved
      @stay = Stay.find(@reservation.stay_id)
    end
end
