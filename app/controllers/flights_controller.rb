class FlightsController < ApplicationController
  before_action :set_flight, only: %i[ show edit update destroy ]

  # GET /flights or /flights.json
  def index
    @flights = Flight.all
  end

  # GET /flights/1 or /flights/1.json
  def show
  end

  # GET /flights/new
  def new
    @flight = Flight.new
  end

  # GET /flights/1/edit
  def edit
  end

  # POST /flights or /flights.json
  def create
    @flight = Flight.new(flight_params)

    respond_to do |format|
      if @flight.save
        format.html { redirect_to @flight, notice: "Flight was successfully created." }
        format.json { render :show, status: :created, location: @flight }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flights/1 or /flights/1.json
  def update
    respond_to do |format|
      if @flight.update(flight_params)
        format.html { redirect_to @flight, notice: "Flight was successfully updated." }
        format.json { render :show, status: :ok, location: @flight }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1 or /flights/1.json
  def destroy
    @flight.destroy!

    respond_to do |format|
      format.html { redirect_to flights_path, status: :see_other, notice: "Flight was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def scrape
    begin
      scraper = Alsaboor::FlightScraper.new(
        agent_code: "454",
        email: "HASNAINTRAVELANDTOURS@GMAIL.COM",
        password: "1707813016"
      )

      scraper.login.scrape_deals
      scraper.close

      flash[:success] = "Flight data scraped successfully!"
    rescue => e
      flash[:error] = "Scraping failed: #{e.message}"
      Rails.logger.error "Scraping error: #{e.backtrace.join("\n")}"
    ensure
      redirect_to flights_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flight
      @flight = Flight.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def flight_params
      params.expect(flight: [ :airline, :flight_number, :departure_airport, :arrival_airport, :departure_time, :arrival_time, :luggage, :meal ])
    end
end
