require "selenium-webdriver"

module Alsaboor
  class FlightScraper
    LOGIN_URL = "https://alsaboorportal.com/agent-login.php"
    DASHBOARD_URL = "https://alsaboorportal.com/all-departure-umrah.php"

    def initialize(agent_code:, email:, password:, headless: true)
      options = Selenium::WebDriver::Chrome::Options.new
      @driver = Selenium::WebDriver.for(:chrome, options: options)

      @agent_code = "454"
      @email = "HASNAINTRAVELANDTOURS@GMAIL.COM"
      @password = "1707813016"
    end

    def login
      @driver.get(LOGIN_URL)
      @driver.find_element(name: "ag_code").send_keys(@agent_code)
      @driver.find_element(name: "csemail").send_keys(@email)
      @driver.find_element(name: "cspass").send_keys(@password)
      sleep 5
      @driver.find_element(name: "login_btn").click
      self
    end

    def scrape_deals
      @driver.get(DASHBOARD_URL)
      sleep 2

      deals = @driver.find_elements(css: "div.deals.flights.row.results")
      deals.each do |deal|
        copy_button = deal.find_element(css: ".copy-button")
        onclick_attr = copy_button.attribute("onclick")
        span_id = onclick_attr[/text_to_copy_\d+/]

        js = <<~JS
          const el = document.getElementById("#{span_id}");
          return Array.from(el.querySelectorAll("span")).map(s => s.textContent).join(" | ");
        JS

        deal_text = @driver.execute_script(js)
        parse_and_store(deal_text)
      end
    end

    def parse_and_store(deal_text)
      parts = deal_text.split(" | ")
      airline = parts[0]

      [ parts[2], parts[3] ].each do |segment|
        if segment =~ /^([A-Z]{2}) (\d+) (\d{2} \w+ \d{4}) ([A-Z]{3})-([A-Z]{3}) (\d{2}:\d{2}) (\d{2}:\d{2}) (\d+)-KG/
          flight_number = "#{$1} #{$2}"
          date = Date.parse($3)
          departure_airport = $4
          arrival_airport = $5
          departure_time = parse_time(date, $6)
          arrival_time = parse_time(date, $7)
          luggage = "#{$8} KG"

          Flight.create!(
            airline: airline,
            flight_number: flight_number,
            departure_airport: departure_airport,
            arrival_airport: arrival_airport,
            departure_time: departure_time,
            arrival_time: arrival_time,
            luggage: luggage,
            meal: false
            )
          pp "Parsed flight: #{flight_number} from #{departure_airport} to #{arrival_airport} at #{departure_time} arriving at #{arrival_time} with luggage #{luggage}"
        end
      end
    end

    def parse_time(date, time_str)
      Time.zone ? Time.zone.parse("#{date} #{time_str}") : Time.parse("#{date} #{time_str}")
    end

    def close
      @driver.quit
    end
  end
end


# scraper = Alsaboor::FlightScraper.new(
#   agent_code: "454",
#   email: "HASNAINTRAVELANDTOURS@GMAIL.COM",
#   password: "1707813016"
# )

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
