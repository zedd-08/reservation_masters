class CreateStays < ActiveRecord::Migration[7.1]
  def change
    create_table :stays do |t|
      t.string :name
      t.string :address
      t.integer :max_persons
      t.boolean :pet_friendly
      t.integer :bedrooms
      t.integer :bathrooms
      t.decimal :area
      t.decimal :price

      t.timestamps
    end
  end
end
