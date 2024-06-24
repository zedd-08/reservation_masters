class AddPayTypeToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :pay_type, :integer
  end
end
