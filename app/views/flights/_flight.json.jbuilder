json.extract! flight, :id, :airline, :flight_number, :departure_airport, :arrival_airport, :departure_time, :arrival_time, :luggage, :meal, :created_at, :updated_at
json.url flight_url(flight, format: :json)
