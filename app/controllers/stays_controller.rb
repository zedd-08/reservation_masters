class StaysController < ApplicationController
  before_action :set_stay, only: %i[ show edit update destroy ]

  # GET /stays or /stays.json
  def index
    @stays = Stay.all
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

  # DELETE /stays/1 or /stays/1.json
  def destroy
    @stay.destroy!

    respond_to do |format|
      format.html { redirect_to stays_url, notice: "Stay was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stay
    @stay = Stay.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def stay_params
    params.require(:stay).permit(:name, :address, :description, :image_url, :max_persons, :pet_friendly, :bedrooms, :bathrooms, :area, :price)
  end
end
