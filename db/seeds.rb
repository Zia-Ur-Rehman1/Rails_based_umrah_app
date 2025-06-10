# # db/seeds.rb
# EXCHANGE_RATE = 74.86 # PKR to SAR conversion rate

# # Helper method to convert PKR to SAR
# def to_riyal(pkr_amount)
#   (pkr_amount.to_f / EXCHANGE_RATE).round(2)
# end

# # 1. Create Room Types
# RoomType.create!([
#   { name: "SHARING" },
#   { name: "QUAD" },
#   { name: "TRIPPLE" },
#   { name: "DOUBLE" }
# ])

# # 2. Create Hotels (both Makkah and Medinah)
# hotels_data = [
#   # Makkah Hotels
#   {
#     name: "Diyar Matar",
#     city: "Makkah",
#     distance: "1100 Meter",
#     landmark: "Al Rajhi Mosque",
#     gate_proximity: "Gate 94 (King Fahad Gate) - 15 min walk",
#     transport_access: "Haramain Express Bus Stop (200m)",
#     category: 3
#   },
#   {
#     name: "Jada Khalil",
#     city: "Makkah",
#     distance: "1100 Meter",
#     landmark: "King Abdullah Road",
#     gate_proximity: "Gate 95 - 12 min walk",
#     transport_access: "Taxi Stand (50m)",
#     category: 3
#   },
#   {
#     name: "Mawada Husnain",
#     city: "Makkah",
#     distance: "700-750 Meter",
#     landmark: "Ibrahim Al Khalil Road",
#     gate_proximity: "Gate 94 (King Fahad Gate) - 5 min walk",
#     transport_access: "Makkah Metro Station (300m)",
#     category: 4
#   },
#   {
#     name: "Swiss Khalil",
#     city: "Makkah",
#     distance: "400-450 Meter",
#     landmark: "Jabal Omar Clock Towers",
#     gate_proximity: "Gate 93 (King Abdulaziz Gate) - Direct Access",
#     transport_access: "Haramain High Speed Rail (500m)",
#     category: 5
#   },

#   # Madinah Hotels
#   {
#     name: "Kinan Medina",
#     city: "Madinah",
#     distance: "800-850 Meter",
#     landmark: "Seven Suns Mall",
#     gate_proximity: "Gate 35 - 10 min walk",
#     transport_access: "Public Bus Stop (100m)",
#     category: 3
#   },
#   {
#     name: "Dar Ajyal 182",
#     city: "Madinah",
#     distance: "700-750 Meter",
#     landmark: "Al Qiblatain Mosque Area",
#     gate_proximity: "Gate 25 (Women's Gate) - 7 min walk",
#     transport_access: "Taxi Stand (150m)",
#     category: 4
#   },
#   {
#     name: "Ansar Plus",
#     city: "Madinah",
#     distance: "500-550 Meter",
#     landmark: "Quba Mosque Corridor",
#     gate_proximity: "Gate 28 - 5 min walk",
#     transport_access: "Medina Metro Station (400m)",
#     category: 4
#   },
#   {
#     name: "Manazi widyrj Rou al Khair",
#     city: "Madinah",
#     distance: "300-350 Meter",
#     landmark: "Women's Prayer Hall",
#     gate_proximity: "Gate 25 - 3 min walk",
#     transport_access: "Haramain Express (600m)",
#     category: 5
#   },
#   {
#     name: "Rou Taiba",
#     city: "Madinah",
#     distance: "100-150 Meter",
#     landmark: "Ghamama Mosque",
#     gate_proximity: "Gate 30 (Main Qibla Gate) - Direct Access",
#     transport_access: "Central Taxi Hub (50m)",
#     category: 5
#   }
# ]

# hotels = hotels_data.map { |h| Hotel.create!(h) }

