require "paygo"

class Reservation < ApplicationRecord
  enum pay_type: {
    "iDeal" => 0,
    "Bank Card" => 1,
    "Pay at stay" => 2,
  }

  enum status: {
    "Booked - Payment pending" => 0,
    "Booked - Paid" => 1,
    "Checked in" => 2,
    "Checked out" => 3,
    "Cancelled" => 4
  }

  belongs_to :stay

  validates :name, :address, :email, :check_in, :check_out, presence: true
  validates :pay_type, inclusion: pay_types.keys
  validates :check_in, :check_out, availability: true, on: :create
  validate :check_out_after_check_in

  def total_amount
    total_amount = 0
    if check_in and check_out
      total_amount = (check_out - check_in).to_i * price
    end
    total_amount
  end

  def unavailable_dates
    Reservation.pluck(:check_in, :check_out).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  def cancelled?
    status == status["Cancelled"]
  end

  def checked_in?
    status == status["Checked in"]
  end

  def checked_out?
    status == status["Checked out"]
  end

  def charge!(pay_type_params)
    payment_details = {}
    payment_method = nil

    case pay_type
    when "iDeal"
      payment_method = :ideal
      payment_details[:routing] = pay_type_params["routing_number"]
      payment_details[:account] = pay_type_params["account_number"]
    when "Bank Card"
      payment_method = :bank_card
      month, year = pay_type_params["expiration_date"].split(//)
      payment_details[:cc_num] = pay_type_params["credit_card_number"]
      payment_details[:expiration_month] = month
      payment_details[:expiration_year] = year
    when "Pay at stay"
      payment_method = :cash
      payment_details[:confirmation] = pay_type_params["confirmation"]
    end

    payment_result = Paygo.make_payment(
      order_id: id,
      payment_method: payment_method,
      payment_details: payment_details,
    )

    if payment_result.succeeded?
      # ReservationMailer.payment_status(self, true).deliver_later
      puts "SUCCESS"
      status = status["Booked - Paid"] if pay_type != "Pay at stay"
    else
      # ReservationMailer.payment_status(self, false).deliver_later
      puts "FAILURE"
      status = status["Booked - Payment pending"]
    end
  end

  private

  def check_out_after_check_in
    return if check_out.blank? || check_in.blank?

    if check_out < check_in
      errors.add(:check_out, "must be after the start date")
    end
 end
end
