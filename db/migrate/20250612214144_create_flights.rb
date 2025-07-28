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
      t.integer :seats
      t.integer :trip_type
      t.references :connected_flight, null: true, foreign_key: { to_table: :flights, on_delete: :cascade }
      t.string :unique_code
      t.string :agency
      t.integer :days

      t.timestamps
    end
  end
end
