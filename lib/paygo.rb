require "ostruct"

class Paygo
  def self.make_payment(order_id:,
                        payment_method:,
                        payment_details:)
    case payment_method
    when :ideal
      Rails.logger.info "Processing check: " +
          payment_details.fetch(:routing).to_s + "/" +
          payment_details.fetch(:account).to_s
    when :bank_card
      Rails.logger.info "Processing credit_card: " +
          payment_details.fetch(:cc_num).to_s + "/" +
          payment_details.fetch(:expiration_month).to_s + "/" +
          payment_details.fetch(:expiration_year).to_s
    when :cash
      Rails.logger.info "Processing purchase order: " +
          payment_details.fetch(:confirmation).to_s
    else
      raise "Unknown payment_method #{payment_method}"
    end
    sleep 3 unless Rails.env.test?
    Rails.logger.info "Done Processing Payment"
    OpenStruct.new(succeeded?: true)
  end
end
