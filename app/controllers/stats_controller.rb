class StatsController < ApplicationController
  def weekly
    render json: "stats", status: 200
  end

  def monthly
  end
end
