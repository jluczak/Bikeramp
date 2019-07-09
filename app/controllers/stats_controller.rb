class StatsController < ApplicationController
  def weekly
    total_distance = Trip.weekly_distance
    render json: {total_distance: "#{total_distance}km"}, status: 200
  end

  def monthly
  end
end
