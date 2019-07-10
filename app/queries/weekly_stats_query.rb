class WeeklyStatsQuery
  def self.weekly_distance(relation: Trip)
    relation
      .where('created_at > ?', 1.week.ago)
      .sum(:distance)
  end

  def self.weekly_price(relation: Trip)
    relation
      .where('created_at > ?', 1.week.ago)
      .sum(:price)
  end
end