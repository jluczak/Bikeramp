class TripsController < ApplicationController
  def show
    render json: TripSerializer.new(trip)
  end

  def index
    trips = Trip.all

    render json: TripSerializer.new(trips)
  end

  def create
    trip = Trip.new(trip_params)
    set_distance(trip)
    trip.save!
    render json: TripSerializer.new(trip), status: 201
  rescue AddressNotFound => address_not_found
    render json: address_not_found.messages, status: 422
  end

  def update
    set_distance(trip)
    trip.update!(trip_params)
    render json: TripSerializer.new(trip)
  rescue AddressNotFound => address_not_found
    render json: address_not_found.messages, status: 422
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

  def set_distance(trip)
    geo = DistanceCalculator
          .new(Geokit::Geocoders::GoogleGeocoder,
               params[:start_address],
               params[:destination_address]).call
    trip.distance = geo
  end
end
