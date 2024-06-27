require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "reservation must contain required attributes" do
    reservation = Reservation.new

    assert reservation.invalid?

    assert reservation.errors[:name].any?
    assert reservation.errors[:address].any?
    assert reservation.errors[:email].any?
    assert reservation.errors[:check_in].any?
    assert reservation.errors[:check_out].any?
    assert reservation.errors[:pay_type].any?
  end

  test "check in should be before check out" do
    reservation = reservations(:one)
    assert reservation.valid?

    reservation.check_out = reservation.check_in.yesterday

    assert reservation.invalid?
  end
end
