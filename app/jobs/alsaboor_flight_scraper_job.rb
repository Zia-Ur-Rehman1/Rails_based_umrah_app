class AlsaboorFlightScraperJob < ApplicationJob
  queue_as :default

  def perform
    scraper = Alsaboor::FlightScrapper.new.login
    scraper.scrape_deals
    scraper.close
  end
end
