require "selenium-webdriver"
module Alsaboor
  class FlightScrapper
    LOGIN_URL = "https://alsaboorportal.com/agent-login.php"
    DASHBOARD_URL = "https://alsaboorportal.com/all-departure-umrah.php"

    def initialize(agent_code: "454", email: "HASNAINTRAVELANDTOURS@GMAIL.COM", password: "1707813016", headless: true)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless") if headless
      @driver = Selenium::WebDriver.for(:chrome, options: options)
      @agent_code = agent_code
      @email = email
      @password = password
    end

    def login
      @driver.get(LOGIN_URL)
      sleep 2
      @driver.find_element(name: "ag_code").send_keys(@agent_code)
      @driver.find_element(name: "csemail").send_keys(@email)
      @driver.find_element(name: "cspass").send_keys(@password)
      @driver.find_element(name: "login_btn").click
      sleep 3
      self
    end

    def scrape_deals
      @driver.get(DASHBOARD_URL)
      sleep 3

      deals = @driver.find_elements(css: ".details.group_name")
      puts "Found #{deals.size} deals"
      deals.each do |deal|
        begin
          ag_code = extract_ag_code(deal)
          next unless ag_code # skip if ag_code is nil

          seats = extract_available_seats(deal)
          copy_button = deal.find_element(css: ".copy-button")
          onclick_attr = copy_button.attribute("onclick")
          span_id = onclick_attr[/text_to_copy_\d+/]
          next unless span_id

          js = <<~JS
            const el = document.getElementById("#{span_id}");
            return el.innerText;
          JS

          deal_text = @driver.execute_script(js).gsub(/\s+/, " ").strip

          puts "Parsed deal: #{deal_text} with AG code: #{ag_code} and available seats: #{seats}"
          parse_and_store(deal_text, ag_code, seats)
        rescue => e
          puts "Skipping deal due to error: #{e.message}"
          next
        end
      end
      close
      puts "Scraping completed and driver closed."
    end

    def extract_ag_code(deal)
      h3 = deal.find_element(tag_name: "h3")
      span_elements = h3.find_elements(tag_name: "span")

      ag_span = span_elements.find { |span| span.text.strip.start_with?("AG-") }
      ag_span&.text
    end

    def extract_available_seats(deal)
      available_seats_text = deal.find_element(xpath: ".//div[contains(@class, 'f-wrap')]/h5[normalize-space()='Seats']/following-sibling::div[2]").text
      available_seats_text[/\d+/].to_i
    end


    def parse_and_store(deal_text, ag_code, seats)
      outbound, inbound = parse_flight_parts(deal_text)

      # Outbound Flight
      f1 = find_or_create_or_update_flight(
        ag_code: ag_code,
        airline: outbound[:airline],
        flight_number: outbound[:flight_number],
        departure_airport: outbound[:departure_airport],
        arrival_airport: outbound[:arrival_airport],
        departure_time: outbound[:departure_time],
        arrival_time: outbound[:arrival_time],
        luggage: outbound[:luggage],
        seats: seats,
        days: outbound[:days],
        agency: "Alsaboor",
        trip_type: 1,
        connected_flight: nil
      )

      # Inbound Flight
      find_or_create_or_update_flight(
        ag_code: ag_code,
        airline: inbound[:airline],
        flight_number: inbound[:flight_number],
        departure_airport: inbound[:departure_airport],
        arrival_airport: inbound[:arrival_airport],
        departure_time: inbound[:departure_time],
        arrival_time: inbound[:arrival_time],
        luggage: inbound[:luggage],
        seats: seats,
        days: nil,
        agency: "Alsaboor",
        trip_type: 1,
        connected_flight: f1
      )
    end

    def parse_flight_parts(deal_text)
      parts = deal_text.split(" ")
      airline = parts[0..2].join(" ")
      days = parts[3].to_i

      # Outbound
      out_flight_number = "#{parts[5]} #{parts[6]}"
      out_date = "#{parts[7]} #{parts[8]} #{parts[9]}"
      out_departure_airport, out_arrival_airport = parts[10].split("-")

      out_departure_time = Time.strptime("#{out_date} #{parts[11]}", "%d %b %Y %H:%M")
      out_arrival_time = Time.strptime("#{out_date} #{parts[12]}", "%d %b %Y %H:%M")
      out_luggage = parts[13]

      # Inbound
      in_flight_number = "#{parts[15]} #{parts[16]}"
      in_date = "#{parts[17]} #{parts[18]} #{parts[19]}"
      in_departure_airport, in_arrival_airport = parts[20].split("-")
      in_departure_time = Time.strptime("#{in_date} #{parts[21]}", "%d %b %Y %H:%M")
      in_arrival_time = Time.strptime("#{in_date} #{parts[22]}", "%d %b %Y %H:%M")
      in_luggage = parts[23]

      outbound = {
        airline: airline,
        flight_number: out_flight_number,
        departure_airport: out_departure_airport,
        arrival_airport: out_arrival_airport,
        departure_time: out_departure_time,
        arrival_time: out_arrival_time,
        luggage: out_luggage,
        days: days
      }

      inbound = {
        airline: airline,
        flight_number: in_flight_number,
        departure_airport: in_departure_airport,
        arrival_airport: in_arrival_airport,
        departure_time: in_departure_time,
        arrival_time: in_arrival_time,
        luggage: in_luggage
      }

      [ outbound, inbound ]
    end

    def find_or_create_or_update_flight(ag_code:, flight_number:, **attrs)
      flight = Flight.find_by(unique_code: ag_code, flight_number: flight_number)
      if flight && (flight.seats != attrs[:seats] || flight.departure_time != attrs[:departure_time] || flight.arrival_time != attrs[:arrival_time])
        flight.update(attrs)
      elsif flight
        flight
      else
        Flight.create!(attrs.merge(unique_code: ag_code, flight_number: flight_number))
      end
    end


    def close
      @driver.quit
    end
  end
end
# scraper = Alsaboor::FlightScrapper.new.login.scrape_deals

# scraper.login.scrape_deals
# scraper.close


# app/jobs/flight_scraping_job.rb
# class FlightScrapingJob < ApplicationJob
#   queue_as :default

#   def perform
#     scraper = Alsaboor::FlightScraper.new(
#       agent_code: "454",
#       email: "HASNAINTRAVELANDTOURS@GMAIL.COM",
#       password: "1707813016"
#     )
#     scraper.login.scrape_deals
#     scraper.close
#   rescue => e
#     Rails.logger.error "Scraping failed: #{e.message}"
#     raise # Will trigger retry mechanism
#   end
# end


# def scrape
#   FlightScrapingJob.perform_later
#   flash[:success] = "Flight scraping started in background"
#   redirect_to flights_path
# end
