class CreateHotelRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :hotel_rooms do |t|
      t.references :hotel, null: false, foreign_key: true
      t.references :room_type, null: false, foreign_key: true
      t.decimal :base_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
