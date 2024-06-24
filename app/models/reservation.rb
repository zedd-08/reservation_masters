class Reservation < ApplicationRecord
  enum pay_type: {
    "iDeal" => 0,
    "Bank Card" => 1,
    "Pay at stay" => 2,
  }

  belongs_to :stay

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys
end
