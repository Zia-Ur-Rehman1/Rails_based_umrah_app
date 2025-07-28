class FlightsController < ApplicationController
  before_action :set_flight, only: %i[ show edit update destroy ]

  def index
    @flights = Flight.order(departure_time: :asc)
  end

  def show
  end

  def new
    @flight = Flight.new
  end

  def edit
  end

  def create
    @flight = Flight.new(flight_params)

    if @flight.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("flights", partial: "flights/flight", locals: { flight: @flight }),
            turbo_stream.replace("flight_form", partial: "flights/form", locals: { flight: Flight.new })
          ]
        end
        format.html { redirect_to @flight, notice: "Flight was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flight_form", partial: "flights/form", locals: { flight: @flight })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @flight.update(flight_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flight_#{@flight.id}", partial: "flights/flight", locals: { flight: @flight })
        end
        format.html { redirect_to @flight, notice: "Flight was successfully updated." }
sss      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flight_form", partial: "flights/form", locals: { flight: @flight })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @flight.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("flight_#{@flight.id}") }
      format.html { redirect_to flights_path, notice: "Flight was successfully destroyed." }
    end
  end

  private

    def set_flight
      @flight = Flight.find(params[:id])
    end

    def flight_params
      params.require(:flight).permit(:airline, :flight_number, :departure_airport, :arrival_airport, :departure_time, :arrival_time, :luggage, :seats, :trip_type, :connected_flight_id, :unique_code, :agency, :days)
    end
end
