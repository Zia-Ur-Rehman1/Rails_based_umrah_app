class HotelRoom < ApplicationRecord
  belongs_to :hotel
  belongs_to :room_type
  has_many :room_prices
  accepts_nested_attributes_for :room_prices, allow_destroy: true
end
