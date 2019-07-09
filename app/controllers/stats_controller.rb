class StatsController < ApplicationController
  def weekly
    total_distance = Trip.weekly_distance
    total_price = Trip.weekly_price
    render json: {
      total_distance: "#{total_distance}km",
      total_price: "#{total_price}PLN"
    }, status: 200
  end

  def monthly
    monthly_stats = DistanceQuery.monthly_statistics
    render json: monthly_stats, status: 200
  end
end
