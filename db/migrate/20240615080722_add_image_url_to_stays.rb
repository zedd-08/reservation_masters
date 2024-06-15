class AddImageUrlToStays < ActiveRecord::Migration[7.1]
  def change
    add_column :stays, :image_url, :string
  end
end
