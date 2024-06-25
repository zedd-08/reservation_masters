class ChangeDataTypForStatus < ActiveRecord::Migration[7.1]
  def change
    Reservation.all.find_each do |res|
      res.update(status: 0)
    end

    change_column :reservations, :status, 'integer USING CAST(status AS integer)'
  end
end
