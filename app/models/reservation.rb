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
    "Cancel" => 4
  }

  belongs_to :stay

  validates :name, :address, :email, :check_in, :check_out, presence: true
  validates :pay_type, inclusion: pay_types.keys
  validates :check_in, :check_out, availability: true
  validate :check_out_after_check_in

  def total_amount
    total_amount = 0
    if check_in and check_out
      total_amount = (check_out - check_in).to_i * price
    end
    total_amount
  end

  private

  def check_out_after_check_in
    return if check_out.blank? || check_in.blank?

    if check_out < check_in
      errors.add(:check_out, "must be after the start date")
    end
 end
end
