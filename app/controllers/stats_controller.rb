class StatsController < ApplicationController
  def weekly
    total_distance = WeeklyStatsQuery.weekly_distance
    total_price = WeeklyStatsQuery.weekly_price
    render json: {
      total_distance: "#{total_distance}km",
      total_price: "#{total_price}PLN"
    }, status: 200
  end

  def monthly
    monthly_stats = MonthlyStatsQuery.monthly_stats
    render json: monthly_stats, status: 200
  end
end
