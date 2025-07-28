# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_12_214144) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.string "airline"
    t.string "flight_number"
    t.string "departure_airport"
    t.string "arrival_airport"
    t.datetime "departure_time"
    t.datetime "arrival_time"
    t.string "luggage"
    t.integer "seats"
    t.integer "trip_type"
    t.bigint "connected_flight_id"
    t.string "unique_code"
    t.string "agency"
    t.integer "days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["connected_flight_id"], name: "index_flights_on_connected_flight_id"
  end

  create_table "hotel_rooms", force: :cascade do |t|
    t.bigint "hotel_id", null: false
    t.bigint "room_type_id", null: false
    t.decimal "base_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_hotel_rooms_on_hotel_id"
    t.index ["room_type_id"], name: "index_hotel_rooms_on_room_type_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.integer "city"
    t.string "name"
    t.integer "category"
    t.string "distance"
    t.string "landmark"
    t.string "gate_proximity"
    t.string "transport_access"
    t.string "agency"
    t.string "agency_contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_prices", force: :cascade do |t|
    t.bigint "hotel_room_id", null: false
    t.date "date"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_room_id"], name: "index_room_prices_on_hotel_room_id"
  end

  create_table "room_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "flights", "flights", column: "connected_flight_id", on_delete: :cascade
  add_foreign_key "hotel_rooms", "hotels"
  add_foreign_key "hotel_rooms", "room_types"
  add_foreign_key "room_prices", "hotel_rooms"
end
