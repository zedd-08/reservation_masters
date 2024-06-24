class AddDetailsToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :name, :string
    add_column :reservations, :address, :text
    add_column :reservations, :email, :string
  end
end
