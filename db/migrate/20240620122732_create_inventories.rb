class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.references :stay, null: false, foreign_key: true
      t.datetime :date
      t.boolean :availability, default: true

      t.timestamps
    end
  end
end
