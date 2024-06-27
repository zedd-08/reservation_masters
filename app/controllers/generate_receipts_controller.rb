class GenerateReceiptsController < ApplicationController
  before_action :set_reservation

  def generate_pdf
    stay = Stay.find(@reservation.stay_id)
    receipt_service = ReceiptGeneratorService.new
    receipt_content = receipt_service.generate_pdf(@reservation, stay)
    receipt_filename = "#{@reservation.name.downcase.gsub(" ", "_")}-#{stay.id}-#{@reservation.id}.pdf"

    send_data receipt_content, filename: receipt_filename, type: 'pdf', disposition: 'attachment'

    # File.open(receipt_filename, "wb") { |file| file.write(receipt_content) }
    # send_file receipt_filename, type: "application/pdf", disposition: "inline"
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "Reservation not found"
    end
end
