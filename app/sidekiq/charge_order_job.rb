class ChargeOrderJob
  include Sidekiq::Job

  def perform(reservation_id, pay_type_params)
    reservation = Reservation.find(reservation_id)
    reservation.charge!(pay_type_params)
  end
end
