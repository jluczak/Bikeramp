class StatsController < ApplicationController
  def weekly
    total_distance = Trip.where(created_at: 1.week.ago..Time.current).sum(:distance)
    render json: {total_distance: "#{total_distance}km"}, status: 200
  end

  def monthly
  end
end
