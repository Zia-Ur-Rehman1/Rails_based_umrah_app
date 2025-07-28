require "selenium-webdriver"
module MctTravels
  class MctFlightScrapper
    LOGIN_URL = "https://mcttravels.com/login"
    DASHBOARD_URL = "https://mcttravels.com/admin/booking/groups?airline_id=0&type=0"

    def initialize(email: "hasnaintravelandtours@gmail.com", password: "Serene@11", headless: true)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless") if true
      @driver = Selenium::WebDriver.for(:chrome, options: options)
      @email = "hasnaintravelandtours@gmail.com"
      @password = "Serene@11"
    end

    def login
      @driver.get(LOGIN_URL)
      sleep 2
      @driver.find_element(name: "email").send_keys(@email)
      @driver.find_element(name: "password").send_keys(@password)
      @driver.find_element(:css, "button.btn-primary.btn-block").click
      sleep 3
    end

    def dashboard
      @driver.get(DASHBOARD_URL)
      sleep 3

      headers = @driver.find_elements(:xpath, "//th[img and span]")

      headers.each do |header|
        airline = header.find_element(:tag_name, "img").attribute("alt")
        route = header.find_elements(:tag_name, "span")[1].text
        puts "Airline: #{airline} | Route: #{route}"

        thead = header.find_element(:xpath, "following::thead[1]")
        loop do
          begin
            row = thead.find_element(:tag_name, "tr")
            parse_and_store(row, airline, route)
            thead = thead.find_element(:xpath, "following::thead[1]")
          end
        end
      end
    end


    def parse_and_store(row, airline, route)
      values = row.text.split("\n")

      departure_date = values[0]                            # "20-06-2025"
      time_range     = values[1]                            # "02:05 - 04:10"
      luggage        = values[2]                            # "20+7 KG"
      price_info     = values[3]                            # "NO 80,000 PKR/-"
      booking_url    = cols[5].find_element(:tag_name, "a").attribute("href")

      # Parse route and airline from earlier
      route_parts = route.split("-")                    # e.g., "LYP-SHJ"
      departure_airport = route_parts[0]
      arrival_airport   = route_parts[1]

      departure_time_str, arrival_time_str = time_range.split(" - ")
      departure_time = Time.zone.strptime("#{departure_date} #{departure_time_str}", "%d-%m-%Y %H:%M")
      arrival_time   = Time.zone.strptime("#{departure_date} #{arrival_time_str}", "%d-%m-%Y %H:%M")

      # Build Flight attributes
      flight_attrs = {
        airline:            airline,         # From earlier header
        flight_number:      nil,             # Not available in row
        departure_airport:  departure_airport,
        arrival_airport:    arrival_airport,
        departure_time:     departure_time,
        arrival_time:       arrival_time,
        luggage:            luggage,
        seats:              nil,
        trip_type:          0,
        connected_flight_id: nil,
        unique_code:        nil,
        agency:             "mct",
        days:               nil
      }

      Flight.create!(flight_attrs)
    end
  end
end
