class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
# Generate Hotel scaffold
# rails generate scaffold Hotel city:integer name:string category:integer distance:string agency:string agency_contact:string

# # Generate RoomType model (no scaffold)
# rails generate model RoomType name:string code:string:uniq

# # Generate join model with availability status
# rails generate model HotelRoomAvailability hotel:references room_type:references available:boolean price:decimal{10.2}
# Migration for new tables
# rails g migration CreateUmrahPackages customer:references name:string total_price:decimal start_date:date end_date:date status:string
# rails g migration CreatePassports customer:references number:string issue_date:date expiry_date:date nationality:string
# rails g migration CreateVisas umrah_package:references number:string issue_date:date expiry_date:date status:string
# rails g scaffold CreateFlights airline:string flight_number:string departure_airport:string arrival_airport:stringdeparture_time:datetime arrival_time:datetime luggage:string seats:integer trip_type:integerconnected_flight:references unique_code:string agency:string

# rails generate scaffold Customer name:string email:string phone:string
