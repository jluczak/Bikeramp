class TripsController < ApplicationController
  def show
    render json: TripSerializer.new(trip)
  end

  def index
    trips = Trip.all

    render json: TripSerializer.new(trips)
  end

  def create
    trip = Trip.create!(trip_params)

    render json: TripSerializer.new(trip), status: 201
  end

  def update
    trip.update!(trip_params)

    render json: TripSerializer.new(trip)
  end

  def destroy
    trip.destroy!
  end

  private

  def trip
    trip ||= Trip.find(params[:id])
  end

  def trip_params
    params.permit(:start_address, :destination_address, :price)
  end
end
