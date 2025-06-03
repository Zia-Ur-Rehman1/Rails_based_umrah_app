# app/models/hotel.rb
class Hotel < ApplicationRecord
  # Star-based categories (1-5 stars)
  enum :category, [ :"1_star", :"2_star", :"3_star", :"4_star", :"5_star", :"Economy", :"Building" ]
  # Room types
  enum :city, {
    Makkah: 1,
    Medina: 2
  }

  # Validations
  validates :name, presence: true
  validates :distance, presence: true

  # Optional fields
  validates :agency, presence: false
  validates :agency_contact, presence: false

  has_many :hotel_rooms
  has_many :room_types, through: :hotel_rooms
  accepts_nested_attributes_for :hotel_rooms, allow_destroy: true
end
