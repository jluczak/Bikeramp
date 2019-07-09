class Trip < ApplicationRecord
  validates_presence_of :start_address, :destination_address
  validates :price, :distance, numericality: { greater_than: 0 }

  scope :weekly_distance, -> { WeeklyStatsQuery.weekly_distance }
  scope :weekly_price, -> { WeeklyStatsQuery.weekly_price }
end
