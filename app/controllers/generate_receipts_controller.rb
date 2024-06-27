
class GenerateReceiptsController < ApplicationController
  def generate_pdf
    reservation = Reservation.last
    stay = Stay.find(reservation.stay_id)
    receipt_service = ReceiptGeneratorService.new
    receipt_content = receipt_service.generate_pdf(reservation, stay)
    receipt_filename = "invoices/#{stay.id}-#{reservation.id}-#{reservation.name.downcase.gsub(' ', '_')}.pdf"

    # PdfMailer.send_report.deliver_now
    File.open(receipt_filename, 'wb') { |file| file.write(receipt_content) }

    send_data receipt_content, filename: receipt_filename, type: 'pdf', disposition: 'inline'
  end
end
