class AddPriceToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :price, :decimal

    Reservation.all.find_each do |res|
      res.update(price: Stay.find(res.stay_id).price)
    end
  end
end
