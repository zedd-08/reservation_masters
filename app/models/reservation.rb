class Reservation < ApplicationRecord
  enum pay_type: {
    "iDeal" => 0,
    "Bank Card" => 1,
    "Pay at stay" => 2,
  }

  belongs_to :stay

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  def total_amount
    total_amount = 0
    if check_in and check_out
      total_amount = (check_out - check_in).to_i * price
    end
    total_amount
  end
end