# # 3. Create Hotel Rooms with Prices in SAR
# # Mapping of hotels to their prices by room type
# pricing_data = {
#   # Makkah Hotels
#   "Diyar Matar" => {
#     "SHARING" => to_riyal(194000), # 2591.77 SAR
#     "QUAD" => to_riyal(197000),    # 2631.58 SAR
#     "TRIPPLE" => to_riyal(201000), # 2685.01 SAR
#     "DOUBLE" => to_riyal(210000)   # 2805.24 SAR
#   },
#   "Jada Khalil" => {
#     "SHARING" => to_riyal(196000), # 2618.22 SAR
#     "QUAD" => to_riyal(199000),    # 2658.03 SAR
#     "TRIPPLE" => to_riyal(204000), # 2725.09 SAR
#     "DOUBLE" => to_riyal(214000)   # 2858.67 SAR
#   },
#   # ... (add all other hotels with their pricing)
#   "Rou Taiba" => {
#     "SHARING" => to_riyal(304000), # 4060.91 SAR
#     "QUAD" => to_riyal(323000),    # 4314.72 SAR
#     "TRIPPLE" => to_riyal(351000), # 4688.75 SAR
#     "DOUBLE" => to_riyal(380000)   # 5076.14 SAR
#   }
# }

# # Create hotel_rooms records
# pricing_data.each do |hotel_name, room_prices|
#   hotel = Hotel.find_by!(name: hotel_name)

#   room_prices.each do |room_type_name, price|
#     room_type = RoomType.find_by!(name: room_type_name)
#     HotelRoom.create!(
#       hotel: hotel,
#       room_type: room_type,
#       base_price: price
#     )
#   end
# end

# puts "Seeded #{Hotel.count} hotels, #{RoomType.count} room types, and #{HotelRoom.count} room prices in SAR"



# db/seeds.rb

# Clear existing data
Flight.destroy_all

# Airlines operating on Pakistan-Saudi routes
airlines = [
  { name: "Saudi Airlines", code: "SV" },
  { name: "Pakistan International Airlines", code: "PK" },
  { name: "Airblue", code: "PA" },
  { name: "SereneAir", code: "ER" },
  { name: "Flynas", code: "XY" }
]

# Airports (Pakistan and Saudi)
airports = {
  pakistan: [ "ISB" => "Islamabad", "LHE" => "Lahore", "KHI" => "Karachi", "PEW" => "Peshawar" ],
  saudi: [ "JED" => "Jeddah", "MED" => "Medina", "RUH" => "Riyadh", "DMM" => "Dammam" ]
}

# Generate 30 sample flights
30.times do |i|
  # Random flight parameters
  airline = airlines.sample
  flight_number = "#{airline[:code]}#{rand(100..999)}"
  departure_airport, arrival_airport = rand < 0.5 ?
    [ airports[:pakistan].sample.keys[0], airports[:saudi].sample.keys[0] ] :
    [ airports[:saudi].sample.keys[0], airports[:pakistan].sample.keys[0] ]

  departure_time = DateTime.now + rand(1..60).days + rand(1..23).hours
  arrival_time = departure_time + rand(3..6).hours
  luggage = [ "20kg", "30kg", "40kg" ].sample
  meal = rand < 0.8 # 80% chance of meal included

  Flight.create!(
    airline: airline[:name],
    flight_number: flight_number,
    departure_airport: departure_airport,
    arrival_airport: arrival_airport,
    departure_time: departure_time,
    arrival_time: arrival_time,
    luggage: luggage,
    meal: meal
  )
end

puts "Created #{Flight.count} dummy flights"

# Sample output for verification
Flight.limit(5).each do |flight|
  puts "#{flight.airline} #{flight.flight_number}"
  puts "#{flight.departure_airport} → #{flight.arrival_airport}"
  puts "Departs: #{flight.departure_time.strftime('%d %b %Y, %H:%M')}"
  puts "Arrives: #{flight.arrival_time.strftime('%d %b %Y, %H:%M')}"
  puts "Luggage: #{flight.luggage} | Meal: #{flight.meal ? '✅' : '❌'}"
  puts "-" * 50
end
