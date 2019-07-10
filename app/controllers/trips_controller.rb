class TripsController < ApplicationController
  rescue_from AddressNotFound, with: :render_address_not_found

  def show
    render json: TripSerializer.new(trip), status: 200
  end

  def index
    trips = Trip.all

    render json: TripSerializer.new(trips), status: 200
  end

  def create
    trip = Trip.new(trip_params.merge(distance: calculate_distance))
    trip.save
    render json: TripSerializer.new(trip), status: 201
  end

  def update
    trip.update(trip_params.merge(distance: calculate_distance))
    render json: TripSerializer.new(trip), status: 200
  end

  def destroy
    trip.destroy!
  end

  private

  def trip
    @trip ||= Trip.find(params[:id])
  end

  def trip_params
    params.permit(:start_address, :destination_address, :price)
  end

  def calculate_distance
    distance_calculator = DistanceCalculator.new(
      Geokit::Geocoders::GoogleGeocoder,
      trip_params[:start_address],
      trip_params[:destination_address]
    )

    distance_calculator.call
  end

  def render_address_not_found(address_not_found)
    render json: address_not_found.messages, status: 422
  end
end
