class RoomType < ApplicationRecord
  has_many :hotel_rooms
  has_many :hotels, through: :hotel_rooms
end
