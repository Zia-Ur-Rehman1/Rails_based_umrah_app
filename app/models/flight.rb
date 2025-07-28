class Flight < ApplicationRecord
  # For flights that have a connected return flight
  belongs_to :connected_flight,
             class_name: "Flight",
             foreign_key: :connected_flight_id,
             optional: true,
             inverse_of: :return_flight

  # For flights that are return flights (connected to an outbound flight)
  has_one :return_flight,
          class_name: "Flight",
          foreign_key: :connected_flight_id,
          dependent: :destroy,
          inverse_of: :connected_flight

  # Add any validations you need
  validates :flight_number, :departure_airport, :arrival_airport,
            :departure_time, :arrival_time, :airline, presence: true

  # Enum for trip_type if you're using it for status
  enum :trip_type, [ :one_way, :round_trip, :via ]

  def connected_flight_number
    connected_flight&.flight_number
  end
end
