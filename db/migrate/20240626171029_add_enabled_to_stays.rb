class AddEnabledToStays < ActiveRecord::Migration[7.1]
  def change
    add_column :stays, :enabled, :boolean, default: true
  end
end
