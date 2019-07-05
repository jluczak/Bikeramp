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
    trip.errors.merge!(set_distance(trip))
    if trip.errors.empty?
      trip.save!
      render json: TripSerializer.new(trip), status: 201
    else
      render json: trip.errors, status: 422
    end
  end

  def update
    trip.errors.merge!(set_distance(trip))
    if trip.errors.empty?
      trip.update!(trip_params)
      render json: TripSerializer.new(trip)
    else
      render json: trip.errors, status: 422
    end
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
    trip.distance = geo[:distance]
    geo[:errors]
  end
end
