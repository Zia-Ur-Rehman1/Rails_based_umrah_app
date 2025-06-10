class HotelsController < ApplicationController
  before_action :set_hotel, only: %i[ show edit update destroy ]

  # GET /hotels or /hotels.json
  def index
    @hotels = Hotel.all
  end

  # GET /hotels/1 or /hotels/1.json
  def show
  end

  # GET /hotels/new
  def new
    @hotel = Hotel.new
    build_default_room_types
  end

  # GET /hotels/1/edit
  def edit
    existing_room_type_ids = @hotel.hotel_rooms.pluck(:room_type_id)
    RoomType.where.not(id: existing_room_type_ids).each do |room_type|
      @hotel.hotel_rooms.build(room_type: room_type)
    end
  end

  # POST /hotels or /hotels.json
  def create
    @hotel = Hotel.new(hotel_params)

    respond_to do |format|
      if @hotel.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("hotels", partial: "hotels/hotel", locals: { hotel: @hotel }),
            turbo_stream.replace("new_hotel", partial: "hotels/form", locals: { hotel: Hotel.new })
          ]
        end
        format.html { redirect_to @hotel, notice: "Hotel was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("hotel_form", partial: "hotels/form", locals: { hotel: @hotel })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /hotels/1 or /hotels/1.json
  def update
    respond_to do |format|
      if @hotel.update(hotel_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@hotel, partial: "hotels/hotel", locals: { hotel: @hotel })
        end
        format.html { redirect_to @hotel, notice: "Hotel was successfully updated." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("hotel_form", partial: "hotels/form", locals: { hotel: @hotel })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /hotels/1 or /hotels/1.json
  def destroy
    @hotel.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@hotel) }
      format.html { redirect_to hotels_url, notice: "Hotel was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel
      @hotel = Hotel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hotel_params
      params.require(:hotel).permit(
      :name, :city, :category, :distance, :agency, :agency_contact, :landmark, :gate_proximity, :transport_access,
      hotel_rooms_attributes: [ :id, :room_type_id, :base_price, :_destroy ]
    )
    end

    def build_default_room_types
      RoomType.all.each do |room_type|
        @hotel.hotel_rooms.build(room_type: room_type)
      end
    end
end
