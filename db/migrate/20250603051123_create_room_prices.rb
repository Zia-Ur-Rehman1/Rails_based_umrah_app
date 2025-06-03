class CreateRoomPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :room_prices do |t|
      t.references :hotel_room, null: false, foreign_key: true
      t.date :date
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
