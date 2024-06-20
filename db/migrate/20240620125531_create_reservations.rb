class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :stay, null: false, foreign_key: true
      t.date :check_in
      t.date :check_out
      t.string :status

      t.timestamps
    end
  end
end
