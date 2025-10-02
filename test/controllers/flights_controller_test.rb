# test/controllers/flights_controller_test.rb
require "test_helper"

class FlightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @outbound = flights(:outbound_flight)
    @return = flights(:return_flight)
    @one_way = flights(:one_way_flight)
  end

  test "should test turbo stream assertion" do
    assert_difference("Flight.count") do
      post flights_url, params: { flight: @one_way.attributes.except("id", "created_at", "updated_at") },
      as: :turbo_stream,
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success
    assert_turbo_stream action: "append", target: "flights"
    assert_turbo_stream action: "replace", target: "flight_form"
  end

  test "should create flight with turbo stream" do
    assert_difference("Flight.count") do
      post flights_url, params: { flight: @one_way.attributes.except("id", "created_at", "updated_at") }, as: :turbo_stream
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_match /turbo-stream/, @response.body

    stream = response.parsed_body

    assert_includes stream, 'turbo-stream action="append" target="flights"'
    assert_includes stream, 'turbo-stream action="replace" target="flight_form"'
  end

  test "should update flight with turbo_stream" do
    flight = flights(:one_way_flight)
    patch flight_url(flight), params: { flight: { airline: "Updated Airline" } }, as: :turbo_stream
    assert_response :success
    assert_match /turbo-stream/, @response.body
    stream = response.parsed_body
    assert_includes stream, 'turbo-stream action="replace" target="flight_' + flight.id.to_s + '"'
    assert_includes stream, "Updated Airline"
  end

  test "should destroy flight with turbo_stream" do
    assert_difference("Flight.count", -1) do
      delete flight_url(@one_way), as: :turbo_stream
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_match /turbo-stream/, @response.body
    assert_includes @response.body, "turbo-stream action=\"remove\" target=\"flight_#{@one_way.id}\""
  end
end
