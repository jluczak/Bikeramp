class TripsController < ApplicationController
  def show
    render json: trip.to_json(only: serialized_params)
  end

  def index
    trips = Trip.all

    render json: trips.to_json(only: serialized_params)
  end

  def create
    trip = Trip.create!(trip_params)

    render json: trip.to_json(only: serialized_params), status: 201
  end

  def update
    trip.update!(trip_params)

    render json: trip.to_json(only: serialized_params)
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

  def serialized_params
    %i[start_address destination_address price distance]
  end
end
