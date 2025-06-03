class AddLocationToHotel < ActiveRecord::Migration[8.0]
  def change
    add_column :hotels, :location, :string
  end
end
