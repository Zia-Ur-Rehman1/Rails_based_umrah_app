class CreateFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :flights do |t|
      t.string :airline
      t.string :flight_number
      t.string :departure_airport
      t.string :arrival_airport
      t.datetime :departure_time
      t.datetime :arrival_time
      t.string :luggage
      t.boolean :meal

      t.timestamps
    end
  end
end
